import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

/// What the game screen draws, for any variant (ARQ-03 §4).
///
/// `TState` is the variant's state: the board is read through `GameState`,
/// and the variant's own widgets (its tray, its markers) read the rest.
/// `TMove` is the variant's move, for the [MovePreview] of a drag.
sealed class GameScreenState<C extends Coord, TMove, TState> {
  const GameScreenState();
}

/// The game is being created or loaded.
final class GameLoading<C extends Coord, TMove, TState>
    extends GameScreenState<C, TMove, TState> {
  /// The game is not ready yet.
  const GameLoading();

  @override
  bool operator ==(Object other) => other is GameLoading<C, TMove, TState>;

  @override
  int get hashCode => (GameLoading<C, TMove, TState>).hashCode;
}

/// The game could not start, because of [failure].
final class GameNotStarted<C extends Coord, TMove, TState>
    extends GameScreenState<C, TMove, TState> {
  /// The game did not start because of [failure].
  const GameNotStarted(this.failure);

  /// Why; the screen turns it into a text (RNF-50).
  final AppFailure failure;

  @override
  bool operator ==(Object other) =>
      other is GameNotStarted<C, TMove, TState> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;
}

/// A game on screen: its [state] and [phase], and what the last call did.
final class GameReady<C extends Coord, TMove, TState>
    extends GameScreenState<C, TMove, TState> {
  /// A game in [state] and [phase].
  const GameReady(
    this.state,
    this.phase, {
    this.events = const [],
    this.rejection,
    this.failure,
    this.preview,
    this.record,
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

  /// The move the player is about to make, while they drag it (D-138), or
  /// `null`.
  final MovePreview<TMove>? preview;

  /// The saved record of the game (RN-HL-70), or `null` if the game has
  /// none yet or keeps no record. It changes when the game ends, not while
  /// the score goes past it (RN-HL-71, D-142).
  final int? record;

  @override
  bool operator ==(Object other) =>
      other is GameReady<C, TMove, TState> &&
      other.state == state &&
      other.phase == phase &&
      other.rejection == rejection &&
      other.failure == failure &&
      other.preview == preview &&
      other.record == record &&
      _sameEvents(other.events);

  bool _sameEvents(List<GameEvent<C>> others) {
    if (others.length != events.length) return false;
    for (var i = 0; i < events.length; i++) {
      if (others[i] != events[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    state,
    phase,
    rejection,
    failure,
    preview,
    record,
    Object.hashAll(events),
  );

  @override
  String toString() =>
      'GameReady($phase, rejection: $rejection, failure: $failure, '
      'preview: $preview, record: $record, $state)';
}

/// A move that is not played yet and whether it would be (D-138): what the
/// screen shows while the player drags a piece (HL-02).
final class MovePreview<TMove> {
  /// The preview of [move], rejected because of [rejection] or valid if it is
  /// `null`.
  const MovePreview(this.move, {this.rejection});

  /// The move the player would make.
  final TMove move;

  /// Why it would be rejected, or `null` if it would be played.
  final RejectionReason? rejection;

  /// Whether the move would be played.
  bool get isValid => rejection == null;

  @override
  bool operator ==(Object other) =>
      other is MovePreview<TMove> &&
      other.move == move &&
      other.rejection == rejection;

  @override
  int get hashCode => Object.hash(move, rejection);

  @override
  String toString() => 'MovePreview($move, rejection: $rejection)';
}
