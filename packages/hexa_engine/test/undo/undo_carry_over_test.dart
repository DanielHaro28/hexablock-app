import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

typedef _Engine = GameEngine<FakeCoord, FakeCell, FakeMove, FakeSeededState>;
typedef _History = UndoHistory<FakeMove, FakeSeededState>;

void main() {
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);
  const c = FakeCoord(2, 0);

  /// The first state of a seeded game on an empty 3 × 2 board.
  FakeSeededState start() => FakeSeededState.start(
    Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 2])),
    seed: 12345,
  );

  /// An engine that starts at [state] and is closed when the test ends.
  _Engine engineAt(FakeSeededState state) {
    final engine = GameEngine(
      const FakeSeededRules(labels: ['red', 'green', 'blue']),
      state,
    );
    addTearDown(engine.close);
    return engine;
  }

  /// A history that keeps the moves counter across undo and redo, as a
  /// variant whose moves must not go back would configure it.
  _History keepingMoves(
    _Engine engine, {
    UndoSnapshot<FakeSeededState>? from,
  }) => UndoHistory(
    engine,
    allowsRedo: true,
    carryOver: (restored, current) => restored.keepingMovesOf(current),
    from: from,
  );

  group('D-109', () {
    test('should_keep_the_carried_value_when_a_turn_is_undone', () {
      // Arrange
      final engine = engineAt(start());
      final history = keepingMoves(engine);
      engine.submit(const FakeMove(a));
      final afterFirst = engine.state;
      engine.submit(const FakeMove(b));

      // Act
      history.undo();

      // Assert
      expect(engine.state.moves, 2);
      expect(engine.state.board, afterFirst.board);
      expect(engine.state.random, afterFirst.random);
      expect(engine.state.score, afterFirst.score);
    });

    test('should_keep_the_carried_value_when_a_turn_is_redone', () {
      // Arrange
      final engine = engineAt(start());
      final history = keepingMoves(engine);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      final latest = engine.state;
      history.undo();

      // Act
      history.redo();

      // Assert
      expect(engine.state.moves, 2);
      expect(engine.state.board, latest.board);
      expect(engine.state.random, latest.random);
    });

    test('should_count_on_from_the_kept_value_when_playing_after_undo', () {
      // Arrange
      final engine = engineAt(start());
      final history = keepingMoves(engine);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      history.undo();

      // Act
      engine.submit(const FakeMove(c));

      // Assert
      expect(engine.state.moves, 3);
    });

    test('should_keep_the_carried_value_when_undoing_a_saved_turn', () {
      // Arrange
      final first = start();
      final played = engineAt(first)..submit(const FakeMove(a));
      final continued = engineAt(played.state);
      final history = keepingMoves(
        continued,
        from: UndoSnapshot(undoStates: [first]),
      );

      // Act
      history.undo();

      // Assert
      expect(continued.state.moves, 1);
      expect(continued.state.board, first.board);
      expect(continued.state.random, first.random);
    });

    test('should_save_the_states_as_played_when_snapshotted', () {
      // Arrange
      final first = start();
      final engine = engineAt(first);
      final history = keepingMoves(engine);
      engine.submit(const FakeMove(a));
      history.undo(); // the engine keeps 1 move, the saved state does not

      // Act
      final snapshot = history.snapshot();

      // Assert
      expect(snapshot.redoStates.single.moves, 1);
      expect(identical(engine.state, first), isFalse);
      expect(engine.state.moves, 1);
    });
  });
}
