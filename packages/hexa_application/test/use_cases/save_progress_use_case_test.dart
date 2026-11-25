import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const game = GameKey('fake-game', 'fake-shape');
  const otherShape = GameKey('fake-game', 'other-shape');
  const profile = ProfileId.guest;
  const model = _StarsTimeMovesModel();
  final earlier = DateTime.utc(2026, 11, 20, 9);

  /// The use case over [progress], [profiles] and [clock].
  SaveProgressUseCase useCaseOf(
    FakeProgressRepository progress, {
    FakeProfileRepository? profiles,
    FakeClock? clock,
  }) => SaveProgressUseCase(
    progress,
    profiles ?? FakeProfileRepository(),
    clock ?? FakeClock(),
  );

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
          clock: clock,
        ).execute(const HighScoreResult(game, 101));

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
          .execute(const HighScoreResult(game, 100));

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
          .execute(const HighScoreResult(game, 40));

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
          clock: clock,
        ).execute(const HighScoreResult(game, 0));

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
      await useCaseOf(
        progress,
        clock: clock,
      ).execute(const HighScoreResult(game, 10));

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
          clock: clock,
        ).execute(const HighScoreResult(game, 20));

        // Assert
        expect(kept, HighScoreProgress(20, clock.now()));
        expect(
          progress.savedAt(profile, otherShape),
          HighScoreProgress(500, earlier),
        );
      },
    );

    test(
      'should_save_under_active_profile_when_an_account_is_active',
      () async {
        // Arrange
        const accountId = ProfileId('user-1');
        final progress = FakeProgressRepository({
          (profile, game): HighScoreProgress(500, earlier),
        });
        final profiles = FakeProfileRepository();
        await profiles.activate(
          Profile(
            id: accountId,
            kind: ProfileKind.account,
            displayName: 'Ana',
            createdAt: earlier,
          ),
        );
        final clock = FakeClock();

        // Act
        final kept = await useCaseOf(
          progress,
          profiles: profiles,
          clock: clock,
        ).execute(const HighScoreResult(game, 120));

        // Assert
        expect(kept, HighScoreProgress(120, clock.now()));
        expect(progress.savedAt(accountId, game), kept);
        expect(
          progress.savedAt(profile, game),
          HighScoreProgress(500, earlier),
        );
      },
    );
  });

  group('RN-COM-83', () {
    test('should_save_first_level_attempt_when_there_is_none', () async {
      // Arrange
      final progress = FakeProgressRepository();
      final clock = FakeClock();

      // Act
      final kept = await useCaseOf(progress, clock: clock).execute(
        const LevelCompletedResult(
          game,
          levelId: 'lvl-001',
          moves: 4,
          stars: 2,
          timeMs: 30000,
          model: model,
        ),
      );

      // Assert
      final expected = LevelsProgress({
        'lvl-001': LevelAttempt(
          moves: 4,
          stars: 2,
          timeMs: 30000,
          achievedAt: clock.now(),
        ),
      });
      expect(kept, expected);
      expect(progress.savedAt(profile, game), expected);
    });

    test(
      'should_preserve_other_levels_when_completing_another_level',
      () async {
        // Arrange
        final first = LevelAttempt(
          moves: 3,
          stars: 3,
          timeMs: 28000,
          achievedAt: earlier,
        );
        final progress = FakeProgressRepository({
          (profile, game): LevelsProgress({'lvl-001': first}),
        });
        final clock = FakeClock();

        // Act
        final kept = await useCaseOf(progress, clock: clock).execute(
          const LevelCompletedResult(
            game,
            levelId: 'lvl-002',
            moves: 5,
            score: 210,
            model: model,
          ),
        );

        // Assert
        final expected = LevelsProgress({
          'lvl-001': first,
          'lvl-002': LevelAttempt(
            moves: 5,
            score: 210,
            achievedAt: clock.now(),
          ),
        });
        expect(kept, expected);
        expect(progress.savedAt(profile, game), expected);
      },
    );

    test('should_replace_level_attempt_when_new_attempt_is_better', () async {
      // Arrange
      final existing = LevelAttempt(
        moves: 4,
        stars: 2,
        timeMs: 30000,
        achievedAt: earlier,
      );
      final progress = FakeProgressRepository({
        (profile, game): LevelsProgress({'lvl-001': existing}),
      });
      final clock = FakeClock();

      // Act
      final kept = await useCaseOf(progress, clock: clock).execute(
        const LevelCompletedResult(
          game,
          levelId: 'lvl-001',
          moves: 3,
          stars: 3,
          timeMs: 38000,
          model: model,
        ),
      );

      // Assert
      final expected = LevelsProgress({
        'lvl-001': LevelAttempt(
          moves: 3,
          stars: 3,
          timeMs: 38000,
          achievedAt: clock.now(),
        ),
      });
      expect(kept, expected);
      expect(progress.saves, 1);
    });

    test(
      'should_keep_existing_level_attempt_when_new_attempt_is_worse',
      () async {
        // Arrange
        final existing = LevelAttempt(
          moves: 3,
          stars: 3,
          timeMs: 28000,
          achievedAt: earlier,
        );
        final existingProgress = LevelsProgress({'lvl-001': existing});
        final progress = FakeProgressRepository({
          (profile, game): existingProgress,
        });

        // Act
        final kept = await useCaseOf(progress).execute(
          const LevelCompletedResult(
            game,
            levelId: 'lvl-001',
            moves: 5,
            stars: 2,
            timeMs: 15000,
            model: model,
          ),
        );

        // Assert
        expect(kept, existingProgress);
        expect(progress.saves, 0);
      },
    );

    test('should_keep_existing_level_attempt_when_tied_and_achieved_later_or_same_time', () async {
      // Arrange
      final existing = LevelAttempt(
        moves: 3,
        stars: 3,
        timeMs: 28000,
        achievedAt: earlier,
      );
      final existingProgress = LevelsProgress({'lvl-001': existing});
      final progress = FakeProgressRepository({
        (profile, game): existingProgress,
      });
      final laterClock = FakeClock(
        startDate: earlier.add(const Duration(minutes: 5)),
      );

      // Act
      final kept = await useCaseOf(progress, clock: laterClock).execute(
        const LevelCompletedResult(
          game,
          levelId: 'lvl-001',
          moves: 3,
          stars: 3,
          timeMs: 28000,
          model: model,
        ),
      );

      // Assert
      expect(kept, existingProgress);
      expect(progress.saves, 0);
    });

    test(
      'should_replace_level_attempt_when_tied_and_achieved_earlier',
      () async {
        // Arrange
        final existing = LevelAttempt(
          moves: 3,
          stars: 3,
          timeMs: 28000,
          achievedAt: earlier.add(const Duration(minutes: 5)),
        );
        final progress = FakeProgressRepository({
          (profile, game): LevelsProgress({'lvl-001': existing}),
        });
        final earlierClock = FakeClock(startDate: earlier);

        // Act
        final kept = await useCaseOf(progress, clock: earlierClock).execute(
          const LevelCompletedResult(
            game,
            levelId: 'lvl-001',
            moves: 3,
            stars: 3,
            timeMs: 28000,
            model: model,
          ),
        );

        // Assert
        expect(
          kept,
          LevelsProgress({
            'lvl-001': LevelAttempt(
              moves: 3,
              stars: 3,
              timeMs: 28000,
              achievedAt: earlier,
            ),
          }),
        );
        expect(progress.saves, 1);
      },
    );

    test(
      'should_throw_state_error_when_result_shape_mismatches_saved_progress',
      () async {
        // Arrange
        final progress = FakeProgressRepository({
          (profile, game): HighScoreProgress(100, earlier),
        });

        // Act & Assert
        await expectLater(
          useCaseOf(progress).execute(
            const LevelCompletedResult(
              game,
              levelId: 'lvl-001',
              moves: 3,
              model: model,
            ),
          ),
          throwsStateError,
        );
        expect(progress.saves, 0);
      },
    );
  });
}

final class _StarsTimeMovesModel implements IProgressModel<LevelAttempt> {
  const _StarsTimeMovesModel();

  @override
  int compare(LevelAttempt a, LevelAttempt b) {
    final stars = (b.stars ?? 0).compareTo(a.stars ?? 0);
    if (stars != 0) return stars;
    final time = (a.timeMs ?? 0).compareTo(b.timeMs ?? 0);
    if (time != 0) return time;
    return a.moves.compareTo(b.moves);
  }
}
