import 'package:hexa_engine/hexa_engine.dart';

import 'lines_piece.dart';
import 'lines_state.dart';

/// The rules of Hexa Lines: only the steps of the turn (D-36).
///
/// A turn places a piece (`apply`, RN-HL-30 to 32) and clears the complete
/// lines (`resolve`, RN-HL-40 to 43); each step adds the points of its own
/// events with the injected scoring (RN-HL-60 to 64, D-98). The new tray
/// (HL-04) is the `afterResolve` step still to come. The end of the game is
/// the default `evaluate`: a defeat when no piece of the tray fits
/// (RN-HL-50, 51).
final class HexaLinesRules<C extends Coord>
    extends GameRules<C, PieceColor, PlacePiece<C>, LinesState<C>> {
  /// The rules of Hexa Lines, scored by [scoring] (D-100: the factory
  /// chooses it).
  const HexaLinesRules(this._scoring);

  final IScoringPolicy<LinesState<C>, LinesEvent<C>> _scoring;

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

  /// Fills the cells with the piece's color and empties its slot (RN-HL-32),
  /// and scores the placed cells (RN-HL-60).
  @override
  Step<C, LinesState<C>> apply(LinesState<C> state, PlacePiece<C> move) {
    final (piece, cells) =
        _placement(state, move) ??
        (throw StateError('apply called with a rejected move: $move'));
    final tray = [...state.tray]..[move.trayIndex] = null;
    return _scored(
      state.copyWith(
        board: state.board.withCells({for (final c in cells) c: piece.color}),
        tray: tray,
      ),
      [PiecePlaced(move.trayIndex, cells)],
    );
  }

  /// Empties every complete line of every axis at once (RN-HL-40, 41), each
  /// shared cell once (RN-HL-42), updates the streak and scores the bonus
  /// (RN-HL-61 to 64).
  ///
  /// One pass is enough: emptying cells never completes a line
  /// (RN-HL-43). It checks every line of the board instead of only those
  /// through the placed piece (RN-HL-44), which gives the same lines and
  /// needs nothing from the move.
  @override
  Step<C, LinesState<C>> resolve(LinesState<C> state) {
    final board = state.board;
    final lines = [
      for (final line in board.lines())
        if (line.every((cell) => board.cell(cell) != null)) line,
    ];
    if (lines.isEmpty) return Step(state.copyWith(streak: 0));
    final cleared = {for (final line in lines) ...line};
    final streak = state.streak + 1;
    return _scored(
      state.copyWith(
        board: board.withCells({for (final cell in cleared) cell: null}),
        streak: streak,
      ),
      [LinesCleared(lines, cleared, streak: streak)],
    );
  }

  /// A step that leaves [state] with [events] and their points added.
  Step<C, LinesState<C>> _scored(
    LinesState<C> state,
    List<LinesEvent<C>> events,
  ) => Step(
    state.copyWith(score: state.score + _scoring.pointsFor(state, events)),
    events,
  );

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
