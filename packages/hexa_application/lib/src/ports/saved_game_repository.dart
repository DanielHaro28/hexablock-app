import 'package:hexa_engine/hexa_engine.dart';

import '../game_keys.dart';

/// Where the game in progress is kept on the device (D-37, ARQ-03 §4).
///
/// [scheduleSave] and [delete] do not wait: the adapter queues them, keeps
/// only the last one of each [SavedGameKey] and writes it, so saving never
/// delays the screen. [delete] goes through the same queue, so a finished
/// game never comes back (D-110). [flush] waits until the queue is written.
///
/// A write that fails in the queue happens after the use case returned, so
/// it cannot become a `Left` (D-172). The adapter therefore:
///
/// - never lets it escape: [scheduleSave] and [delete] do not throw, and the
///   queue leaves no error unhandled;
/// - logs it as a warning with `error.runtimeType` only: never the error's
///   `toString()` or message (a database error may hold the statement and
///   its values), the key or the profile. It lives in layer 4, like the
///   handlers of the errors outside a use case (D-163);
/// - keeps the failed operation as the pending one of its key, so the next
///   operation on that key replaces it (a save writes the whole game) or
///   [flush] writes it again, and keeps the queue working;
/// - answers [load] and [exists] with what is pending before what is
///   written, so a finished game whose removal failed is not offered to
///   continue while the app runs.
///
/// If the app dies with a removal still pending, the finished game is on
/// disk when it opens again: an accepted risk, since avoiding it is the
/// option of D-110 that was discarded.
abstract interface class ISavedGameRepository<TState> {
  /// Queues [game] as the saved game of [key], replacing the one before.
  /// It never throws (D-172).
  void scheduleSave(SavedGameKey key, SavedGame<TState> game);

  /// Queues the removal of the saved game of [key] (RN-COM-35). It never
  /// throws (D-172).
  void delete(SavedGameKey key);

  /// Writes every pending save and removal, of every key, including the
  /// ones that failed before, and waits for them.
  ///
  /// Throws a `PersistenceException` if any of them fails, new or retried;
  /// the ones that failed stay pending (D-172).
  Future<void> flush();

  /// The saved game of [key], or `null` if there is none: a pending save or
  /// removal of [key] counts before what is written (D-172).
  Future<SavedGame<TState>?> load(SavedGameKey key);

  /// Whether [profile] has a saved game in any variant (RN-COM-113),
  /// counting the pending saves and removals first (D-172).
  Future<bool> exists(ProfileId profile);
}
