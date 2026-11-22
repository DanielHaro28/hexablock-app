/// What a saved game keeps of the undo history: the timeline of states
/// around the current one (D-107, RN-COM-33).
///
/// ```text
/// undo ←  S0   S1   S2  [current state]  S4   S5  → redo
///         └─ undoStates ─┘                └─ redoStates ─┘
/// ```
///
/// Only states, no moves, so saving it needs nothing but the codec of the
/// state that every variant already has: a variant with undo writes no extra
/// code to keep it (RNF-03). The states are complete, so undoing a turn of a
/// continued game restores everything, generator included (RN-COM-61).
///
/// The current state is not in it: it is the state saved with the game,
/// written together with this snapshot, so both always match.
final class UndoSnapshot<TState> {
  /// A snapshot with the states to undo to and to redo to.
  const UndoSnapshot({this.undoStates = const [], this.redoStates = const []});

  /// Where each undo goes, oldest first: the last one is the state before
  /// the current one.
  final List<TState> undoStates;

  /// Where each redo goes, next first.
  final List<TState> redoStates;
}
