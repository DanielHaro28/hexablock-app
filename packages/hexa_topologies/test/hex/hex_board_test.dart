import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:test/test.dart';

void main() {
  group('D-07', () {
    test('should_be_a_board_of_hex_coordinates_when_using_the_alias', () {
      // Arrange
      final spec = ShapeSpec(HexTopology.hexagon, [4]);

      // Act
      final board = HexBoard<FakeCell>.of(const HexTopology(), spec);

      // Assert
      expect(board, isA<Board<HexCoord, FakeCell>>());
      expect(board.cells, hasLength(61));
    });

    test('should_hold_contents_when_filling_a_hex_board', () {
      // Arrange
      final board = HexBoard<FakeCell>.of(
        const HexTopology(),
        ShapeSpec(HexTopology.hexagon, [2]),
      );
      const cell = HexCoord(1, -1);

      // Act
      final filled = board.withCells({cell: const FakeCell('red')});

      // Assert
      expect(filled.cell(cell), const FakeCell('red'));
      expect(board.cell(cell), isNull);
    });
  });
}
