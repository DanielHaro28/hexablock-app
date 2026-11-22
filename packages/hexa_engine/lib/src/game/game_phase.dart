import 'game_outcome.dart';

/// The stage of a game's life cycle: the State pattern (D-34, RN-COM-30).
///
/// It is called a *phase* so that it is not confused with `TState`, the data
/// of the game. Each phase decides which moves it accepts and which phase
/// comes next; a transition that a phase does not allow returns the phase
/// itself, so invalid transitions simply do not happen (RN-COM-31). The
/// engine only delegates to the current phase: it has no `if` per phase.
///
/// The hierarchy is sealed, so a screen can `switch` over the five phases
/// exhaustively.
sealed class GamePhase {
  const GamePhase();

  /// Whether a move can be submitted now (RN-COM-24).
  bool get acceptsMoves => false;

  /// Whether a turn can be undone or redone now (D-31). Only while playing:
  /// never after a defeat or a victory (RN-COM-63), nor while paused or
  /// resolving. After a victory that lets the player keep playing, undo is
  /// back as soon as the game is playing again.
  bool get allowsUndo => false;

  /// Whether the active time runs now (RN-COM-52, D-106): while playing and
  /// while a turn is resolved, never while paused or once the game is over.
  bool get countsActiveTime => false;

  /// The phase while a submitted move is being played.
  GamePhase onTurnStarted() => this;

  /// The phase after a turn that ended with [outcome].
  GamePhase onTurnFinished(GameOutcome outcome) => this;

  /// The phase after the player (or the app going to the background,
  /// RN-COM-32) pauses the game.
  GamePhase onPause() => this;

  /// The phase after the player resumes a paused game.
  GamePhase onResume() => this;

  /// The phase after the player chooses to keep playing after a victory.
  GamePhase onContinue() => this;

  /// Phases without fields are equal by kind.
  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Playing: the only phase that accepts moves.
final class PlayingPhase extends GamePhase {
  const PlayingPhase();

  @override
  bool get acceptsMoves => true;

  @override
  bool get allowsUndo => true;

  @override
  bool get countsActiveTime => true;

  @override
  GamePhase onTurnStarted() => const ResolvingPhase();

  @override
  GamePhase onPause() => const PausedPhase();

  @override
  String toString() => 'PlayingPhase()';
}

/// Resolving: a turn is being played, so no other move is accepted
/// (RN-COM-24). Resolution is synchronous; the animation afterwards belongs
/// to the view (ARQ-02 §8).
final class ResolvingPhase extends GamePhase {
  const ResolvingPhase();

  @override
  bool get countsActiveTime => true;

  @override
  GamePhase onTurnFinished(GameOutcome outcome) => switch (outcome) {
    Ongoing() => const PlayingPhase(),
    Victory(:final canContinue) => VictoryPhase(canContinue: canContinue),
    Defeat() => const GameOverPhase(),
  };

  @override
  String toString() => 'ResolvingPhase()';
}

/// Paused: no moves until the player resumes (RN-COM-24, RN-COM-31).
final class PausedPhase extends GamePhase {
  const PausedPhase();

  @override
  GamePhase onResume() => const PlayingPhase();

  @override
  String toString() => 'PausedPhase()';
}

/// Victory. From here the player can only retry, go to the next level, start
/// a new game or leave, unless [canContinue] lets them keep playing
/// (RN-COM-31).
final class VictoryPhase extends GamePhase {
  const VictoryPhase({required this.canContinue});

  /// Whether the player may keep playing after this victory.
  final bool canContinue;

  @override
  GamePhase onContinue() => canContinue ? const PlayingPhase() : this;

  @override
  bool operator ==(Object other) =>
      other is VictoryPhase && other.canContinue == canContinue;

  @override
  int get hashCode => Object.hash(VictoryPhase, canContinue);

  @override
  String toString() => 'VictoryPhase(canContinue: $canContinue)';
}

/// Defeat: the game is over (RN-COM-31).
final class GameOverPhase extends GamePhase {
  const GameOverPhase();

  @override
  String toString() => 'GameOverPhase()';
}
