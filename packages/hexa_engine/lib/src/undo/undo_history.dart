import '../session/capabilities.dart';
import 'move_command.dart';
import 'restorable.dart';
import 'undo_snapshot.dart';

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
///
/// A saved game keeps it as an [UndoSnapshot] (D-107): [snapshot] gives it
/// and the `from` parameter takes it back when the game continues.
///
/// Undo restores the whole state before the turn (RN-COM-61), except what
/// the variant asks to keep with `carryOver` (D-109): for example, a moves
/// counter that undo and redo must not change. The function belongs to the
/// variant's state and its factory wires it; it must keep only such
/// counters, never the board or the generator.
final class UndoHistory<TMove, TState> implements IUndoable {
  /// A history of the turns played on [engine], starting with the turns
  /// saved in [from], if any (a game that continues, D-37, D-107).
  ///
  /// The saved turns follow this history's configuration: only the last
  /// [limit] undo states are kept, and the redo states are dropped if
  /// [allowsRedo] is false (RN-COM-60). The [limit] counts only the turns
  /// that can be undone, as while playing; the redo states are kept as
  /// saved. The engine's current state is the pivot between both lists.
  ///
  /// [carryOver], if given, receives the state an undo or a redo goes to and
  /// the current one, and returns the state to restore (D-109).
  ///
  /// Throws an [ArgumentError] if [limit] is less than 1.
  UndoHistory(
    this._engine, {
    this.limit,
    this.allowsRedo = false,
    TState Function(TState restored, TState current)? carryOver,
    UndoSnapshot<TState>? from,
  }) : _target = carryOver == null
           ? _engine
           : _CarryingOver(_engine, carryOver) {
    if (limit case final limit? when limit < 1) {
      throw ArgumentError.value(limit, 'limit', 'must be at least 1');
    }
    if (from != null) _load(from);
    _engine.committedTurns.listen(_record, onDone: _forget);
  }

  final UndoableEngine<TMove, TState> _engine;

  /// Where the commands restore their states: the engine itself, or the
  /// engine behind the variant's `carryOver` (D-109).
  final Restorable<TState> _target;
  final _done = <MoveCommand<TMove, TState>>[];
  final _undone = <MoveCommand<TMove, TState>>[];

  /// How many turns can be undone in a row; `null` means no limit.
  final int? limit;

  /// Whether an undone turn can be redone.
  final bool allowsRedo;

  @override
  bool get canUndo => _done.isNotEmpty && _engine.phase.allowsUndo;

  @override
  bool get canRedo =>
      allowsRedo && _undone.isNotEmpty && _engine.phase.allowsUndo;

  /// Undoes the last turn; if [canUndo] is false, it does nothing.
  ///
  /// The turn leaves the history only once the engine restored it, so if
  /// `restore` throws (for example, when called from a synchronous listener,
  /// D-32) nothing is lost.
  @override
  void undo() {
    if (!canUndo) return;
    final command = _done.last..undo(_target);
    _done.removeLast();
    if (allowsRedo) _undone.add(command);
  }

  /// Redoes the last undone turn; if [canRedo] is false, it does nothing.
  /// Like [undo], it loses nothing if `restore` throws.
  @override
  void redo() {
    if (!canRedo) return;
    final command = _undone.last..redo(_target);
    _undone.removeLast();
    _done.add(command);
  }

  /// What a saved game keeps of this history: the states it can undo to and
  /// redo to (D-107). It copies only references to immutable states, so it
  /// costs a list of pointers, not a copy of the states.
  UndoSnapshot<TState> snapshot() => UndoSnapshot(
    undoStates: List.unmodifiable(_done.map((command) => command.before)),
    redoStates: List.unmodifiable(
      _undone.reversed.map((command) => command.after),
    ),
  );

  /// Rebuilds the commands between consecutive states of [saved], with the
  /// engine's current state in the middle. The moves are not saved (D-107).
  void _load(UndoSnapshot<TState> saved) {
    final current = _engine.state;
    final undoStates = switch (limit) {
      final limit? when saved.undoStates.length > limit =>
        saved.undoStates.sublist(saved.undoStates.length - limit),
      _ => saved.undoStates,
    };
    final back = [...undoStates, current];
    for (var i = 0; i + 1 < back.length; i++) {
      _done.add(MoveCommand(null, back[i], back[i + 1]));
    }
    if (!allowsRedo) return;
    final forward = [current, ...saved.redoStates];
    for (var i = forward.length - 2; i >= 0; i--) {
      _undone.add(MoveCommand(null, forward[i], forward[i + 1]));
    }
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

/// A [Restorable] that adjusts each state before the engine restores it:
/// a Decorator, so `MoveCommand` keeps restoring its mementos as they are
/// (D-31) and the snapshot keeps the states as they were played (D-107).
final class _CarryingOver<TState> implements Restorable<TState> {
  const _CarryingOver(this._engine, this._carryOver);

  final UndoableEngine<Object?, TState> _engine;
  final TState Function(TState restored, TState current) _carryOver;

  @override
  void restore(TState snapshot) =>
      _engine.restore(_carryOver(snapshot, _engine.state));
}
