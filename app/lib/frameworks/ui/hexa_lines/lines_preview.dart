import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../../../adapters/presentation/game/game_screen_state.dart';
import '../board/board_preview.dart';

/// The cells the board draws for the preview of a Hexa Lines move (HL-02):
/// the piece of the move's slot put on its anchor (D-92), only where there
/// is a board cell. Whether it is valid comes from the check (D-138).
///
/// `null` if the slot has no piece or no cell of the piece is on the board.
BoardPreview<C, PieceColor>? linesPreviewOf<C extends Coord>(
  LinesState<C> state,
  MovePreview<PlacePiece<C>> preview,
) {
  final move = preview.move;
  if (move.trayIndex < 0 || move.trayIndex >= state.tray.length) return null;
  final piece = state.tray[move.trayIndex];
  if (piece == null) return null;
  final board = state.board;
  final cells = [...?board.topology.place(piece.shape, move.anchor)]
      .where(board.contains);
  if (cells.isEmpty) return null;
  return BoardPreview(
    cells: cells,
    content: piece.color,
    valid: preview.isValid,
  );
}
