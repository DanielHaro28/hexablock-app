import '../undo/undo_snapshot.dart';

/// Everything a saved game keeps of a session, taken in one call so that the
/// parts always match (RN-COM-33, D-113): the state, the undo history and the
/// active time.
///
/// The saving use case writes it with the codec of the variant's state
/// (ARQ-04 §8). To continue, the variant's factory builds
/// `GameEngine.paused(rules, state)` (D-111), `UndoHistory(engine, from:
/// undo)` and `ActiveTimer(engine, clock, elapsed: activeTime)`.
///
/// `TState` has no constraint, as in `UndoSnapshot`: it only carries states.
final class SessionSnapshot<TState> {
  /// A snapshot of [state] with the parts of the capabilities the session
  /// has.
  const SessionSnapshot(this.state, {this.undo, this.activeTime});

  /// The current state of the game.
  final TState state;

  /// The undo history around [state], or `null` if the game has no undo
  /// (RN-COM-60).
  final UndoSnapshot<TState>? undo;

  /// The time played, or `null` if the game does not measure it
  /// (RN-COM-52).
  final Duration? activeTime;
}
