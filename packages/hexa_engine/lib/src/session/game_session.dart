import '../board/coord.dart';
import '../game/game_engine.dart';
import '../game/game_state.dart';
import '../time/active_timer.dart';
import '../undo/undo_history.dart';
import 'capabilities.dart';
import 'saved_game.dart';

/// A game being played: the engine and only the capabilities this game has
/// (D-33, ARQ-02 §7).
///
/// The variant's factory builds it. A capability the game does not have is
/// `null`: the screen shows the undo button only if [undo] is not `null`, and
/// the clock only if [timer] is not, without asking which variant it is. The
/// capabilities of the state (`IRandomSeeded`, `ILevelBased`) are read from
/// `engine.state`.
///
/// It keeps the history and the timer with their own types so that
/// [snapshot] can save them (D-113), but it shows them to the screen only as
/// the capabilities [IUndoable] and [ITimed] (ISP).
///
/// Type constraints: the same as `GameEngine`.
final class GameSession<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> {
  /// A session for [engine] with the given capabilities: `undo` and `timer`.
  const GameSession(this.engine, {this._undo, this._timer});

  /// The engine that plays the game.
  final GameEngine<C, TCell, TMove, TState> engine;

  final UndoHistory<TMove, TState>? _undo;
  final ActiveTimer? _timer;

  /// Undo and redo, if the game allows it (RN-COM-60).
  IUndoable? get undo => _undo;

  /// The active time, if the game measures it (RN-COM-52).
  ITimed? get timer => _timer;

  /// What a saved game keeps of this session: the state, the undo history
  /// and the active time, read together (RN-COM-33, D-113).
  ///
  /// Call it once `submit`, `undo` or `redo` has returned, never from a
  /// listener of the engine's streams: the engine publishes the events of a
  /// turn before the history records it, so a snapshot taken inside a
  /// listener would miss the last turn.
  SavedGame<TState> snapshot() => SavedGame(
    engine.state,
    undo: _undo?.snapshot(),
    activeTime: _timer?.activeTime,
  );
}
