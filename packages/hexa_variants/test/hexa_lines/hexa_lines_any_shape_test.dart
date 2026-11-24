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
}
