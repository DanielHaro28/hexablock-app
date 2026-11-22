import '../board/coord.dart';
import 'game_event.dart';
import 'game_outcome.dart';
import 'rejection_reason.dart';

/// What `GameEngine.submit` returns to whoever submitted the move (D-32).
///
/// The screen receives it in the same call, through the use case, and
/// animates [events] in order. [events] are exactly the events the engine
/// published on its streams for this call (D-94).
///
/// `TState` has no constraint here on purpose: these are plain carriers that
/// never read the state. Constraining it to `GameState<C, TCell>` would force
/// a `TCell` parameter on every result type for nothing; `IGameRules` and
/// `GameEngine`, which do read it, carry the constraint (ARQ-02 §4.3).
sealed class MoveResult<C extends Coord, TState> {
  const MoveResult(this.events);

  /// What happened, in order.
  final List<GameEvent<C>> events;
}

/// The move was played.
final class AcceptedMove<C extends Coord, TState>
    extends MoveResult<C, TState> {
  const AcceptedMove(this.state, List<GameEvent<C>> events, this.outcome)
    : super(events);

  /// The state after the turn.
  final TState state;

  /// How the turn leaves the game.
  final GameOutcome outcome;
}

/// The move was rejected and the game did not change (RN-COM-21,
/// RN-COM-24). Its only event is a `MoveRejected` with the same [reason].
final class RejectedMove<C extends Coord, TState>
    extends MoveResult<C, TState> {
  const RejectedMove(this.reason, List<GameEvent<C>> events) : super(events);

  /// Why it was rejected (D-95).
  final RejectionReason reason;
}
