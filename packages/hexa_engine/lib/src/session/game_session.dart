import '../board/coord.dart';
import '../game/game_engine.dart';
import '../game/game_state.dart';
import 'capabilities.dart';

/// A game being played: the engine and only the capabilities this game has
/// (D-33, ARQ-02 §7).
///
/// The variant's factory builds it. A capability the game does not have is
/// `null`: the screen shows the undo button only if [undo] is not `null`, and
/// the clock only if [timer] is not, without asking which variant it is. The
/// capabilities of the state (`IRandomSeeded`, `ILevelBased`) are read from
/// `engine.state`.
///
/// Type constraints: the same as `GameEngine`.
final class GameSession<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> {
  /// A session for [engine] with the given capabilities.
  const GameSession(this.engine, {this.undo, this.timer});

  /// The engine that plays the game.
  final GameEngine<C, TCell, TMove, TState> engine;

  /// Undo and redo, if the game allows it (RN-COM-60).
  final IUndoable? undo;

  /// The active time, if the game measures it (RN-COM-52).
  final ITimed? timer;
}
