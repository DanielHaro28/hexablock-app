import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

typedef _Engine = GameEngine<FakeCoord, FakeCell, FakeMove, FakeState>;

void main() {
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);
  const c = FakeCoord(2, 0);
  const d = FakeCoord(0, 1);

  /// An empty 3 × 2 board.
  FakeState empty3x2() => FakeState(
    Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 2])),
  );

  /// An engine that starts at [state] and is closed when the test ends.
  _Engine engineAt(FakeState state) {
    final engine = GameEngine(FakeRules(), state);
    addTearDown(engine.close);
    return engine;
  }

  /// The states of a game that plays a, b and c from an empty board:
  /// `[S0, S1, S2, S3]`.
  List<FakeState> timeline() {
    final engine = engineAt(empty3x2());
    final states = [engine.state];
    for (final cell in [a, b, c]) {
      engine.submit(FakeMove(cell));
      states.add(engine.state);
    }
    return states;
  }

  group('D-107', () {
    test('should_save_the_states_around_the_current_one_when_snapshotted', () {
      // Arrange
      final engine = engineAt(empty3x2());
      final history = UndoHistory(engine, allowsRedo: true);
      final states = [engine.state];
      for (final cell in [a, b, c]) {
        engine.submit(FakeMove(cell));
        states.add(engine.state);
      }
      history.undo(); // back to S2

      // Act
      final snapshot = history.snapshot();

      // Assert
      expect(snapshot.undoStates, [states[0], states[1]]);
      expect(snapshot.redoStates, [states[3]]);
      expect(identical(snapshot.undoStates.first, states[0]), isTrue);
    });

    test('should_save_nothing_when_no_turn_was_played', () {
      // Arrange
      final history = UndoHistory<FakeMove, FakeState>(engineAt(empty3x2()));

      // Act
      final snapshot = history.snapshot();

      // Assert
      expect(snapshot.undoStates, isEmpty);
      expect(snapshot.redoStates, isEmpty);
    });

    test('should_undo_the_saved_turns_when_continued_from_a_snapshot', () {
      // Arrange
      final states = timeline();
      final engine = engineAt(states[3]); // the game continues at S3
      final history = UndoHistory<FakeMove, FakeState>(
        engine,
        from: UndoSnapshot(undoStates: [states[0], states[1], states[2]]),
      );

      // Act
      history
        ..undo()
        ..undo()
        ..undo();

      // Assert
      expect(identical(engine.state, states[0]), isTrue);
      expect(history.canUndo, isFalse);
    });

    test('should_redo_the_saved_turns_in_order_when_continued', () {
      // Arrange
      final states = timeline();
      final engine = engineAt(states[1]); // the game continues at S1
      final history = UndoHistory<FakeMove, FakeState>(
        engine,
        allowsRedo: true,
        from: UndoSnapshot(
          undoStates: [states[0]],
          redoStates: [states[2], states[3]],
        ),
      );

      // Act
      history.redo();
      final afterFirst = engine.state;
      history.redo();

      // Assert
      expect(identical(afterFirst, states[2]), isTrue);
      expect(identical(engine.state, states[3]), isTrue);
      expect(history.canRedo, isFalse);
    });

    test('should_give_back_the_same_snapshot_when_continued_from_it', () {
      // Arrange
      final states = timeline();
      final saved = UndoSnapshot(
        undoStates: [states[0], states[1]],
        redoStates: [states[3]],
      );
      final history = UndoHistory<FakeMove, FakeState>(
        engineAt(states[2]),
        allowsRedo: true,
        from: saved,
      );

      // Act
      final again = history.snapshot();

      // Assert
      expect(again.undoStates, saved.undoStates);
      expect(again.redoStates, saved.redoStates);
    });

    test(
      'should_keep_only_the_last_turns_when_the_snapshot_exceeds_the_limit',
      () {
        // Arrange
        final states = timeline();
        final engine = engineAt(states[3]);
        final history = UndoHistory<FakeMove, FakeState>(
          engine,
          limit: 1,
          from: UndoSnapshot(undoStates: [states[0], states[1], states[2]]),
        );

        // Act
        history
          ..undo()
          ..undo();

        // Assert
        expect(identical(engine.state, states[2]), isTrue);
        expect(history.snapshot().undoStates, isEmpty);
      },
    );

    test(
      'should_drop_the_redo_states_when_the_history_does_not_allow_redo',
      () {
        // Arrange
        final states = timeline();

        // Act
        final history = UndoHistory<FakeMove, FakeState>(
          engineAt(states[1]),
          limit: 1,
          from: UndoSnapshot(undoStates: [states[0]], redoStates: [states[2]]),
        );

        // Assert
        expect(history.canRedo, isFalse);
        expect(history.snapshot().redoStates, isEmpty);
      },
    );

    test('should_discard_the_saved_redo_when_a_new_move_is_made', () {
      // Arrange
      final states = timeline();
      final engine = engineAt(states[1]);
      final history = UndoHistory<FakeMove, FakeState>(
        engine,
        allowsRedo: true,
        from: UndoSnapshot(undoStates: [states[0]], redoStates: [states[2]]),
      );

      // Act
      engine.submit(const FakeMove(d));

      // Assert
      expect(history.canRedo, isFalse);
      expect(history.snapshot().undoStates, [states[0], states[1]]);
    });

    test('should_restore_the_generator_when_undoing_a_saved_turn', () {
      // Arrange
      final first = FakeSeededState.start(
        Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 1])),
        seed: 12345,
      );
      final played = GameEngine(
        const FakeSeededRules(labels: ['red', 'blue']),
        first,
      );
      addTearDown(played.close);
      played.submit(const FakeMove(a));
      final continued = GameEngine(
        const FakeSeededRules(labels: ['red', 'blue']),
        played.state,
      );
      addTearDown(continued.close);
      final history = UndoHistory<FakeMove, FakeSeededState>(
        continued,
        limit: 1,
        from: UndoSnapshot(undoStates: [first]),
      );

      // Act
      history.undo();

      // Assert
      expect(continued.state.random, Xorshift32(12345));
    });

    test('should_keep_the_move_in_each_committed_turn_when_played', () {
      // Arrange
      final engine = engineAt(empty3x2());
      final moves = <FakeMove?>[];
      final subscription = engine.committedTurns.listen(
        (command) => moves.add(command.move),
      );
      addTearDown(subscription.cancel);

      // Act
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));

      // Assert
      expect(moves, const [FakeMove(a), FakeMove(b)]);
    });
  });
}
