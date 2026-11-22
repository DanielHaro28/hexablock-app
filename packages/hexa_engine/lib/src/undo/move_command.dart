import 'restorable.dart';

/// One turn that was played, ready to be undone and redone: the Command
/// pattern, with the states before and after as its mementos (D-31).
///
/// The states are immutable values, so no variant writes the inverse of its
/// moves: undoing restores [before] whole, generator included (RN-COM-61),
/// and redoing restores [after].
final class MoveCommand<TMove, TState> {
  /// The command for [move], which took the game from [before] to [after].
  const MoveCommand(this.move, this.before, this.after);

  /// The move that was played, or `null` for a turn restored from a saved
  /// game: a saved history keeps only states (D-107). Undo and redo never
  /// read it; the engine always sets it in `committedTurns`.
  final TMove? move;

  /// The state before the move (memento).
  final TState before;

  /// The state after the move (memento).
  final TState after;

  /// Takes [engine] back to the state before the move.
  void undo(Restorable<TState> engine) => engine.restore(before);

  /// Takes [engine] forward to the state after the move.
  void redo(Restorable<TState> engine) => engine.restore(after);

  @override
  String toString() => 'MoveCommand($move)';
}
