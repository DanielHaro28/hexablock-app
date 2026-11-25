import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

/// Hexa Lines on a topology with two cell types (like triangles ▲ and ▼),
/// to show that the variant assumes no cell shape (RNF-04, D-25).
void main() {
  const topology = FakeCheckeredTopology();
  const color = PieceColor('red');

  Shape<FakeCoord> shapeOf(List<(int, int)> cells) =>
      Shape.fromCells([for (final (x, y) in cells) FakeCoord(x, y)]);

  final config = LinesConfig(
    board: ShapeSpec(FakeTopology.rectangle, [4, 4]),
    catalog: [
      LinesFamily(shape: shapeOf([(0, 0)]), weight: 50, color: color),
      LinesFamily(shape: shapeOf([(0, 0), (1, 0)]), weight: 50, color: color),
    ],
    scoring: LinesScoringConfig(pointsPerLineCell: 5, maxStreakMultiplier: 3),
  );

  HexaLinesFactory<FakeCoord> factory() => HexaLinesFactory(topology, config);

  group('D-116', () {
    checkVariantFamilyContract(
      factory,
      NewGameOptions(seed: 42),
      usesChance: true,
    );
  });

  group('RN-HL-31', () {
    /// A state whose first slot holds a single even cell.
    LinesState<FakeCoord> withEvenMono() => LinesState(
      board: Board<FakeCoord, PieceColor>.of(topology, config.board),
      tray: [
        LinesPiece(shapeOf([(0, 0)]), color),
        null,
        null,
      ],
      random: Xorshift32(1),
      seed: 1,
    );

    test('should_reject_when_the_anchor_is_of_another_cell_type', () {
      // Arrange
      final state = withEvenMono();
      const move = PlacePiece(0, FakeCoord(1, 0)); // odd cell

      // Act
      final reason = factory().createRules().rejectionOf(state, move);

      // Assert
      expect(reason, const InvalidMove());
    });

    test('should_accept_when_the_anchor_is_of_the_same_cell_type', () {
      // Arrange
      final state = withEvenMono();
      const move = PlacePiece(0, FakeCoord(1, 1)); // even cell

      // Act
      final reason = factory().createRules().rejectionOf(state, move);

      // Assert
      expect(reason, isNull);
    });
  });

  group('RN-HL-40', () {
    test('should_clear_and_score_a_row_when_it_is_complete_on_any_shape', () {
      // Arrange: row y = 0 of the 4 × 4 board but its last two cells.
      final state = LinesState(
        board: Board<FakeCoord, PieceColor>.of(topology, config.board)
            .withCells({
              const FakeCoord(0, 0): color,
              const FakeCoord(1, 0): color,
            }),
        tray: [
          LinesPiece(shapeOf([(0, 0), (1, 0)]), color),
          null,
          null,
        ],
        random: Xorshift32(1),
        seed: 1,
      );
      const move = PlacePiece(0, FakeCoord(2, 0)); // even, like (0, 0)

      // Act
      final turn = factory().createRules().playTurn(state, move);

      // Assert: 2 cells + ⌊5 × 4 × 1 × 2 / 2⌋.
      expect(turn.state.board.contents, isEmpty);
      expect(turn.state.score, 22);
    });
  });

  group('RN-HL-21', () {
    test(
      'should_draw_a_full_tray_when_the_last_piece_is_placed_on_any_shape',
      () {
        // Arrange
        final state = LinesState(
          board: Board<FakeCoord, PieceColor>.of(topology, config.board),
          tray: [
            LinesPiece(shapeOf([(0, 0)]), color),
            null,
            null,
          ],
          random: Xorshift32(1),
          seed: 1,
        );
        const move = PlacePiece(0, FakeCoord(0, 0));

        // Act
        final turn = factory().createRules().playTurn(state, move);

        // Assert
        expect(turn.state.tray, everyElement(isNotNull));
        expect(turn.state.random, isNot(state.random));
      },
    );
  });
}
