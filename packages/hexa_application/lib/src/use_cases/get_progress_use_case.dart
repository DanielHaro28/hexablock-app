import '../game_keys.dart';
import '../ports/progress_repository.dart';
import '../progress.dart';
import '../use_case.dart';

/// Reads the progress of the profile in a game, so the game screen shows
/// the record (RN-HL-70).
///
/// The profile is the guest until the profile repository arrives (D-142).
final class GetProgressUseCase implements UseCase<GameKey, VariantProgress?> {
  /// Reads the progress of [_profile] from [_progress].
  GetProgressUseCase(this._progress, this._profile);

  final IProgressRepository _progress;
  final ProfileId _profile;

  @override
  Future<VariantProgress?> execute(GameKey input) =>
      _progress.load(_profile, input);
}
