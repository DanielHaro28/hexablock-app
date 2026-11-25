import '../game_keys.dart';
import '../progress.dart';

/// Where the progress of each profile is kept on the device (ARQ-03 §4,
/// RN-COM-80): one per profile, variant and cell shape.
abstract interface class IProgressRepository {
  /// The progress of [profile] in [game], or `null` if there is none yet.
  Future<VariantProgress?> load(ProfileId profile, GameKey game);

  /// Keeps [progress] as the progress of [profile] in [game], replacing the
  /// one before, in one transaction.
  Future<void> save(ProfileId profile, GameKey game, VariantProgress progress);
}
