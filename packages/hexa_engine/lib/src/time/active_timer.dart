import '../board/coord.dart';
import '../game/game_event.dart';
import '../game/game_phase.dart';
import '../session/capabilities.dart';
import 'monotonic_clock.dart';

/// What `ActiveTimer` needs from `GameEngine`, and nothing else (ISP): the
/// current phase and the events it publishes synchronously.
abstract interface class TimedEngine {
  /// The current phase.
  GamePhase get phase;

  /// Every event, delivered before the call that caused it returns (D-32).
  Stream<GameEvent<Coord>> get syncEvents;
}

/// The active time of a game: it runs while the phase counts time and stops
/// otherwise (RN-COM-52, D-106).
///
/// - The phase decides whether time runs (`countsActiveTime`), so the timer
///   has no `if` per phase (D-34): it runs while playing and while a turn is
///   resolved, and stops while paused and after a victory or a defeat.
/// - It hears each `PhaseChanged` on the engine's synchronous stream, so it
///   is up to date when `submit` returns.
/// - [activeTime] is computed when read: the closed stretches plus the one
///   still running. Nothing ticks, so the screen reads it as often as it
///   redraws and the tests move a fake clock.
/// - Undoing a turn does not rewind it: time is not part of the state
///   (RN-COM-61).
/// - When the engine is closed, it stops.
final class ActiveTimer implements ITimed {
  /// A timer for [engine] that reads [clock], starting from [elapsed] (the
  /// time saved with a game that continues, D-37).
  ///
  /// It starts running if the engine's phase counts time.
  ///
  /// Throws an [ArgumentError] if [elapsed] is negative.
  ActiveTimer(
    TimedEngine engine,
    IMonotonicClock clock, {
    Duration elapsed = Duration.zero,
  }) : _clock = clock,
       _closedMillis = elapsed.inMilliseconds {
    if (elapsed.isNegative) {
      throw ArgumentError.value(elapsed, 'elapsed', 'must not be negative');
    }
    if (engine.phase.countsActiveTime) _start();
    engine.syncEvents.listen(_onEvent, onDone: _stop);
  }

  final IMonotonicClock _clock;

  /// The milliseconds of the stretches already closed.
  int _closedMillis;

  /// When the running stretch started, or `null` if time is stopped.
  int? _runningSinceMillis;

  @override
  Duration get activeTime => Duration(
    milliseconds:
        _closedMillis +
        switch (_runningSinceMillis) {
          final since? => _clock.nowMillis() - since,
          null => 0,
        },
  );

  void _onEvent(GameEvent<Coord> event) {
    if (event case PhaseChanged(:final to)) {
      to.countsActiveTime ? _start() : _stop();
    }
  }

  void _start() => _runningSinceMillis ??= _clock.nowMillis();

  void _stop() {
    if (_runningSinceMillis case final since?) {
      _closedMillis += _clock.nowMillis() - since;
      _runningSinceMillis = null;
    }
  }
}
