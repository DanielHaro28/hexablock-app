import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

/// What the game screen draws, for any variant (ARQ-03 §4).
///
/// `TState` is the variant's state: the board is read through `GameState`,
/// and the variant's own widgets (its tray, its markers) read the rest.
sealed class GameScreenState<C extends Coord, TState> {
  const GameScreenState();
}

/// The game is being created or loaded.
final class GameLoading<C extends Coord, TState>
    extends GameScreenState<C, TState> {
  /// The game is not ready yet.
  const GameLoading();

  @override
  bool operator ==(Object other) => other is GameLoading<C, TState>;

  @override
  int get hashCode => (GameLoading<C, TState>).hashCode;
}

/// The game could not start, because of [failure].
final class GameNotStarted<C extends Coord, TState>
    extends GameScreenState<C, TState> {
  /// The game did not start because of [failure].
  const GameNotStarted(this.failure);

  /// Why; the screen turns it into a text (RNF-50).
  final AppFailure failure;

  @override
  bool operator ==(Object other) =>
      other is GameNotStarted<C, TState> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;
}

/// A game on screen: its [state] and [phase], and what the last call did.
final class GameReady<C extends Coord, TState>
    extends GameScreenState<C, TState> {
  /// A game in [state] and [phase].
  const GameReady(
    this.state,
    this.phase, {
    this.events = const [],
    this.rejection,
    this.failure,
  });

  /// The state of the game.
  final TState state;

  /// Its phase: playing, paused, won or lost (RN-COM-31).
  final GamePhase phase;

  /// The events of the last move, in order, for the animations (D-32).
  final List<GameEvent<C>> events;

  /// Why the last move was rejected, or `null` if it was not (D-95).
  final RejectionReason? rejection;

  /// What failed in the last move, or `null`; the game goes on (RNF-35).
  final AppFailure? failure;

  @override
  bool operator ==(Object other) =>
      other is GameReady<C, TState> &&
      other.state == state &&
      other.phase == phase &&
      other.rejection == rejection &&
      other.failure == failure &&
      _sameEvents(other.events);

  bool _sameEvents(List<GameEvent<C>> others) {
    if (others.length != events.length) return false;
    for (var i = 0; i < events.length; i++) {
      if (others[i] != events[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(state, phase, rejection, failure, Object.hashAll(events));

  @override
  String toString() =>
      'GameReady($phase, rejection: $rejection, failure: $failure, $state)';
}
