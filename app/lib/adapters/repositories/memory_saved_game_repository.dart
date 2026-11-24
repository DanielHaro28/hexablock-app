import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

/// Keeps the saved games in memory until PRG-03 brings the Drift one
/// (D-136).
///
/// It honors the port: one game per key, the last save wins and a removal
/// goes after any save (D-110). Being in memory, a game is lost when the
/// app closes; replacing it is one line in the composition root.
final class MemorySavedGameRepository<TState>
    implements ISavedGameRepository<TState> {
  final Map<SavedGameKey, SavedGame<TState>> _games = {};

  @override
  void scheduleSave(SavedGameKey key, SavedGame<TState> game) =>
      _games[key] = game;

  @override
  void delete(SavedGameKey key) => _games.remove(key);

  @override
  Future<void> flush() async {}

  @override
  Future<SavedGame<TState>?> load(SavedGameKey key) async => _games[key];

  @override
  Future<bool> exists(ProfileId profile) async =>
      _games.keys.any((key) => key.profile == profile);
}
