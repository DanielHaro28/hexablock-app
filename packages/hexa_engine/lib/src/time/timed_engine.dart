import '../board/coord.dart';
import '../game/game_event.dart';
import '../game/game_phase.dart';

/// What `ActiveTimer` needs from `GameEngine`, and nothing else (ISP): the
/// current phase and the events it publishes synchronously. `GameEngine`
/// implements it.
///
/// It is not generic: the timer only reads `PhaseChanged`, which does not
/// depend on the coordinate, so one timer serves every engine. A
/// `GameEngine<C, …>` fits because a `Stream<GameEvent<C>>` is a
/// `Stream<GameEvent<Coord>>` (Dart generics are covariant).
abstract interface class TimedEngine {
  /// The current phase.
  GamePhase get phase;

  /// Every event, delivered before the call that caused it returns (D-32).
  Stream<GameEvent<Coord>> get syncEvents;
}
