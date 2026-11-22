import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const a = FakeCoord(0, 0);

  /// An empty 3 × 1 board.
  Board<FakeCoord, FakeCell> board3x1() =>
      Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 1]));

  /// An engine that is closed when the test ends.
  GameEngine<FakeCoord, FakeCell, FakeMove, FakeState> newEngine() {
    final engine = GameEngine(FakeRules(), FakeState(board3x1()));
    addTearDown(engine.close);
    return engine;
  }

  group('D-33', () {
    test('should_have_no_capability_when_built_without_any', () {
      // Arrange
      final engine = newEngine();

      // Act
      final session = GameSession(engine);

      // Assert
      expect(identical(session.engine, engine), isTrue);
      expect(session.undo, isNull);
      expect(session.timer, isNull);
    });

    test('should_offer_the_capabilities_it_was_built_with', () {
      // Arrange
      final engine = newEngine();
      final undo = UndoHistory(engine, allowsRedo: true);
      final timer = ActiveTimer(engine, FakeClock());

      // Act
      final session = GameSession(engine, undo: undo, timer: timer);

      // Assert
      expect(identical(session.undo, undo), isTrue);
      expect(identical(session.timer, timer), isTrue);
    });

    test('should_undo_through_the_session_when_it_has_undo', () {
      // Arrange
      final engine = newEngine();
      final session = GameSession(engine, undo: UndoHistory(engine, limit: 1));
      final initial = engine.state;
      engine.submit(const FakeMove(a));

      // Act
      session.undo?.undo();

      // Assert
      expect(identical(engine.state, initial), isTrue);
    });
  });

  group('D-113', () {
    const b = FakeCoord(1, 0);
    const second = Duration(seconds: 1);

    test('should_snapshot_only_the_state_when_it_has_no_capability', () {
      // Arrange
      final engine = newEngine();
      final session = GameSession(engine);
      engine.submit(const FakeMove(a));

      // Act
      final snapshot = session.snapshot();

      // Assert
      expect(identical(snapshot.state, engine.state), isTrue);
      expect(snapshot.undo, isNull);
      expect(snapshot.activeTime, isNull);
    });

    test('should_include_the_last_turn_when_taken_after_submit_returns', () {
      // Arrange
      final engine = newEngine();
      final session = GameSession(engine, undo: UndoHistory(engine, limit: 1));
      final initial = engine.state;
      engine.submit(const FakeMove(a));

      // Act
      final snapshot = session.snapshot();

      // Assert
      expect(identical(snapshot.state, engine.state), isTrue);
      expect(snapshot.undo!.undoStates, hasLength(1));
      expect(identical(snapshot.undo!.undoStates.single, initial), isTrue);
    });

    test('should_include_the_redo_states_when_taken_after_undo_returns', () {
      // Arrange
      final engine = newEngine();
      final undo = UndoHistory(engine, allowsRedo: true);
      final session = GameSession(engine, undo: undo);
      engine.submit(const FakeMove(a));
      final afterA = engine.state;
      undo.undo();

      // Act
      final snapshot = session.snapshot();

      // Assert
      expect(snapshot.undo!.undoStates, isEmpty);
      expect(snapshot.undo!.redoStates, hasLength(1));
      expect(identical(snapshot.undo!.redoStates.single, afterA), isTrue);
    });

    test('should_include_the_active_time_when_the_session_is_timed', () {
      // Arrange
      final clock = FakeClock();
      final engine = newEngine();
      final session = GameSession(engine, timer: ActiveTimer(engine, clock));
      clock.advance(second * 4);

      // Act
      final snapshot = session.snapshot();

      // Assert
      expect(snapshot.activeTime, second * 4);
    });

    test('should_continue_the_same_game_when_rebuilt_from_its_snapshot', () {
      // Arrange
      final clock = FakeClock();
      final engine = newEngine();
      final undo = UndoHistory(engine, allowsRedo: true);
      final session = GameSession(
        engine,
        undo: undo,
        timer: ActiveTimer(engine, clock),
      );
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      final afterB = engine.state;
      undo.undo();
      clock.advance(second * 3);
      final saved = session.snapshot();
      clock.advance(second * 60); // the app was closed (RN-COM-34)

      // Act
      final continued = GameEngine.paused(FakeRules(), saved.state);
      addTearDown(continued.close);
      final continuedUndo = UndoHistory(
        continued,
        allowsRedo: true,
        from: saved.undo,
      );
      final continuedTimer = ActiveTimer(
        continued,
        clock,
        elapsed: saved.activeTime!,
      );
      continued.resume();
      continuedUndo.redo();

      // Assert
      expect(identical(continued.state, afterB), isTrue);
      expect(continuedUndo.canUndo, isTrue);
      expect(continuedTimer.activeTime, second * 3);
    });
  });
}
