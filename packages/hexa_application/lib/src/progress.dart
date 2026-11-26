/// The progress of a profile in a game and the result that improves it
/// (ARQ-03 §3, D-45, RN-COM-80).
library;

import 'package:hexa_engine/hexa_engine.dart';

import 'game_keys.dart';

/// The progress of a profile in one variant and cell shape (D-45): its
/// shape is chosen by the variant's progress model.
sealed class VariantProgress {
  const VariantProgress();
}

/// The record of a game without levels: its best score and when it was
/// reached (the `highScore` section of the contract, D-45).
final class HighScoreProgress extends VariantProgress {
  /// A record of [score] reached at [achievedAt].
  const HighScoreProgress(this.score, this.achievedAt);

  /// The best score: an integer ≥ 0 (RN-COM-50).
  final int score;

  /// When it was reached, by the wall clock (`IClock.now`).
  final DateTime achievedAt;

  @override
  bool operator ==(Object other) =>
      other is HighScoreProgress &&
      other.score == score &&
      other.achievedAt == achievedAt;

  @override
  int get hashCode => Object.hash(score, achievedAt);

  @override
  String toString() => 'HighScoreProgress($score, $achievedAt)';
}

/// The best completed attempt of one level (D-45, ARQ-04 §2).
///
/// The optional fields carry the metrics used by level-based variants
/// (such as stars, active time in milliseconds, or score) without naming
/// any variant (RNF-07).
final class LevelAttempt {
  /// A completed attempt taking [moves], reached at [achievedAt].
  const LevelAttempt({
    required this.moves,
    required this.achievedAt,
    this.stars,
    this.timeMs,
    this.score,
  });

  /// How many moves were made.
  final int moves;

  /// Earned stars (1 to 3), if the variant awards stars.
  final int? stars;

  /// Active time in milliseconds, if the variant is timed.
  final int? timeMs;

  /// Score reached in the level, if the variant scores attempts.
  final int? score;

  /// When this attempt was reached, by the wall clock (`IClock.now`).
  final DateTime achievedAt;

  @override
  bool operator ==(Object other) =>
      other is LevelAttempt &&
      other.moves == moves &&
      other.stars == stars &&
      other.timeMs == timeMs &&
      other.score == score &&
      other.achievedAt == achievedAt;

  @override
  int get hashCode => Object.hash(moves, stars, timeMs, score, achievedAt);

  @override
  String toString() =>
      'LevelAttempt(moves: $moves, stars: $stars, timeMs: $timeMs, '
      'score: $score, achievedAt: $achievedAt)';
}

/// The progress of a level-based game: the best attempt of every completed
/// level, keyed by `levelId` (D-45, ARQ-04 §2).
final class LevelsProgress extends VariantProgress {
  /// Completed levels mapped from `levelId` to their best attempt.
  LevelsProgress(Map<String, LevelAttempt> levels)
    : levels = Map<String, LevelAttempt>.unmodifiable(levels);

  /// An unmodifiable view of completed levels and their best attempts.
  final Map<String, LevelAttempt> levels;

  @override
  bool operator ==(Object other) =>
      other is LevelsProgress &&
      other.levels.length == levels.length &&
      levels.entries.every((entry) => other.levels[entry.key] == entry.value);

  @override
  int get hashCode => Object.hashAllUnordered(
    levels.entries.map((entry) => Object.hash(entry.key, entry.value)),
  );

  @override
  String toString() => 'LevelsProgress($levels)';
}

/// How a finished game or level of [game] went: what `SaveProgressUseCase`
/// keeps if it improves the progress (RN-COM-83).
sealed class GameResult {
  /// A finished result of [game].
  const GameResult(this.game);

  /// Which variant and cell shape was played.
  final GameKey game;
}

/// A finished game without levels that ended with [score] (D-45).
final class HighScoreResult extends GameResult {
  /// A game of [game] that ended with [score].
  const HighScoreResult(super.game, this.score);

  /// The final score (RN-COM-50).
  final int score;

  @override
  bool operator ==(Object other) =>
      other is HighScoreResult && other.game == game && other.score == score;

  @override
  int get hashCode => Object.hash(game, score);

  @override
  String toString() => 'HighScoreResult($game, $score)';
}

/// A completed level [levelId] of a level-based game, evaluated with [model]
/// (D-45, D-143).
final class LevelCompletedResult extends GameResult {
  /// A completion of [levelId] in [game], compared with [model].
  const LevelCompletedResult(
    super.game, {
    required this.levelId,
    required this.moves,
    required this.model,
    this.stars,
    this.timeMs,
    this.score,
  });

  /// Identifier of the completed level (`D-47`).
  final String levelId;

  /// Moves taken to complete the level.
  final int moves;

  /// Earned stars (1 to 3), if applicable.
  final int? stars;

  /// Active time in milliseconds, if applicable.
  final int? timeMs;

  /// Score reached in the level, if applicable.
  final int? score;

  /// Variant criterion that decides whether a new attempt beats the saved one
  /// (D-99, D-143).
  final IProgressModel<LevelAttempt> model;

  @override
  bool operator ==(Object other) =>
      other is LevelCompletedResult &&
      other.game == game &&
      other.levelId == levelId &&
      other.moves == moves &&
      other.stars == stars &&
      other.timeMs == timeMs &&
      other.score == score &&
      other.model == model;

  @override
  int get hashCode =>
      Object.hash(game, levelId, moves, stars, timeMs, score, model);

  @override
  String toString() =>
      'LevelCompletedResult($game, levelId: $levelId, moves: $moves, '
      'stars: $stars, timeMs: $timeMs, score: $score)';
}
