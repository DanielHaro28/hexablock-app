/// The optional capabilities of a game, segregated so that a game only has
/// the ones it uses (ISP, D-33, ARQ-02 §7).
///
/// - [IUndoable] and [ITimed] are components that the variant's factory
///   composes into a `GameSession` (`UndoHistory`, `ActiveTimer`).
/// - [IRandomSeeded] and [ILevelBased] are implemented by the variant's
///   state, so they are read from `session.engine.state`.
library;

/// A game whose turns can be undone and, perhaps, redone (RN-COM-60 to 63).
abstract interface class IUndoable {
  /// Whether [undo] would undo a turn now.
  bool get canUndo;

  /// Whether [redo] would redo a turn now.
  bool get canRedo;

  /// Undoes the last turn, if [canUndo].
  void undo();

  /// Redoes the last undone turn, if [canRedo].
  void redo();
}

/// A game that measures its active time (RN-COM-52, D-105).
abstract interface class ITimed {
  /// The time played, without pauses or time in the background. The
  /// codec and the gateway store it in milliseconds (`inMilliseconds`).
  Duration get activeTime;
}

/// A game that uses chance, so it can be replayed from its seed
/// (RN-COM-40 to 45).
abstract interface class IRandomSeeded {
  /// The seed the game started with (RN-COM-45), not the current state of
  /// its generator: the same seed and the same moves replay the same game
  /// (RN-COM-41).
  int get seed;
}

/// A game played level by level (D-45, D-104).
abstract interface class ILevelBased {
  /// The `id` of the level being played, as written in the level contract
  /// (`docs/contracts/`). Progress is kept by this id, not by the level
  /// version (RN-COM-74).
  String get levelId;
}
