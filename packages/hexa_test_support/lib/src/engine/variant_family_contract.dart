import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

/// Registers the tests that every [VariantFamily] must pass, whatever its
/// variant (D-116, RNF-03).
///
/// Call it inside a `group` of the factory's own tests, with [options] its
/// `createSession` accepts. [family] builds a fresh factory for each test.
///
/// It checks what `StartGameUseCase` relies on but the types cannot
/// enforce: a new game starts playing and is the same for the same options
/// (RN-COM-41), records its seed if it uses chance (RN-COM-45), and a saved
/// game continues paused (D-111) with the same capabilities and gives back,
/// with `snapshot()`, exactly what was saved (RN-COM-34, D-113). The state
/// must compare by value. What is specific to one variant (the initial board,
/// the tray) is tested by that variant's own tests.
void checkVariantFamilyContract<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>(
  VariantFamily<C, TCell, TMove, TState> Function() family,
  NewGameOptions options,
) {
  /// A saved game one turn in, if the new game has a valid move, so the
  /// history and the state are not just the initial ones.
  SavedGame<TState> savedAfterOneTurn() {
    final factory = family();
    final session = factory.createSession(options);
    final move = factory.createRules().validMoves(session.engine.state);
    if (move.isNotEmpty) session.engine.submit(move.first);
    return session.snapshot();
  }

  test('should_start_playing_when_the_game_is_new', () {
    // Act
    final session = family().createSession(options);

    // Assert
    expect(session.engine.phase, isA<PlayingPhase>());
  });

  test('should_build_the_same_state_when_the_options_are_the_same', () {
    // Arrange
    final first = family().createSession(options);

    // Act
    final second = family().createSession(options);

    // Assert
    expect(second.engine.state, first.engine.state);
  });

  test('should_record_the_seed_when_the_game_uses_chance', () {
    // Act
    final state = family().createSession(options).engine.state;

    // Assert
    if (state case final IRandomSeeded seeded) {
      expect(seeded.seed, options.seed);
    }
  });

  test('should_start_paused_when_a_saved_game_continues', () {
    // Arrange
    final saved = savedAfterOneTurn();

    // Act
    final session = family().continueSession(saved);

    // Assert
    expect(session.engine.phase, isA<PausedPhase>());
  });

  test('should_keep_the_capabilities_when_a_saved_game_continues', () {
    // Arrange
    final created = family().createSession(options);

    // Act
    final continued = family().continueSession(created.snapshot());

    // Assert
    expect(continued.undo == null, created.undo == null);
    expect(continued.timer == null, created.timer == null);
  });

  test('should_give_the_saved_game_back_when_a_continued_game_is_saved', () {
    // Arrange
    final saved = savedAfterOneTurn();

    // Act
    final again = family().continueSession(saved).snapshot();

    // Assert
    expect(again.state, saved.state);
    expect(again.undo?.undoStates, saved.undo?.undoStates);
    expect(again.undo?.redoStates, saved.undo?.redoStates);
    expect(again.activeTime, saved.activeTime);
  });
}
