import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

void main() {
  /// A state whose streak is [streak]; the policies read nothing else.
  LinesState<HexCoord> stateWith({int streak = 0}) => LinesState(
    board: Board<HexCoord, PieceColor>.of(hexTopology, hexRadius4),
    tray: [null, null, null],
    random: Xorshift32(7),
    seed: 7,
    streak: streak,
  );

  /// A line of [length] cells; the policies only read its length.
  List<HexCoord> lineOf(int length) => [
    for (var q = 0; q < length; q++) HexCoord(q, 0),
  ];

  LinesCleared<HexCoord> cleared(List<int> lengths, {int streak = 1}) {
    final lines = [for (final length in lengths) lineOf(length)];
    return LinesCleared(lines, {
      for (final line in lines) ...line,
    }, streak: streak);
  }

  final placed = PiecePlaced<HexCoord>(0, {const HexCoord(0, 0)});

  group('RN-HL-61', () {
    test('should_give_5_points_per_cell_of_each_line_when_lines_clear', () {
      // Arrange
      const policy = LineBonus<HexCoord>();

      // Act
      final points = policy.pointsFor(stateWith(), [
        cleared([5]),
      ]);

      // Assert
      expect(points, 25);
    });

    test('should_give_nothing_when_no_line_is_cleared', () {
      // Arrange
      const policy = LineBonus<HexCoord>();

      // Act
      final points = policy.pointsFor(stateWith(), [placed]);

      // Assert
      expect(points, 0);
    });
  });

  group('RN-HL-62', () {
    test('should_multiply_the_bonus_by_the_number_of_lines_when_3_clear', () {
      // Arrange
      const policy = LineBonus<HexCoord>();

      // Act: (25 + 30 + 45) × 3.
      final points = policy.pointsFor(stateWith(), [
        cleared([5, 6, 9]),
      ]);

      // Assert
      expect(points, 300);
    });
  });

  group('RN-HL-63', () {
    final cases = {1: 25, 2: 37, 3: 50, 4: 62, 5: 75, 9: 75};
    for (final MapEntry(key: streak, value: expected) in cases.entries) {
      test('should_give_${expected}_for_a_bonus_of_25_when_the_streak_is_'
          '$streak', () {
        // Arrange
        const policy = StreakMultiplier<HexCoord>(LineBonus());

        // Act
        final points = policy.pointsFor(stateWith(streak: streak), [
          cleared([5], streak: streak),
        ]);

        // Assert
        expect(points, expected);
      });
    }

    test('should_give_nothing_when_the_wrapped_policy_gives_nothing', () {
      // Arrange
      const policy = StreakMultiplier<HexCoord>(LineBonus());

      // Act
      final points = policy.pointsFor(stateWith(streak: 3), [placed]);

      // Assert
      expect(points, 0);
    });
  });

  group('RN-HL-64', () {
    test('should_round_down_once_when_the_multiplier_has_a_half', () {
      // Arrange: ⌊(25 + 30) × 2 × 3 / 2⌋ = 165, an odd bonus × L.
      const policy = StreakMultiplier<HexCoord>(LineBonus());

      // Act
      final points = policy.pointsFor(stateWith(streak: 2), [
        cleared([5, 6], streak: 2),
      ]);

      // Assert
      expect(points, 165);
    });
  });

  group('RN-HL-60', () {
    test('should_give_one_point_per_placed_cell_when_a_piece_is_placed', () {
      // Arrange
      const policy = LinesScoring<HexCoord>(LineBonus());
      final piece = PiecePlaced<HexCoord>(0, {
        const HexCoord(0, 0),
        const HexCoord(1, 0),
        const HexCoord(2, 0),
      });

      // Act
      final points = policy.pointsFor(stateWith(), [piece]);

      // Assert
      expect(points, 3);
    });

    test('should_add_the_wrapped_line_bonus_when_lines_clear', () {
      // Arrange
      const policy = LinesScoring<HexCoord>(LineBonus());

      // Act
      final points = policy.pointsFor(stateWith(), [
        cleared([5]),
      ]);

      // Assert
      expect(points, 25);
    });
  });
}
