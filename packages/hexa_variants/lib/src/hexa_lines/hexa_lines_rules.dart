import 'package:hexa_engine/hexa_engine.dart';

import 'lines_piece.dart';
import 'lines_state.dart';

/// The rules of Hexa Lines: only the steps of the turn (D-36).
///
/// For now a turn places a piece (RN-HL-30 to 32). Clearing lines (HL-03),
/// scoring (HL-06) and the new tray (HL-04) are the `resolve` and
/// `afterResolve` steps still to come. The end of the game is the default
/// `evaluate`: a defeat when no piece of the tray fits (RN-HL-50, 51).
final class HexaLinesRules<C extends Coord>
    extends GameRules<C, PieceColor, PlacePiece<C>, LinesState<C>> {
  /// The rules of Hexa Lines.
  const HexaLinesRules();

  /// Every slot and anchor where a tray piece fits, slot by slot and the
  /// anchors in reading order. Lazy, so asking whether there is one stops at
  /// the first.
  @override
  Iterable<PlacePiece<C>> validMoves(LinesState<C> state) sync* {
    for (var index = 0; index < state.tray.length; index++) {
      for (final anchor in state.board.cells) {
        final move = PlacePiece(index, anchor);
        if (_placement(state, move) != null) yield move;
      }
    }
  }

  /// [InvalidMove] if the slot is empty or some cell of the piece is off
  /// the board or occupied (RN-HL-31); nothing changes then (RN-HL-32).
  @override
  RejectionReason? rejectionOf(LinesState<C> state, PlacePiece<C> move) =>
      _placement(state, move) == null ? const InvalidMove() : null;

  /// Fills the cells with the piece's color and empties its slot (RN-HL-32).
  @override
  Step<C, LinesState<C>> apply(LinesState<C> state, PlacePiece<C> move) {
    final (piece, cells) =
        _placement(state, move) ??
        (throw StateError('apply called with a rejected move: $move'));
    final tray = [...state.tray]..[move.trayIndex] = null;
    return Step(
      state.copyWith(
        board: state.board.withCells({for (final c in cells) c: piece.color}),
        tray: tray,
      ),
      [PiecePlaced(move.trayIndex, cells)],
    );
  }

  /// The piece and the cells it would fill, or `null` if it does not fit.
  (LinesPiece<C>, Set<C>)? _placement(LinesState<C> state, PlacePiece<C> move) {
    final index = move.trayIndex;
    if (index < 0 || index >= state.tray.length) return null;
    final piece = state.tray[index];
    if (piece == null) return null;
    final board = state.board;
    final cells = board.topology.place(piece.shape, move.anchor);
    if (cells == null) return null;
    for (final cell in cells) {
      if (!board.contains(cell) || board.cell(cell) != null) return null;
    }
    return (piece, cells);
  }
}
