import 'package:hexa_application/hexa_application.dart';

/// A progress repository in memory for the use case tests (D-56).
///
/// It keeps the progress by profile and game, as the real one does, and
/// counts the writes in [saves], so a test can check that nothing was
/// written without `mocktail`.
final class FakeProgressRepository implements IProgressRepository {
  /// An empty repository, or one that already has [saved].
  FakeProgressRepository([Map<(ProfileId, GameKey), VariantProgress>? saved])
    : _saved = {...?saved};

  final Map<(ProfileId, GameKey), VariantProgress> _saved;

  /// How many times [save] was called.
  int saves = 0;

  /// The progress saved for [profile] in [game], if any.
  VariantProgress? savedAt(ProfileId profile, GameKey game) =>
      _saved[(profile, game)];

  @override
  Future<VariantProgress?> load(ProfileId profile, GameKey game) async =>
      _saved[(profile, game)];

  @override
  Future<void> save(
    ProfileId profile,
    GameKey game,
    VariantProgress progress,
  ) async {
    saves++;
    _saved[(profile, game)] = progress;
  }
}
