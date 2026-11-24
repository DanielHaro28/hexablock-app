import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

/// A saved-game repository in memory for the use case tests (D-56).
///
/// It keeps the games by key, as the real one does, and records every call in
/// [calls] (`save`, `delete`, `flush`), so a test can check what a use case
/// asked for without `mocktail`.
final class FakeSavedGameRepository<TState>
    implements ISavedGameRepository<TState> {
  /// An empty repository, or one that already has [saved].
  FakeSavedGameRepository([Map<SavedGameKey, SavedGame<TState>>? saved])
    : _saved = {...?saved};

  final Map<SavedGameKey, SavedGame<TState>> _saved;

  /// The calls that change something, in order: `save`, `delete`, `flush`.
  final List<String> calls = [];

  /// The game saved under [key], if any.
  SavedGame<TState>? savedAt(SavedGameKey key) => _saved[key];

  @override
  void scheduleSave(SavedGameKey key, SavedGame<TState> game) {
    calls.add('save');
    _saved[key] = game;
  }

  @override
  void delete(SavedGameKey key) {
    calls.add('delete');
    _saved.remove(key);
  }

  @override
  Future<void> flush() async => calls.add('flush');

  @override
  Future<SavedGame<TState>?> load(SavedGameKey key) async => _saved[key];

  @override
  Future<bool> exists(ProfileId profile) async =>
      _saved.keys.any((key) => key.profile == profile);
}
