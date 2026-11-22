import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

typedef _Engine = GameEngine<FakeCoord, FakeCell, FakeMove, FakeState>;

void main() {
  const a = FakeCoord(0, 0);
  const second = Duration(seconds: 1);

  /// An empty 3 × 1 board.
  FakeState empty3x1() => FakeState(
    Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 1])),
  );

  /// An engine over [rules] that is closed when the test ends.
  _Engine engineWith([FakeRules? rules]) {
    final engine = GameEngine(rules ?? FakeRules(), empty3x1());
    addTearDown(engine.close);
    return engine;
  }

  group('RN-COM-52', () {
    test('should_count_the_time_played_when_playing', () {
      // Arrange
      final clock = FakeClock(startMillis: 1000);
      final timer = ActiveTimer(engineWith(), clock);

      // Act
      clock.advance(second * 3);

      // Assert
      expect(timer.activeTime, second * 3);
    });

    test('should_not_count_the_pause_when_paused', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith();
      final timer = ActiveTimer(engine, clock);
      clock.advance(second * 2);

      // Act
      engine.pause();
      clock.advance(second * 10);

      // Assert
      expect(timer.activeTime, second * 2);
    });

    test('should_count_again_when_resumed', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith();
      final timer = ActiveTimer(engine, clock);
      clock.advance(second * 2);
      engine.pause();
      clock.advance(second * 10);

      // Act
      engine.resume();
      clock.advance(second * 3);

      // Assert
      expect(timer.activeTime, second * 5);
    });

    test('should_stop_counting_when_the_game_is_won', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith(FakeRules(victoryWhen: (_) => true));
      final timer = ActiveTimer(engine, clock);
      clock.advance(second * 4);

      // Act
      engine.submit(const FakeMove(a));
      clock.advance(second * 10);

      // Assert
      expect(timer.activeTime, second * 4);
    });

    test('should_stop_counting_when_the_game_is_lost', () {
      // Arrange
      final clock = FakeClock();
      final engine = GameEngine(
        FakeRules(),
        FakeState(
          Board.of(const FakeTopology(), ShapeSpec('rectangle', const [1, 1])),
        ),
      );
      addTearDown(engine.close);
      final timer = ActiveTimer(engine, clock);
      clock.advance(second * 4);

      // Act
      engine.submit(const FakeMove(a)); // the only cell: a defeat
      clock.advance(second * 10);

      // Assert
      expect(engine.phase, const GameOverPhase());
      expect(timer.activeTime, second * 4);
    });

    test('should_count_again_when_playing_on_after_a_victory', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith(
        FakeRules(victoryWhen: (_) => true, canContinue: true),
      );
      final timer = ActiveTimer(engine, clock);
      engine.submit(const FakeMove(a));
      clock.advance(second * 10);

      // Act
      engine.continuePlaying();
      clock.advance(second * 2);

      // Assert
      expect(timer.activeTime, second * 2);
    });
  });

  group('D-106', () {
    test('should_include_the_running_stretch_when_read_while_playing', () {
      // Arrange
      final clock = FakeClock();
      final timer = ActiveTimer(engineWith(), clock);
      clock.advance(second);
      final first = timer.activeTime;

      // Act
      clock.advance(second);

      // Assert
      expect(first, second);
      expect(timer.activeTime, second * 2);
    });

    test('should_count_the_time_of_a_turn_while_it_is_resolved', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith(
        FakeRules(
          onApply: () => clock.advance(const Duration(milliseconds: 5)),
        ),
      );
      final timer = ActiveTimer(engine, clock);

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(timer.activeTime, const Duration(milliseconds: 5));
    });

    test('should_start_from_the_elapsed_time_when_given', () {
      // Arrange
      final clock = FakeClock();
      final timer = ActiveTimer(engineWith(), clock, elapsed: second * 90);

      // Act
      clock.advance(second);

      // Assert
      expect(timer.activeTime, second * 91);
    });

    test('should_start_stopped_when_the_engine_is_paused', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith()..pause();
      final timer = ActiveTimer(engine, clock, elapsed: second * 90);

      // Act
      clock.advance(second * 10);

      // Assert
      expect(timer.activeTime, second * 90);
    });

    test('should_not_rewind_when_a_turn_is_undone', () {
      // Arrange
      final clock = FakeClock();
      final engine = engineWith();
      final timer = ActiveTimer(engine, clock);
      final history = UndoHistory(engine, limit: 1);
      clock.advance(second * 2);
      engine.submit(const FakeMove(a));
      clock.advance(second * 3);

      // Act
      history.undo();

      // Assert
      expect(timer.activeTime, second * 5);
    });

    test('should_stop_counting_when_the_engine_is_closed', () async {
      // Arrange
      final clock = FakeClock();
      final engine = GameEngine(FakeRules(), empty3x1());
      final timer = ActiveTimer(engine, clock);
      clock.advance(second * 2);

      // Act
      await engine.close();
      clock.advance(second * 10);

      // Assert
      expect(timer.activeTime, second * 2);
    });

    test('should_throw_when_the_elapsed_time_is_negative', () {
      // Arrange
      final engine = engineWith();

      // Act
      ActiveTimer build() => ActiveTimer(
        engine,
        FakeClock(),
        elapsed: -const Duration(seconds: 1),
      );

      // Assert
      expect(build, throwsArgumentError);
    });
  });

  group('D-111', () {
    test('should_count_only_after_resume_when_the_engine_starts_paused', () {
      // Arrange
      final clock = FakeClock();
      final engine = GameEngine.paused(FakeRules(), empty3x1());
      addTearDown(engine.close);
      final timer = ActiveTimer(engine, clock, elapsed: second * 5);
      clock.advance(second * 60); // the app was closed (RN-COM-34)

      // Act
      engine.resume();
      clock.advance(second * 2);

      // Assert
      expect(timer.activeTime, second * 7);
    });
  });
}
