import 'dart:async';

import '../board/coord.dart';
import '../time/active_timer.dart';
import '../undo/move_command.dart';
import '../undo/restorable.dart';
import 'game_event.dart';
import 'game_phase.dart';
import 'game_rules.dart';
import 'game_state.dart';
import 'move_result.dart';
import 'rejection_reason.dart';
import 'turn_result.dart';

/// The engine's reason: the current phase does not accept moves (RN-COM-24).
///
/// Its constructor is private, so only the engine can give this reason; the
/// rules use `InvalidMove` or a reason of their own (D-95).
final class NotAcceptingMoves extends RejectionReason {
  const NotAcceptingMoves._();

  @override
  String toString() => 'NotAcceptingMoves()';
}

/// Plays a game with any rules on any board: one engine for every variant
/// and cell shape (RNF-01, RNF-02).
///
/// It keeps the current state and [phase], plays each submitted move with
/// the rules (Strategy) and delegates the life cycle to the phase (State).
/// Each call reports what happened, in order (D-32, D-94):
///
/// - [submit] returns a `MoveResult` with the events, so the screen gets
///   them in the same call.
/// - [syncEvents] delivers the same events before the call returns, for the
///   listeners inside the domain that must be up to date when the screen
///   redraws (undo history, active timer). A synchronous listener must not
///   call [submit], [pause], [resume] or [continuePlaying]: the engine throws
///   a [StateError] if it does.
/// - [events] delivers them a moment later, for the listeners that are not
///   urgent (audio, analytics).
/// - [committedTurns] delivers one `MoveCommand` per turn played, for the
///   undo history (D-31), and [restore] goes back to one of its states.
///
/// Type constraints: the same as `IGameRules`.
final class GameEngine<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements UndoableEngine<TMove, TState>, TimedEngine {
  /// An engine that starts playing [initialState] with [rules]. The variant's
  /// factory builds the state, or the saved-game codec reads it (D-93).
  GameEngine(this._rules, TState initialState) : _state = initialState;

  final IGameRules<C, TCell, TMove, TState> _rules;
  final _sync = StreamController<GameEvent<C>>.broadcast(sync: true);
  final _async = StreamController<GameEvent<C>>.broadcast();
  final _committed = StreamController<MoveCommand<TMove, TState>>.broadcast(
    sync: true,
  );
  TState _state;
  GamePhase _phase = const PlayingPhase();
  bool _publishing = false;

  /// The current state of the game.
  TState get state => _state;

  /// The current phase of the game.
  @override
  GamePhase get phase => _phase;

  /// Every event, delivered before the call that caused it returns.
  @override
  Stream<GameEvent<C>> get syncEvents => _sync.stream;

  /// Every event, delivered a moment after the call that caused it returns.
  Stream<GameEvent<C>> get events => _async.stream;

  /// One command per turn played, with the move and the states before and
  /// after it, delivered before `submit` returns and after the turn's events
  /// on [syncEvents]. A turn that ends the game is also sent: after a victory
  /// that lets the player keep playing, it can still be undone (RN-COM-63).
  /// A rejected move sends nothing (RN-COM-21). Its listeners must not call
  /// the engine either (D-32).
  @override
  Stream<MoveCommand<TMove, TState>> get committedTurns => _committed.stream;

  /// Whether [close] was called. A closed engine cannot be used.
  bool get isClosed => _sync.isClosed;

  /// Plays [move] if the phase accepts it.
  ///
  /// - A played turn goes through the resolving phase and publishes
  ///   `PhaseChanged` to resolving, the events of the rules in order,
  ///   `ScoreChanged` if the score changed and `PhaseChanged` to the phase
  ///   the turn led to (D-94).
  /// - A rejected move (by the phase, RN-COM-24, or by the rules, RN-COM-21)
  ///   changes nothing and publishes only `MoveRejected`.
  ///
  /// If the rules throw, the engine goes back to the state and phase it had
  /// and rethrows.
  MoveResult<C, TState> submit(TMove move) {
    _checkUsable('submit');
    final before = _phase;
    if (!before.acceptsMoves) return _reject(const NotAcceptingMoves._());

    final resolving = before.onTurnStarted();
    _phase = resolving; // a move submitted now is rejected (RN-COM-24)
    final TurnResult<C, TState> turn;
    try {
      turn = _rules.playTurn(_state, move);
    } catch (_) {
      _phase = before;
      rethrow;
    }

    switch (turn) {
      case RejectedTurn(:final reason):
        _phase = before; // the turn did not happen (RN-COM-21)
        return _reject(reason);
      case PlayedTurn(:final state, events: final ruleEvents, :final outcome):
        final stateBefore = _state;
        final scoreBefore = stateBefore.score;
        _state = state;
        _phase = resolving.onTurnFinished(outcome);
        final events = List<GameEvent<C>>.unmodifiable([
          PhaseChanged<C>(before, resolving),
          ...ruleEvents,
          if (state.score != scoreBefore)
            ScoreChanged<C>(scoreBefore, state.score),
          PhaseChanged<C>(resolving, _phase),
        ]);
        _publish(events, committed: MoveCommand(move, stateBefore, state));
        return AcceptedMove(state, events, outcome);
    }
  }

  /// Pauses a game that is being played (RN-COM-31, RN-COM-32). In any other
  /// phase it does nothing.
  void pause() {
    _checkUsable('pause');
    _moveTo(_phase.onPause());
  }

  /// Resumes a paused game (RN-COM-31). In any other phase it does nothing.
  void resume() {
    _checkUsable('resume');
    _moveTo(_phase.onResume());
  }

  /// Keeps playing after a victory whose outcome allows it (RN-COM-31). In
  /// any other phase it does nothing.
  void continuePlaying() {
    _checkUsable('continuePlaying');
    _moveTo(_phase.onContinue());
  }

  /// Goes back (undo) or forward (redo) to [snapshot], a state of a
  /// `MoveCommand` (D-31). The phase does not change (D-102).
  ///
  /// It publishes `StateRestored` and, if the score changed, `ScoreChanged`
  /// after it (D-103). The active time is not restored: it is not part of
  /// the state (D-106).
  ///
  /// Throws a [StateError] if the current phase does not allow undo, for
  /// example after a defeat (RN-COM-63); `UndoHistory.canUndo` checks it
  /// first, so this only stops a caller that skips the history.
  @override
  void restore(TState snapshot) {
    _checkUsable('restore');
    if (!_phase.allowsUndo) {
      throw StateError('restore: $_phase does not allow undo (RN-COM-63)');
    }
    final scoreBefore = _state.score;
    _state = snapshot;
    _publish([
      StateRestored<C>(),
      if (snapshot.score != scoreBefore)
        ScoreChanged<C>(scoreBefore, snapshot.score),
    ]);
  }

  /// Closes the three streams. The engine cannot be used afterwards; closing it
  /// again does nothing. Like the other operations, it throws a [StateError]
  /// if a synchronous listener calls it, so a turn is never cut in half.
  Future<void> close() {
    if (_publishing) {
      throw StateError('close: called from a synchronous listener (D-32)');
    }
    if (isClosed) return Future.value();
    return Future.wait([_sync.close(), _async.close(), _committed.close()]);
  }

  RejectedMove<C, TState> _reject(RejectionReason reason) {
    final events = List<GameEvent<C>>.unmodifiable([MoveRejected<C>(reason)]);
    _publish(events);
    return RejectedMove(reason, events);
  }

  void _moveTo(GamePhase next) {
    if (next == _phase) return;
    final event = PhaseChanged<C>(_phase, next);
    _phase = next;
    _publish([event]);
  }

  void _publish(
    List<GameEvent<C>> events, {
    MoveCommand<TMove, TState>? committed,
  }) {
    _publishing = true;
    try {
      events.forEach(_sync.add);
      if (committed != null) _committed.add(committed);
    } finally {
      _publishing = false;
    }
    events.forEach(_async.add);
  }

  void _checkUsable(String operation) {
    if (isClosed) {
      throw StateError('$operation: the engine is closed');
    }
    if (_publishing) {
      throw StateError('$operation: called from a synchronous listener (D-32)');
    }
  }
}
