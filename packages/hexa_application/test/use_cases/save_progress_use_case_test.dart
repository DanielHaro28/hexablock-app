import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const game = GameKey('fake-game', 'fake-shape');
  const otherShape = GameKey('fake-game', 'other-shape');
  const profile = ProfileId.guest;
  final earlier = DateTime.utc(2026, 11, 20, 9);

  /// The use case over [progress], dated by [clock].
  SaveProgressUseCase useCaseOf(
    FakeProgressRepository progress, [
    FakeClock? clock,
  ]) => SaveProgressUseCase(progress, clock ?? FakeClock(), profile);

  group('RN-HL-71', () {
    test(
      'should_save_the_score_as_the_record_when_it_beats_the_record',
      () async {
        // Arrange
        final progress = FakeProgressRepository({
          (profile, game): HighScoreProgress(100, earlier),
        });
        final clock = FakeClock();

        // Act
        final kept = await useCaseOf(
          progress,
          clock,
        ).execute(const GameResult(game, 101));

        // Assert
        final record = HighScoreProgress(101, clock.now());
        expect(kept, record);
        expect(progress.savedAt(profile, game), record);
      },
    );

    test('should_keep_the_record_when_the_score_equals_it', () async {
      // Arrange
      final record = HighScoreProgress(100, earlier);
      final progress = FakeProgressRepository({(profile, game): record});

      // Act
      final kept = await useCaseOf(progress)
          .execute(const GameResult(game, 100));

      // Assert
      expect(kept, record);
      expect(progress.saves, 0);
    });

    test('should_keep_the_record_when_the_score_is_lower', () async {
      // Arrange
      final record = HighScoreProgress(100, earlier);
      final progress = FakeProgressRepository({(profile, game): record});

      // Act
      final kept = await useCaseOf(progress)
          .execute(const GameResult(game, 40));

      // Assert
      expect(kept, record);
      expect(progress.saves, 0);
    });

    test(
      'should_save_the_first_score_as_the_record_when_there_is_none',
      () async {
        // Arrange
        final progress = FakeProgressRepository();
        final clock = FakeClock();

        // Act
        final kept = await useCaseOf(
          progress,
          clock,
        ).execute(const GameResult(game, 0));

        // Assert
        expect(kept, HighScoreProgress(0, clock.now()));
        expect(progress.saves, 1);
      },
    );

    test('should_date_the_record_with_the_clock_when_it_is_saved', () async {
      // Arrange
      final progress = FakeProgressRepository();
      final clock = FakeClock(startDate: DateTime.utc(2026, 11, 24, 18, 30))
        ..advance(const Duration(seconds: 5));

      // Act
      await useCaseOf(progress, clock).execute(const GameResult(game, 10));

      // Assert
      expect(
        progress.savedAt(profile, game),
        HighScoreProgress(10, DateTime.utc(2026, 11, 24, 18, 30, 5)),
      );
    });
  });

  group('RN-COM-80', () {
    test(
      'should_keep_each_cell_shape_apart_when_another_one_has_a_record',
      () async {
        // Arrange
        final progress = FakeProgressRepository({
          (profile, otherShape): HighScoreProgress(500, earlier),
        });
        final clock = FakeClock();

        // Act
        final kept = await useCaseOf(
          progress,
          clock,
        ).execute(const GameResult(game, 20));

        // Assert
        expect(kept, HighScoreProgress(20, clock.now()));
        expect(
          progress.savedAt(profile, otherShape),
          HighScoreProgress(500, earlier),
        );
      },
    );
  });
}
