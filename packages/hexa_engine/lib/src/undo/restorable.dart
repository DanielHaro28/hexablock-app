import '../game/game_phase.dart';
import 'move_command.dart';

/// Something that can go back to a saved state: the originator of the
/// Memento pattern (D-31). `GameEngine` implements it.
abstract interface class Restorable<TState> {
  /// Replaces the current state with [snapshot], which publishes
  /// `StateRestored` (D-103). It throws a [StateError] if the current phase
  /// does not allow undo (D-102, RN-COM-63).
  void restore(TState snapshot);
}

/// What `UndoHistory` needs from `GameEngine`, and nothing else (ISP):
/// restore a state, know whether the phase allows undo, and hear about each
/// turn that was played.
abstract interface class UndoableEngine<TMove, TState>
    implements Restorable<TState> {
  /// The current phase, which decides whether undo is possible (D-31).
  GamePhase get phase;

  /// One command per turn that was played, delivered before `submit`
  /// returns. A rejected move sends nothing (RN-COM-21).
  Stream<MoveCommand<TMove, TState>> get committedTurns;
}
