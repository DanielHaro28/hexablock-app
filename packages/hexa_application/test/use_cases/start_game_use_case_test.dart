import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const key = SavedGameKey(ProfileId.guest, GameKey('fake-game', 'fake-shape'));

  /// Closes the session's engine when the test ends.
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> track(
    GameSession<FakeCoord, FakeCell, FakeMove, FakeState> session,
  ) {
    addTearDown(session.engine.close);
    return session;
  }

  /// A saved game one move in, on a board of three cells.
  SavedGame<FakeState> savedGame() {
    final session = track(
      FakeVariantFamily().createSession(NewGameOptions(seed: 1)),
    );
    session.engine.submit(const FakeMove(FakeCoord(0, 0)));
    return session.snapshot();
  }

  group('D-124', () {
    test(
      'should_create_a_session_with_the_options_when_starting_anew',
      () async {
        // Arrange
        final family = FakeVariantFamily();
        final options = NewGameOptions(seed: 42);
        final useCase = StartGameUseCase(
          family,
          FakeSavedGameRepository<FakeState>(),
          key,
        );

        // Act
        final session = track(await useCase.execute(StartNew(options)));

        // Assert
        expect(family.newGames, [options]);
        expect(session.engine.phase, isA<PlayingPhase>());
      },
    );
  });

  group('RN-COM-35', () {
    test('should_delete_the_saved_game_when_a_new_game_starts', () async {
      // Arrange
      final saved = FakeSavedGameRepository({key: savedGame()});
      final useCase = StartGameUseCase(FakeVariantFamily(), saved, key);

      // Act
      track(await useCase.execute(StartNew(NewGameOptions(seed: 7))));

      // Assert
      expect(saved.calls, ['delete']);
      expect(saved.savedAt(key), isNull);
    });
  });

  group('RN-COM-35', () {
    test(
      'should_keep_the_saved_game_when_the_new_game_cannot_be_created',
      () async {
        // Arrange: a board of zero cells cannot be built
        final game = savedGame();
        final saved = FakeSavedGameRepository({key: game});
        final useCase = StartGameUseCase(
          FakeVariantFamily(width: 0),
          saved,
          key,
        );

        // Act
        final starting = useCase.execute(StartNew(NewGameOptions(seed: 7)));

        // Assert
        await expectLater(starting, throwsA(anything));
        expect(saved.savedAt(key), same(game));
      },
    );
  });

  group('RN-COM-34', () {
    test(
      'should_continue_the_saved_game_paused_when_asked_to_continue',
      () async {
        // Arrange
        final game = savedGame();
        final family = FakeVariantFamily();
        final useCase = StartGameUseCase(
          family,
          FakeSavedGameRepository({key: game}),
          key,
        );

        // Act
        final session = track(await useCase.execute(const ContinueSaved()));

        // Assert
        expect(family.continued, [game]);
        expect(family.newGames, isEmpty);
        expect(session.engine.state, game.state);
        expect(session.engine.phase, isA<PausedPhase>());
      },
    );

    test(
      'should_throw_a_rule_exception_when_there_is_no_game_to_continue',
      () async {
        // Arrange
        final useCase = StartGameUseCase(
          FakeVariantFamily(),
          FakeSavedGameRepository<FakeState>(),
          key,
        );

        // Act
        final starting = useCase.execute(const ContinueSaved());

        // Assert
        await expectLater(
          starting,
          throwsA(
            isA<RuleException>().having(
              (e) => e.code,
              'code',
              StartGameUseCase.noSavedGame,
            ),
          ),
        );
      },
    );
  });
}
