import '../session/capabilities.dart';
import 'move_command.dart';
import 'restorable.dart';

/// The undo and redo of a game: the invoker of the Command pattern and the
/// caretaker of the mementos (D-31).
///
/// The variant's factory creates one only if the game allows undo, with its
/// own configuration (RN-COM-60): no [limit] and [allowsRedo] for unlimited
/// undo and redo, a [limit] of 1 without redo for undoing only the last move.
/// A game without undo has no history at all (D-33).
///
/// It hears about each turn from the engine's `committedTurns`, before
/// `submit` returns, so it is up to date when the screen redraws (D-32). The
/// engine's phase decides whether undo is possible now (RN-COM-63).
final class UndoHistory<TMove, TState> implements IUndoable {
  /// A history of the turns played on [engine].
  ///
  /// Throws an [ArgumentError] if [limit] is less than 1.
  UndoHistory(this._engine, {this.limit, this.allowsRedo = false}) {
    if (limit case final limit? when limit < 1) {
      throw ArgumentError.value(limit, 'limit', 'must be at least 1');
    }
    _engine.committedTurns.listen(_record, onDone: _forget);
  }

  final UndoableEngine<TMove, TState> _engine;
  final _done = <MoveCommand<TMove, TState>>[];
  final _undone = <MoveCommand<TMove, TState>>[];

  /// How many turns can be undone in a row; `null` means no limit.
  final int? limit;

  /// Whether an undone turn can be redone.
  final bool allowsRedo;

  @override
  bool get canUndo => _done.isNotEmpty && _engine.phase.allowsUndo;

  @override
  bool get canRedo => _undone.isNotEmpty && _engine.phase.allowsUndo;

  /// Undoes the last turn; if [canUndo] is false, it does nothing.
  @override
  void undo() {
    if (!canUndo) return;
    final command = _done.removeLast()..undo(_engine);
    if (allowsRedo) _undone.add(command);
  }

  /// Redoes the last undone turn; if [canRedo] is false, it does nothing.
  @override
  void redo() {
    if (!canRedo) return;
    _done.add(_undone.removeLast()..redo(_engine));
  }

  void _record(MoveCommand<TMove, TState> command) {
    _undone.clear(); // a new move discards what could be redone (RN-COM-62)
    _done.add(command);
    if (limit case final limit? when _done.length > limit) _done.removeAt(0);
  }

  /// A closed engine cannot be used, so there is nothing left to undo.
  void _forget() {
    _done.clear();
    _undone.clear();
  }
}
