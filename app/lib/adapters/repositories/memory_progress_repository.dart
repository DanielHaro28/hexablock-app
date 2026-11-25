import 'package:hexa_application/hexa_application.dart';

/// Keeps the progress in memory until PRG-03 brings the Drift one (D-142).
///
/// It honors the port: one progress per profile, variant and cell shape
/// (RN-COM-80), and the last save wins. Being in memory, the record is lost
/// when the app closes; replacing it is one line in the composition root.
/// The app registers only one, so the record outlives each game.
final class MemoryProgressRepository implements IProgressRepository {
  final Map<(ProfileId, GameKey), VariantProgress> _progress = {};

  @override
  Future<VariantProgress?> load(ProfileId profile, GameKey game) async =>
      _progress[(profile, game)];

  @override
  Future<void> save(
    ProfileId profile,
    GameKey game,
    VariantProgress progress,
  ) async => _progress[(profile, game)] = progress;
}
