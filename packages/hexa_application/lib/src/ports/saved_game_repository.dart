import 'package:hexa_engine/hexa_engine.dart';

import '../game_keys.dart';

/// Where the game in progress is kept on the device (D-37, ARQ-03 §4).
///
/// [scheduleSave] and [delete] do not wait: the adapter queues them, keeps
/// only the last one and writes it, so saving never delays the screen.
/// [delete] goes through the same queue, so a finished game never comes back
/// (D-110). [flush] waits until the queue is written.
///
/// A write that fails in the queue happens after the use case returned, so
/// it cannot become a `Left` (D-172). The adapter therefore:
///
/// - never lets it escape: [scheduleSave] and [delete] do not throw, and the
///   queue leaves no error unhandled;
/// - logs it as a warning with the type of the error only, no user data
///   (it lives in layer 4, like the handlers of the errors outside a use
///   case, D-163), and keeps the queue working;
/// - keeps the failed operation as the pending one, so the next operation
///   replaces it (a save writes the whole game) or [flush] writes it again;
/// - makes [flush] throw a `PersistenceException` if that write fails
///   again, so the use case that flushes gets a `PersistenceFailure`.
abstract interface class ISavedGameRepository<TState> {
  /// Queues [game] as the saved game of [key], replacing the one before.
  /// It never throws (D-172).
  void scheduleSave(SavedGameKey key, SavedGame<TState> game);

  /// Queues the removal of the saved game of [key] (RN-COM-35). It never
  /// throws (D-172).
  void delete(SavedGameKey key);

  /// Waits until every queued save and removal is written, writing again
  /// one that failed. Throws a `PersistenceException` if it still fails
  /// (D-172).
  Future<void> flush();

  /// The saved game of [key], or `null` if there is none.
  Future<SavedGame<TState>?> load(SavedGameKey key);

  /// Whether [profile] has a saved game in any variant (RN-COM-113).
  Future<bool> exists(ProfileId profile);
}
