import 'package:hexa_engine/hexa_engine.dart';

import '../ports/clock.dart';
import '../ports/profile_repository.dart';
import '../ports/progress_repository.dart';
import '../progress.dart';
import '../use_case.dart';

/// Keeps the result of a finished game or level for the active profile if it
/// improves the saved progress (RF-24, RF-60, RN-COM-80, 83).
///
/// For a record (D-143), the score is kept only if it beats the saved one, or
/// if there is none yet, dated with [_clock]. For a level, the attempt is
/// compared against the saved one with the result's [IProgressModel] (and by
/// earliest timestamp on a tie, ARQ-04 §3). It returns the progress that is
/// kept, new or not.
///
/// The sync outbox arrives with API-03; the saved game is removed by
/// `ApplyMoveUseCase` when the game ends (D-110).
final class SaveProgressUseCase
    implements UseCase<GameResult, VariantProgress> {
  /// Keeps the results of the active profile from [_profiles] in [_progress],
  /// dated by [_clock].
  SaveProgressUseCase(this._progress, this._profiles, this._clock);

  final IProgressRepository _progress;
  final IProfileRepository _profiles;
  final IClock _clock;

  @override
  Future<VariantProgress> execute(GameResult input) async {
    final profile = (await _profiles.active()).id;
    final saved = await _progress.load(profile, input.game);
    // Exhaustive over both the incoming result and the saved progress shape
    // (D-45).
    switch ((input, saved)) {
      case (HighScoreResult(:final score), final HighScoreProgress current)
          when current.score >= score:
        return current;
      case (
        HighScoreResult(:final game, :final score),
        HighScoreProgress() || null,
      ):
        final record = HighScoreProgress(score, _clock.now());
        await _progress.save(profile, game, record);
        return record;
      case (final LevelCompletedResult result, final LevelsProgress? current):
        final attempt = _attemptOf(result);
        final existing = current?.levels[result.levelId];
        if (current != null &&
            existing != null &&
            !_isBetter(attempt, existing, result.model)) {
          return current;
        }
        final updated = LevelsProgress({
          ...?current?.levels,
          result.levelId: attempt,
        });
        await _progress.save(profile, result.game, updated);
        return updated;
      case (HighScoreResult(), LevelsProgress()) ||
          (LevelCompletedResult(), HighScoreProgress()):
        throw StateError('Progress shape mismatch for ${input.game}');
    }
  }

  LevelAttempt _attemptOf(LevelCompletedResult result) => LevelAttempt(
    moves: result.moves,
    stars: result.stars,
    timeMs: result.timeMs,
    score: result.score,
    achievedAt: _clock.now(),
  );

  static bool _isBetter(
    LevelAttempt candidate,
    LevelAttempt current,
    IProgressModel<LevelAttempt> model,
  ) {
    final order = model.compare(candidate, current);
    if (order != 0) return order < 0;
    return candidate.achievedAt.isBefore(current.achievedAt);
  }
}
