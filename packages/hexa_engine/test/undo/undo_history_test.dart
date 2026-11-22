import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

typedef _Engine = GameEngine<FakeCoord, FakeCell, FakeMove, FakeState>;
typedef _SeededEngine =
    GameEngine<FakeCoord, FakeCell, FakeMove, FakeSeededState>;

void main() {
  const topology = FakeTopology();
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);
  const c = FakeCoord(2, 0);

  /// An empty 3 × 2 board: room for a few turns before it is full.
  Board<FakeCoord, FakeCell> board3x2() =>
      Board.of(topology, ShapeSpec('rectangle', const [3, 2]));

  /// An engine over [rules] that is closed when the test ends.
  _Engine engineWith(FakeRules rules, [FakeState? initial]) {
    final engine = GameEngine(rules, initial ?? FakeState(board3x2()));
    addTearDown(engine.close);
    return engine;
  }

  group('RN-COM-60', () {
    test('should_undo_every_turn_back_to_the_start_when_unlimited', () {
      // Arrange
      final initial = FakeState(board3x2());
      final engine = engineWith(FakeRules(), initial);
      final history = UndoHistory(engine, allowsRedo: true);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b))
        ..submit(const FakeMove(c));

      // Act
      history
        ..undo()
        ..undo()
        ..undo();

      // Assert
      expect(identical(engine.state, initial), isTrue);
      expect(history.canUndo, isFalse);
    });

    test('should_undo_only_the_last_turn_when_the_limit_is_one', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, limit: 1);
      engine.submit(const FakeMove(a));
      final afterFirst = engine.state;
      engine.submit(const FakeMove(b));

      // Act
      history.undo();

      // Assert
      expect(identical(engine.state, afterFirst), isTrue);
      expect(history.canUndo, isFalse);
    });

    test('should_not_redo_when_the_history_does_not_allow_it', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, limit: 1);
      engine.submit(const FakeMove(a));
      history.undo();
      final undone = engine.state;

      // Act
      history.redo();

      // Assert
      expect(history.canRedo, isFalse);
      expect(identical(engine.state, undone), isTrue);
    });

    test('should_redo_the_turns_in_order_when_redo_is_allowed', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, allowsRedo: true);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      final latest = engine.state;
      history
        ..undo()
        ..undo();

      // Act
      history
        ..redo()
        ..redo();

      // Assert
      expect(identical(engine.state, latest), isTrue);
      expect(history.canRedo, isFalse);
      expect(history.canUndo, isTrue);
    });
  });

  group('RN-COM-61', () {
    /// An engine with a seeded generator that is closed when the test ends.
    _SeededEngine seededEngine(FakeSeededState initial) {
      final engine = GameEngine(
        const FakeSeededRules(labels: ['red', 'green', 'blue']),
        initial,
      );
      addTearDown(engine.close);
      return engine;
    }

    test('should_restore_the_board_score_and_generator_when_undone', () {
      // Arrange
      final initial = FakeSeededState.start(board3x2(), seed: 12345);
      final engine = seededEngine(initial);
      final history = UndoHistory(engine, limit: 1);
      engine.submit(const FakeMove(a));

      // Act
      history.undo();

      // Assert
      expect(engine.state, initial);
      expect(engine.state.score, 0);
      expect(engine.state.random, Xorshift32(12345));
    });

    test('should_draw_the_same_piece_again_when_replayed_after_undo', () {
      // Arrange
      final engine = seededEngine(
        FakeSeededState.start(board3x2(), seed: 12345),
      );
      final history = UndoHistory(engine, limit: 1);
      engine.submit(const FakeMove(a));
      final first = engine.state;
      history.undo();

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(engine.state, first);
      expect(engine.state.board.cell(a), first.board.cell(a));
    });
  });

  group('RN-COM-62', () {
    test('should_discard_what_could_be_redone_when_a_new_move_is_made', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, allowsRedo: true);
      engine.submit(const FakeMove(a));
      history.undo();

      // Act
      engine.submit(const FakeMove(b));

      // Assert
      expect(history.canRedo, isFalse);
      expect(engine.state.board.cell(a), isNull);
    });
  });

  group('RN-COM-63', () {
    test('should_not_undo_when_the_game_was_lost', () {
      // Arrange
      final engine = engineWith(
        FakeRules(),
        FakeState(Board.of(topology, ShapeSpec('rectangle', const [1, 1]))),
      );
      final history = UndoHistory(engine, allowsRedo: true);
      engine.submit(const FakeMove(a)); // the only cell: a defeat
      final lost = engine.state;

      // Act
      history.undo();

      // Assert
      expect(engine.phase, const GameOverPhase());
      expect(history.canUndo, isFalse);
      expect(identical(engine.state, lost), isTrue);
    });

    test('should_not_undo_when_the_game_was_won', () {
      // Arrange
      final engine = engineWith(FakeRules(victoryWhen: (_) => true));
      final history = UndoHistory(engine, allowsRedo: true);
      engine.submit(const FakeMove(a));
      final won = engine.state;

      // Act
      history.undo();

      // Assert
      expect(engine.phase, const VictoryPhase(canContinue: false));
      expect(history.canUndo, isFalse);
      expect(identical(engine.state, won), isTrue);
    });

    test('should_undo_the_winning_turn_when_playing_on_after_victory', () {
      // Arrange
      final initial = FakeState(board3x2());
      final engine = engineWith(
        FakeRules(
          victoryWhen: (state) => state.board.cell(a) != null,
          canContinue: true,
        ),
        initial,
      );
      final history = UndoHistory(engine, limit: 1);
      engine
        ..submit(const FakeMove(a))
        ..continuePlaying();

      // Act
      history.undo();

      // Assert
      expect(identical(engine.state, initial), isTrue);
      expect(engine.phase, const PlayingPhase());
    });
  });

  group('RN-COM-21', () {
    test('should_not_record_a_move_when_it_is_rejected', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, limit: 1);

      // Act
      engine.submit(const FakeMove(FakeCoord(9, 9))); // off the board

      // Assert
      expect(history.canUndo, isFalse);
    });
  });

  group('D-31', () {
    test('should_not_undo_or_redo_when_the_game_is_paused', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, allowsRedo: true);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      history.undo();
      engine.pause();
      final paused = engine.state;

      // Act
      history
        ..undo()
        ..redo();

      // Assert
      expect(history.canUndo, isFalse);
      expect(history.canRedo, isFalse);
      expect(identical(engine.state, paused), isTrue);
    });

    test('should_do_nothing_when_there_is_no_turn_to_undo', () {
      // Arrange
      final initial = FakeState(board3x2());
      final engine = engineWith(FakeRules(), initial);
      final history = UndoHistory(engine, allowsRedo: true);
      final published = <Object>[];
      final subscription = engine.syncEvents.listen(published.add);
      addTearDown(subscription.cancel);

      // Act
      history
        ..undo()
        ..redo();

      // Assert
      expect(identical(engine.state, initial), isTrue);
      expect(published, isEmpty);
    });

    test('should_keep_the_limit_when_more_turns_are_played', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final history = UndoHistory(engine, limit: 2);
      engine.submit(const FakeMove(a));
      final afterFirst = engine.state;
      engine
        ..submit(const FakeMove(b))
        ..submit(const FakeMove(c));

      // Act
      history
        ..undo()
        ..undo()
        ..undo();

      // Assert
      expect(identical(engine.state, afterFirst), isTrue);
    });

    test('should_throw_when_the_limit_is_below_one', () {
      // Arrange
      final engine = engineWith(FakeRules());

      // Act
      UndoHistory<FakeMove, FakeState> build() => UndoHistory(engine, limit: 0);

      // Assert
      expect(build, throwsArgumentError);
    });

    test('should_forget_every_turn_when_the_engine_is_closed', () async {
      // Arrange
      final engine = GameEngine(FakeRules(), FakeState(board3x2()));
      final history = UndoHistory(engine, allowsRedo: true);
      engine
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));
      history.undo();

      // Act
      await engine.close();

      // Assert
      expect(history.canUndo, isFalse);
      expect(history.canRedo, isFalse);
    });
  });
}
