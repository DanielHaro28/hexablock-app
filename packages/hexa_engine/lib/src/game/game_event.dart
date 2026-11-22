import '../board/coord.dart';
import 'game_phase.dart';
import 'rejection_reason.dart';

/// Something that happened in the game, in the order it happened
/// (RN-COM-25, D-32).
///
/// The rules return their events with each step of the turn; the engine adds
/// its own ([PhaseChanged], [ScoreChanged], [MoveRejected], [StateRestored]),
/// returns those of a turn in the `MoveResult` of `submit` and publishes the
/// same list on its streams.
///
/// It is `abstract base` and not sealed because Dart only lets a sealed class
/// be extended in its own library, and the variants live in another package:
/// each variant defines its own sealed family on top of this base.
abstract base class GameEvent<C extends Coord> {
  const GameEvent();
}

/// The game went from phase [from] to phase [to] (D-34, D-94).
final class PhaseChanged<C extends Coord> extends GameEvent<C> {
  const PhaseChanged(this.from, this.to);

  /// The phase before.
  final GamePhase from;

  /// The phase after.
  final GamePhase to;

  @override
  bool operator ==(Object other) =>
      other is PhaseChanged<C> && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(PhaseChanged, from, to);

  @override
  String toString() => 'PhaseChanged($from → $to)';
}

/// The engine went back or forward to a saved state: a turn was undone or
/// redone (D-31, D-103).
///
/// It has no fields because events are generic only in the coordinate: the
/// restored state is `engine.state`. The engine does not know whether it was
/// an undo or a redo; the undo history does. If the score changed, a
/// `ScoreChanged` follows it.
final class StateRestored<C extends Coord> extends GameEvent<C> {
  const StateRestored();

  @override
  bool operator ==(Object other) => other is StateRestored<C>;

  @override
  int get hashCode => (StateRestored).hashCode;

  @override
  String toString() => 'StateRestored()';
}

/// The score went from [from] to [to] (D-94): during a turn, where it only
/// goes up (RN-COM-50), or after a restore, where it goes back (D-103).
final class ScoreChanged<C extends Coord> extends GameEvent<C> {
  const ScoreChanged(this.from, this.to);

  /// The score before the turn.
  final int from;

  /// The score after the turn.
  final int to;

  @override
  bool operator ==(Object other) =>
      other is ScoreChanged<C> && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(ScoreChanged, from, to);

  @override
  String toString() => 'ScoreChanged($from → $to)';
}

/// A submitted move was rejected because of [reason] (RN-COM-21,
/// RN-COM-24); for example, to play an error sound.
///
/// Not to be confused with `RejectedMove`, what `submit` returns (ARQ-02 §6).
final class MoveRejected<C extends Coord> extends GameEvent<C> {
  const MoveRejected(this.reason);

  /// Why it was rejected (D-95).
  final RejectionReason reason;

  @override
  bool operator ==(Object other) =>
      other is MoveRejected<C> && other.reason == reason;

  @override
  int get hashCode => Object.hash(MoveRejected, reason);

  @override
  String toString() => 'MoveRejected($reason)';
}
