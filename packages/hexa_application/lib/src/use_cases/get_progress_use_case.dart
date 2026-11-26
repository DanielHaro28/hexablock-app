import '../command_service.dart';
import '../either.dart';
import '../errors.dart';
import '../game_keys.dart';
import '../ports/profile_repository.dart';
import '../ports/progress_repository.dart';
import '../progress.dart';

/// Reads the progress of the active profile in a game, so the game screen
/// shows the record or completed levels (RN-COM-80, RN-HL-70).
final class GetProgressUseCase
    implements ICommandService<GameKey, VariantProgress?> {
  /// Reads the progress of the active profile from [_profiles] and [_progress].
  GetProgressUseCase(this._progress, this._profiles);

  final IProgressRepository _progress;
  final IProfileRepository _profiles;

  @override
  Future<Either<AppFailure, VariantProgress?>> execute(GameKey command) async {
    final profile = await _profiles.active();
    return Right(await _progress.load(profile.id, command));
  }
}
