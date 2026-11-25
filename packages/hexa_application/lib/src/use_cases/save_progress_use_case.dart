import '../game_keys.dart';
import '../ports/clock.dart';
import '../ports/progress_repository.dart';
import '../progress.dart';
import '../use_case.dart';

/// Keeps the result of a finished game if it improves the progress
/// (RF-24, RF-60, RN-COM-80, 83).
///
/// For a record (RN-HL-71, RN-HM-70), the score is kept only if it beats
/// the saved one, or if there is none yet, with the date of the [IClock].
/// It returns the progress that is kept, new or not.
///
/// The profile is the guest, and the sync outbox and the removal of the
/// saved game come with PRG-03 and API-03 (D-142).
final class SaveProgressUseCase
    implements UseCase<GameResult, VariantProgress> {
  /// Keeps the results of [_profile] in [_progress], dated by [_clock].
  SaveProgressUseCase(this._progress, this._clock, this._profile);

  final IProgressRepository _progress;
  final IClock _clock;
  final ProfileId _profile;

  @override
  Future<VariantProgress> execute(GameResult input) async {
    final saved = await _progress.load(_profile, input.game);
    // Exhaustive, so a new shape of progress (D-45) must say how it is kept.
    switch (saved) {
      // A score that only equals the record does not beat it (RN-HL-71).
      case HighScoreProgress(:final score) when score >= input.score:
        return saved;
      case HighScoreProgress() || null:
        break;
    }
    final record = HighScoreProgress(input.score, _clock.now());
    await _progress.save(_profile, input.game, record);
    return record;
  }
}
