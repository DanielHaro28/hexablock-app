import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

void main() {
  const playing = PlayingPhase();
  const resolving = ResolvingPhase();
  const paused = PausedPhase();
  const victory = VictoryPhase(canContinue: false);
  const continuable = VictoryPhase(canContinue: true);
  const gameOver = GameOverPhase();

  group('RN-COM-30', () {
    test('should_have_exactly_five_phases_when_switching_over_them', () {
      // Arrange
      const phases = <GamePhase>[playing, resolving, paused, victory, gameOver];

      // Act
      final names = [
        for (final phase in phases)
          switch (phase) {
            PlayingPhase() => 'playing',
            ResolvingPhase() => 'resolving',
            PausedPhase() => 'paused',
            VictoryPhase() => 'victory',
            GameOverPhase() => 'gameOver',
          },
      ];

      // Assert
      expect(names, ['playing', 'resolving', 'paused', 'victory', 'gameOver']);
    });

    test('should_be_equal_when_two_phases_are_the_same_kind', () {
      // Arrange
      final built = VictoryPhase(canContinue: [true].single);

      // Act
      final same = built == continuable;

      // Assert
      expect(same, isTrue);
      expect(built.hashCode, continuable.hashCode);
      expect(continuable, isNot(victory));
    });
  });

  group('RN-COM-24', () {
    test('should_accept_moves_only_when_playing', () {
      // Arrange
      const phases = <GamePhase>[playing, resolving, paused, victory, gameOver];

      // Act
      final accepting = phases.where((phase) => phase.acceptsMoves);

      // Assert
      expect(accepting, [playing]);
    });
  });

  group('RN-COM-31', () {
    test('should_start_resolving_when_a_turn_starts_while_playing', () {
      // Act
      final next = playing.onTurnStarted();

      // Assert
      expect(next, resolving);
    });

    test('should_go_back_to_playing_when_the_turn_ends_ongoing', () {
      // Act
      final next = resolving.onTurnFinished(const Ongoing());

      // Assert
      expect(next, playing);
    });

    test('should_go_to_victory_when_the_turn_ends_in_victory', () {
      // Act
      final next = resolving.onTurnFinished(const Victory(canContinue: true));

      // Assert
      expect(next, continuable);
    });

    test('should_go_to_game_over_when_the_turn_ends_in_defeat', () {
      // Act
      final next = resolving.onTurnFinished(const Defeat());

      // Assert
      expect(next, gameOver);
    });

    test('should_pause_and_resume_when_playing', () {
      // Act
      final pausedPhase = playing.onPause();
      final resumed = pausedPhase.onResume();

      // Assert
      expect(pausedPhase, paused);
      expect(resumed, playing);
    });

    test('should_keep_playing_when_continuing_a_victory_that_allows_it', () {
      // Act
      final next = continuable.onContinue();

      // Assert
      expect(next, playing);
    });

    test('should_stay_in_victory_when_continuing_is_not_allowed', () {
      // Act
      final next = victory.onContinue();

      // Assert
      expect(next, victory);
    });

    test(
      'should_stay_in_the_same_phase_when_the_transition_is_not_allowed',
      () {
        // Arrange
        final notAllowed = <(String, GamePhase, GamePhase)>[
          (
            'turn started while resolving',
            resolving,
            resolving.onTurnStarted(),
          ),
          ('turn started while paused', paused, paused.onTurnStarted()),
          (
            'turn finished while playing',
            playing,
            playing.onTurnFinished(const Defeat()),
          ),
          ('pause while resolving', resolving, resolving.onPause()),
          ('pause after victory', victory, victory.onPause()),
          ('pause after defeat', gameOver, gameOver.onPause()),
          ('resume while playing', playing, playing.onResume()),
          ('resume after defeat', gameOver, gameOver.onResume()),
          ('continue while playing', playing, playing.onContinue()),
          ('continue while paused', paused, paused.onContinue()),
          ('continue after defeat', gameOver, gameOver.onContinue()),
        ];

        // Act
        final changed = [
          for (final (name, before, after) in notAllowed)
            if (!identical(before, after)) name,
        ];

        // Assert
        expect(changed, isEmpty);
      },
    );
  });

  group('D-34', () {
    test('should_be_equal_when_two_outcomes_are_the_same_kind', () {
      // Arrange
      final built = Victory(canContinue: [false].single);

      // Act
      final same = built == const Victory();

      // Assert
      expect(same, isTrue);
      expect(built.hashCode, const Victory().hashCode);
      expect(const Victory(canContinue: true), isNot(const Victory()));
      expect(const Ongoing(), isNot(const Defeat()));
    });
  });
}
