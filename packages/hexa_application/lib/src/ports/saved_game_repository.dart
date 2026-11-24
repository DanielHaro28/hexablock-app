import 'package:hexa_engine/hexa_engine.dart';

import '../game_keys.dart';

/// Where the game in progress is kept on the device (D-37, ARQ-03 §4).
///
/// [scheduleSave] and [delete] do not wait: the adapter queues them, keeps
/// only the last one and writes it, so saving never delays the screen.
/// [delete] goes through the same queue, so a finished game never comes back
/// (D-110). [flush] waits until the queue is written.
abstract interface class ISavedGameRepository<TState> {
  /// Queues [game] as the saved game of [key], replacing the one before.
  void scheduleSave(SavedGameKey key, SavedGame<TState> game);

  /// Queues the removal of the saved game of [key] (RN-COM-35).
  void delete(SavedGameKey key);

  /// Waits until every queued save and removal is written.
  Future<void> flush();

  /// The saved game of [key], or `null` if there is none.
  Future<SavedGame<TState>?> load(SavedGameKey key);

  /// Whether [profile] has a saved game in any variant (RN-COM-113).
  Future<bool> exists(ProfileId profile);
}
