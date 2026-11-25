/// The progress of a profile in a game and the result that improves it
/// (ARQ-03 §3, D-45, RN-COM-80).
library;

import 'game_keys.dart';

/// The progress of a profile in one variant and cell shape (D-45): its
/// shape is chosen by the variant's progress model.
///
/// Only the record exists for now (Hexa Lines, Hexa Merge); the one with a
/// best attempt per level comes with Hexa Fit and Hexa Sort (D-142).
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

/// How a finished game of [game] went: what `SaveProgressUseCase` keeps if
/// it improves the progress (RN-COM-83).
final class GameResult {
  /// A game of [game] that ended with [score].
  const GameResult(this.game, this.score);

  /// Which variant and cell shape was played.
  final GameKey game;

  /// The final score (RN-COM-50).
  final int score;

  @override
  bool operator ==(Object other) =>
      other is GameResult && other.game == game && other.score == score;

  @override
  int get hashCode => Object.hash(game, score);

  @override
  String toString() => 'GameResult($game, $score)';
}
