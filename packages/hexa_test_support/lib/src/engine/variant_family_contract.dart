import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

/// Registers the tests that every [VariantFamily] must pass, whatever its
/// variant (D-116, RNF-03).
///
/// Call it inside a `group` of the factory's own tests. [family] builds a
/// fresh factory for each test (a timed variant gets its `FakeClock` there).
/// [options] must give a game that is still going on after two turns.
/// [usesChance] says whether the variant's state is `IRandomSeeded`
/// (ARQ-02 §7), so forgetting the capability fails. [levelBased] says
/// whether the variant is played by levels: then [options] must name a level
/// of the factory's catalog in `levelId`, the state must be `ILevelBased`
/// with that id, and a missing or unknown id must throw an [ArgumentError]
/// (D-125), which `ExceptionAspect` turns into a `Left` (D-161).
///
/// It checks what `StartGameUseCase` relies on but the types cannot
/// enforce: a new game starts playing and is the same for the same options
/// (RN-COM-41) and records its seed if it uses chance (RN-COM-45); a saved
/// game continues paused (D-111) with the same capabilities, plays again
/// once resumed, and gives back with `snapshot()` exactly what was saved,
/// undo and redo history and active time included (RN-COM-34, D-113). The
/// state must compare by value. What is specific to one variant (the
/// initial board, the tray, what undo keeps) is tested by that variant's own
/// tests.
void checkVariantFamilyContract<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>(
  VariantFamily<C, TCell, TMove, TState> Function() family,
  NewGameOptions options, {
  required bool usesChance,
  required bool levelBased,
}) {
  GameSession<C, TCell, TMove, TState> track(
    GameSession<C, TCell, TMove, TState> session,
  ) {
    addTearDown(session.engine.close);
    return session;
  }

  /// Plays the first valid move and checks that the game goes on.
  void playOneTurn(
    VariantFamily<C, TCell, TMove, TState> factory,
    GameSession<C, TCell, TMove, TState> session,
  ) {
    final moves = factory.createRules().validMoves(session.engine.state);
    expect(moves, isNotEmpty, reason: 'options must allow two turns');
    final result = session.engine.submit(moves.first);
    switch (result) {
      case AcceptedMove<C, TState>(:final outcome):
        expect(
          outcome,
          isA<Ongoing>(),
          reason: 'options must give a game still going on after two turns',
        );
      case _:
        fail('the first valid move was rejected: $result');
    }
  }

  /// A saved game two turns in, with one turn undone if the game allows it,
  /// so the state and the undo and redo history are not the initial ones.
  /// Its active time is set to a nonzero value if the game measures it: time
  /// is not part of the state (D-106), so any value is a valid save.
  SavedGame<TState> playedAndSaved() {
    final factory = family();
    final session = track(factory.createSession(options));
    playOneTurn(factory, session);
    playOneTurn(factory, session);
    if (session.undo case final undo? when undo.canUndo) undo.undo();
    final saved = session.snapshot();
    return SavedGame(
      saved.state,
      undo: saved.undo,
      activeTime: saved.activeTime == null ? null : const Duration(seconds: 75),
    );
  }

  test('should_start_playing_when_the_game_is_new', () {
    // Act
    final session = track(family().createSession(options));

    // Assert
    expect(session.engine.phase, isA<PlayingPhase>());
  });

  test('should_build_the_same_state_when_the_options_are_the_same', () {
    // Arrange
    final first = track(family().createSession(options));

    // Act
    final second = track(family().createSession(options));

    // Assert
    expect(second.engine.state, first.engine.state);
  });

  test('should_record_the_seed_only_when_the_game_uses_chance', () {
    // Act
    final state = track(family().createSession(options)).engine.state;

    // Assert
    if (usesChance) {
      expect(
        state,
        isA<IRandomSeeded>().having((s) => s.seed, 'seed', options.seed),
      );
    } else {
      expect(state, isNot(isA<IRandomSeeded>()));
    }
  });

  test('should_record_the_level_only_when_the_game_is_level_based', () {
    // Act
    final state = track(family().createSession(options)).engine.state;

    // Assert
    if (levelBased) {
      expect(options.levelId, isNotNull, reason: 'options must name a level');
      expect(
        state,
        isA<ILevelBased>().having((s) => s.levelId, 'levelId', options.levelId),
      );
    } else {
      expect(state, isNot(isA<ILevelBased>()));
    }
  });

  if (levelBased) {
    test('should_throw_when_a_level_based_game_has_no_level', () {
      // Arrange
      final noLevel = NewGameOptions(seed: options.seed);

      // Act
      void create() => family().createSession(noLevel);

      // Assert
      expect(create, throwsArgumentError);
    });

    test('should_throw_when_the_level_is_not_in_the_catalog', () {
      // Arrange
      final unknown = NewGameOptions(
        seed: options.seed,
        levelId: '${options.levelId}-not-in-the-catalog',
      );

      // Act
      void create() => family().createSession(unknown);

      // Assert
      expect(create, throwsArgumentError);
    });
  }

  test('should_start_paused_when_a_saved_game_continues', () {
    // Arrange
    final saved = playedAndSaved();

    // Act
    final session = track(family().continueSession(saved));

    // Assert
    expect(session.engine.phase, isA<PausedPhase>());
  });

  test('should_keep_the_capabilities_when_a_saved_game_continues', () {
    // Arrange
    final created = track(family().createSession(options));

    // Act
    final continued = track(family().continueSession(created.snapshot()));

    // Assert
    expect(continued.undo == null, created.undo == null);
    expect(continued.timer == null, created.timer == null);
  });

  test('should_play_again_when_a_continued_game_resumes', () {
    // Arrange
    final factory = family();
    final session = track(factory.continueSession(playedAndSaved()));

    // Act
    session.engine.resume();

    // Assert
    expect(session.engine.phase, isA<PlayingPhase>());
    final moves = factory.createRules().validMoves(session.engine.state);
    expect(session.engine.submit(moves.first), isA<AcceptedMove<C, TState>>());
  });

  test('should_give_the_saved_game_back_when_a_continued_game_is_saved', () {
    // Arrange
    final saved = playedAndSaved();

    // Act
    final again = track(family().continueSession(saved)).snapshot();

    // Assert
    expect(again.state, saved.state);
    expect(again.undo?.undoStates, saved.undo?.undoStates);
    expect(again.undo?.redoStates, saved.undo?.redoStates);
    expect(again.activeTime, saved.activeTime);
  });
}
