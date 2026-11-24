import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);
  const key = SavedGameKey(ProfileId.guest, GameKey('fake-game', 'fake-shape'));

  /// A session on an empty board of [width] cells, played with [rules].
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> sessionOf(
    int width, [
    FakeRules? rules,
  ]) {
    final board = Board<FakeCoord, FakeCell>.of(
      const FakeTopology(),
      ShapeSpec('rectangle', [width, 1]),
    );
    final engine = GameEngine(rules ?? FakeRules(), FakeState(board));
    addTearDown(engine.close);
    return GameSession(engine);
  }

  group('RN-COM-33', () {
    test(
      'should_save_the_snapshot_when_the_game_goes_on_after_the_turn',
      () async {
        // Arrange
        final session = sessionOf(3);
        final saved = FakeSavedGameRepository<FakeState>();
        final useCase = ApplyMoveUseCase(session, saved, key);

        // Act
        final result = await useCase.execute(const FakeMove(a));

        // Assert
        expect(result, isA<AcceptedMove<FakeCoord, FakeState>>());
        expect(saved.calls, ['save']);
        expect(saved.savedAt(key)?.state, session.engine.state);
      },
    );
  });

  group('RN-COM-35', () {
    test('should_delete_the_saved_game_when_the_turn_ends_the_game', () async {
      // Arrange: one cell, so the first move fills the board (defeat)
      final session = sessionOf(1);
      final saved = FakeSavedGameRepository<FakeState>();
      final useCase = ApplyMoveUseCase(session, saved, key);

      // Act
      final result = await useCase.execute(const FakeMove(a));

      // Assert
      expect(
        result,
        isA<AcceptedMove<FakeCoord, FakeState>>().having(
          (r) => r.outcome,
          'outcome',
          isA<Defeat>(),
        ),
      );
      expect(saved.calls, ['delete']);
    });

    test('should_delete_the_saved_game_when_the_turn_wins_for_good', () async {
      // Arrange
      final session = sessionOf(3, FakeRules(victoryWhen: (_) => true));
      final saved = FakeSavedGameRepository<FakeState>();
      final useCase = ApplyMoveUseCase(session, saved, key);

      // Act
      await useCase.execute(const FakeMove(a));

      // Assert
      expect(saved.calls, ['delete']);
    });
  });

  group('D-112', () {
    test(
      'should_neither_save_nor_delete_when_the_player_may_keep_playing',
      () async {
        // Arrange
        final session = sessionOf(
          3,
          FakeRules(victoryWhen: (_) => true, canContinue: true),
        );
        final saved = FakeSavedGameRepository<FakeState>();
        final useCase = ApplyMoveUseCase(session, saved, key);

        // Act
        await useCase.execute(const FakeMove(a));

        // Assert
        expect(saved.calls, isEmpty);
      },
    );
  });

  group('RN-COM-21', () {
    test('should_save_nothing_when_the_move_is_rejected', () async {
      // Arrange
      final session = sessionOf(3);
      session.engine.submit(const FakeMove(b));
      final saved = FakeSavedGameRepository<FakeState>();
      final useCase = ApplyMoveUseCase(session, saved, key);

      // Act
      final result = await useCase.execute(const FakeMove(b));

      // Assert
      expect(
        result,
        isA<RejectedMove<FakeCoord, FakeState>>().having(
          (r) => r.reason,
          'reason',
          const CellOccupied(b),
        ),
      );
      expect(saved.calls, isEmpty);
    });
  });
}
