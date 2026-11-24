import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

/// Clearing complete lines and scoring them (HL-03): RN-HL-40 to 44 and 60
/// to 64, with the rules as the factory wires them.
void main() {
  final rules = HexaLinesFactory(hexTopology, hexConfig).createRules();
  const red = PieceColor('red');
  const blue = PieceColor('blue');

  final domino = LinesPiece(shapeOf([(0, 0), (1, 0)]), blue);
  final mono = LinesPiece(shapeOf([(0, 0)]), blue);

  List<HexCoord> cellsOf(List<(int, int)> cells) => [
    for (final (q, r) in cells) HexCoord(q, r),
  ];

  /// A state on the radius-4 board with [occupied] cells, [tray] and the
  /// [streak] of the turns before.
  LinesState<HexCoord> stateWith({
    required List<(int, int)> occupied,
    required List<LinesPiece<HexCoord>?> tray,
    int streak = 0,
    int score = 0,
  }) => LinesState(
    board: Board<HexCoord, PieceColor>.of(
      hexTopology,
      hexRadius4,
    ).withCells({for (final cell in cellsOf(occupied)) cell: red}),
    tray: tray,
    random: Xorshift32(7),
    seed: 7,
    score: score,
    streak: streak,
  );

  /// The turn of [move] on [state]; fails the test if it is rejected.
  PlayedTurn<HexCoord, LinesState<HexCoord>> play(
    LinesState<HexCoord> state,
    PlacePiece<HexCoord> move,
  ) => switch (rules.playTurn(state, move)) {
    PlayedTurn<HexCoord, LinesState<HexCoord>>() && final played => played,
    RejectedTurn(:final reason) => fail('$move was rejected: $reason'),
  };

  /// The row r = −4, the line of E-HL-1 and E-HL-2.
  final rowMinus4 = cellsOf([(0, -4), (1, -4), (2, -4), (3, -4), (4, -4)]);

  /// The line q = 4 of E-HL-2.
  final column4 = cellsOf([(4, -4), (4, -3), (4, -2), (4, -1), (4, 0)]);

  group('E-HL-1', () {
    LinesState<HexCoord> example() => stateWith(
      occupied: [(0, -4), (1, -4), (2, -4)],
      tray: [domino, mono, mono],
    );
    const move = PlacePiece(0, HexCoord(3, -4));

    test('should_empty_the_row_when_the_domino_completes_it', () {
      // Act
      final turn = play(example(), move);

      // Assert
      expect(turn.state.board.contents, isEmpty);
    });

    test('should_score_27_when_one_line_of_5_is_cleared_with_k_1', () {
      // Act
      final turn = play(example(), move);

      // Assert
      expect(turn.state.score, 27);
      expect(turn.state.streak, 1);
    });

    test('should_publish_the_placed_piece_and_then_the_cleared_line', () {
      // Act
      final turn = play(example(), move);

      // Assert
      expect(turn.events, [
        PiecePlaced<HexCoord>(0, {
          const HexCoord(3, -4),
          const HexCoord(4, -4),
        }),
        LinesCleared<HexCoord>([rowMinus4], rowMinus4.toSet(), streak: 1),
      ]);
    });
  });

  group('E-HL-2', () {
    LinesState<HexCoord> example({int streak = 0}) => stateWith(
      occupied: [
        (0, -4), (1, -4), (2, -4), (3, -4), //
        (4, -3), (4, -2), (4, -1), (4, 0),
      ],
      tray: [mono, null, null],
      streak: streak,
    );
    const move = PlacePiece(0, HexCoord(4, -4));

    test('should_empty_the_shared_cell_once_when_two_lines_cross', () {
      // Act
      final turn = play(example(), move);

      // Assert
      final cleared = turn.events.whereType<LinesCleared<HexCoord>>().single;
      expect(cleared.lines, unorderedEquals([rowMinus4, column4]));
      expect(cleared.clearedCells, hasLength(9));
      expect(turn.state.board.contents, isEmpty);
    });

    test('should_score_101_when_two_lines_are_cleared_with_k_1', () {
      // Act
      final turn = play(example(), move);

      // Assert
      expect(turn.state.score, 101);
    });

    test('should_score_151_when_the_turn_before_also_cleared_lines', () {
      // Arrange
      final state = example(streak: 1);

      // Act
      final turn = play(state, move);

      // Assert
      expect(turn.state.score, 151);
      expect(turn.state.streak, 2);
    });
  });

  group('RN-HL-40', () {
    test('should_clear_a_line_of_another_axis_when_it_is_complete', () {
      // Arrange: the line s = 0 from (−4, 4) to (4, −4), but its centre.
      final diagonal = [
        for (var q = -4; q <= 4; q++)
          if (q != 0) (q, -q),
      ];
      final state = stateWith(occupied: diagonal, tray: [mono, null, null]);

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(0, 0)));

      // Assert: a line of 9, 1 + ⌊45 × 1 × 2 / 2⌋.
      expect(turn.state.board.contents, isEmpty);
      expect(turn.state.score, 46);
    });

    test('should_clear_nothing_when_no_line_is_complete', () {
      // Arrange
      final state = stateWith(occupied: [(0, -4)], tray: [domino, null, null]);

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(1, -4)));

      // Assert
      expect(turn.events, [
        PiecePlaced<HexCoord>(0, {
          const HexCoord(1, -4),
          const HexCoord(2, -4),
        }),
      ]);
      expect(turn.state.board.contents, hasLength(3));
    });
  });

  group('RN-HL-41', () {
    test('should_keep_the_cells_off_the_lines_when_clearing', () {
      // Arrange
      final state = stateWith(
        occupied: [(0, -4), (1, -4), (2, -4), (0, 0)],
        tray: [domino, null, null],
      );

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(3, -4)));

      // Assert
      expect(turn.state.board.contents.keys, [const HexCoord(0, 0)]);
    });
  });

  group('RN-HL-60', () {
    test('should_score_only_the_placed_cells_when_no_line_is_cleared', () {
      // Arrange
      final state = stateWith(
        occupied: [],
        tray: [domino, null, null],
        score: 10,
      );

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(0, 0)));

      // Assert
      expect(turn.state.score, 12);
    });
  });

  group('RN-HL-63', () {
    test('should_reset_the_streak_when_a_turn_clears_no_line', () {
      // Arrange
      final state = stateWith(
        occupied: [],
        tray: [mono, null, null],
        streak: 3,
      );

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(0, 0)));

      // Assert
      expect(turn.state.streak, 0);
    });

    test('should_multiply_the_bonus_by_3_when_the_streak_reaches_5', () {
      // Arrange: E-HL-1 after four turns in a row with lines.
      final state = stateWith(
        occupied: [(0, -4), (1, -4), (2, -4)],
        tray: [domino, null, null],
        streak: 4,
      );

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(3, -4)));

      // Assert: 2 + 25 × 1 × 3.
      expect(turn.state.score, 77);
      expect(turn.state.streak, 5);
    });
  });
}
