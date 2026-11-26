import '../game_keys.dart';
import '../ports/profile_repository.dart';
import '../ports/progress_repository.dart';
import '../progress.dart';
import '../use_case.dart';

/// Reads the progress of the active profile in a game, so the game screen
/// shows the record or completed levels (RN-COM-80, RN-HL-70).
final class GetProgressUseCase implements UseCase<GameKey, VariantProgress?> {
  /// Reads the progress of the active profile from [_profiles] and [_progress].
  GetProgressUseCase(this._progress, this._profiles);

  final IProgressRepository _progress;
  final IProfileRepository _profiles;

  @override
  Future<VariantProgress?> execute(GameKey input) async {
    final profile = await _profiles.active();
    return _progress.load(profile.id, input);
  }
}
