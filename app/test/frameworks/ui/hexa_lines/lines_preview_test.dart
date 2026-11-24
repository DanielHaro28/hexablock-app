import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/adapters/presentation/game/game_screen_state.dart';
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_preview.dart';

void main() {
  const blue = PieceColor('blue');
  final domino = LinesPiece(
    Shape.fromCells(const [HexCoord(0, 0), HexCoord(1, 0)]),
    blue,
  );

  LinesState<HexCoord> stateWith(List<LinesPiece<HexCoord>?> tray) =>
      LinesState(
        board: Board<HexCoord, PieceColor>.of(
          const HexTopology(),
          ShapeSpec(HexTopology.hexagon, const [4]),
        ),
        tray: tray,
        random: Xorshift32(7),
        seed: 7,
      );

  group('HL-02', () {
    test('should_take_the_cells_and_color_of_the_piece_when_it_is_valid', () {
      // Arrange
      final state = stateWith([domino, null, null]);
      const preview = MovePreview(PlacePiece(0, HexCoord(0, 0)));

      // Act
      final drawn = linesPreviewOf(state, preview);

      // Assert
      expect(drawn?.cells, {const HexCoord(0, 0), const HexCoord(1, 0)});
      expect(drawn?.content, blue);
      expect(drawn?.valid, isTrue);
    });

    test('should_be_invalid_when_the_check_gives_a_reason', () {
      // Arrange
      final state = stateWith([domino, null, null]);
      const preview = MovePreview(
        PlacePiece(0, HexCoord(0, 0)),
        rejection: InvalidMove(),
      );

      // Act
      final drawn = linesPreviewOf(state, preview);

      // Assert
      expect(drawn?.valid, isFalse);
    });

    test('should_draw_nothing_when_the_slot_is_empty', () {
      // Arrange
      final state = stateWith([null, domino, null]);
      const preview = MovePreview(PlacePiece(0, HexCoord(0, 0)));

      // Act
      final drawn = linesPreviewOf(state, preview);

      // Assert
      expect(drawn, isNull);
    });

    test('should_draw_nothing_when_the_slot_does_not_exist', () {
      // Arrange
      final state = stateWith([domino, null, null]);
      const preview = MovePreview(PlacePiece(3, HexCoord(0, 0)));

      // Act
      final drawn = linesPreviewOf(state, preview);

      // Assert
      expect(drawn, isNull);
    });

    test('should_draw_nothing_when_no_cell_is_on_the_board', () {
      // Arrange
      final state = stateWith([domino, null, null]);
      const preview = MovePreview(PlacePiece(0, HexCoord(5, 0)));

      // Act
      final drawn = linesPreviewOf(state, preview);

      // Assert
      expect(drawn, isNull);
    });
  });
}
