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

  group('RN-COM-60', () {
    test('should_have_no_undo_when_the_game_does_not_allow_it', () {
      // Arrange
      final engine = newEngine();

      // Act
      final session = GameSession(engine);

      // Assert
      expect(identical(session.engine, engine), isTrue);
      expect(session.undo, isNull);
      expect(session.timer, isNull);
    });
  });

  group('D-33', () {
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

    test('should_read_the_seed_from_the_state_when_the_game_is_seeded', () {
      // Arrange
      final engine = GameEngine(
        const FakeSeededRules(labels: ['red', 'blue']),
        FakeSeededState.start(board3x1(), seed: 12345),
      );
      addTearDown(engine.close);
      final session = GameSession(engine);
      engine.submit(const FakeMove(a));

      // Act
      final state = session.engine.state;

      // Assert
      expect(state, isA<IRandomSeeded>());
      expect(state.seed, 12345);
      expect(state.random, isNot(Xorshift32(12345)));
    });
  });
}
