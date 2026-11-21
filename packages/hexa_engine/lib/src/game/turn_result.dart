import '../board/coord.dart';
import 'game_event.dart';
import 'game_outcome.dart';
import 'rejection_reason.dart';

/// The result of one step of a turn: the new state and the events of that
/// step, in order (RN-COM-25).
final class Step<C extends Coord, TState> {
  const Step(this.state, [this.events = const []]);

  /// The state after the step.
  final TState state;

  /// What the step did, in order.
  final List<GameEvent<C>> events;
}

/// The result of `playTurn`: a played turn or a rejected move.
sealed class TurnResult<C extends Coord, TState> {
  const TurnResult(this.state);

  /// The state after the turn; the same state if the move was rejected.
  final TState state;
}

/// A valid move, played to the end (RN-COM-20).
final class PlayedTurn<C extends Coord, TState> extends TurnResult<C, TState> {
  const PlayedTurn(super.state, {required this.events, required this.outcome});

  /// The events of every step, in order (RN-COM-25).
  final List<GameEvent<C>> events;

  /// How the turn leaves the game, evaluated after resolving (RN-COM-23).
  final GameOutcome outcome;
}

/// An invalid move: [state] is the state it was given, unchanged
/// (RN-COM-21).
final class RejectedTurn<C extends Coord, TState>
    extends TurnResult<C, TState> {
  const RejectedTurn(super.state, this.reason);

  /// Why the rules rejected it (D-95).
  final RejectionReason reason;
}
