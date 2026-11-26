import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const game = GameKey('fake-game', 'fake-shape');
  final date = DateTime.utc(2026, 11, 12);

  group('RN-HL-70', () {
    test('should_return_the_saved_record_when_there_is_one', () async {
      // Arrange
      final record = HighScoreProgress(1240, date);
      final progress = FakeProgressRepository({
        (ProfileId.guest, game): record,
      });
      final useCase = GetProgressUseCase(progress, FakeProfileRepository());

      // Act
      final read = await useCase.execute(game).right;

      // Assert
      expect(read, record);
    });

    test('should_return_null_when_the_game_was_never_finished', () async {
      // Arrange
      final useCase = GetProgressUseCase(
        FakeProgressRepository(),
        FakeProfileRepository(),
      );

      // Act
      final read = await useCase.execute(game).right;

      // Assert
      expect(read, isNull);
    });

    test('should_ignore_other_profiles_when_reading_the_record', () async {
      // Arrange
      final progress = FakeProgressRepository({
        (const ProfileId('someone'), game): HighScoreProgress(900, date),
      });
      final useCase = GetProgressUseCase(progress, FakeProfileRepository());

      // Act
      final read = await useCase.execute(game).right;

      // Assert
      expect(read, isNull);
    });
  });

  group('RN-COM-80', () {
    test(
      'should_read_from_the_active_profile_when_an_account_is_active',
      () async {
        // Arrange
        const accountId = ProfileId('user-42');
        final accountProgress = HighScoreProgress(2500, date);
        final progress = FakeProgressRepository({
          (ProfileId.guest, game): HighScoreProgress(100, date),
          (accountId, game): accountProgress,
        });
        final profiles = FakeProfileRepository();
        await profiles.activate(
          Profile(
            id: accountId,
            kind: ProfileKind.account,
            displayName: 'Ana',
            createdAt: date,
          ),
        );
        final useCase = GetProgressUseCase(progress, profiles);

        // Act
        final read = await useCase.execute(game).right;

        // Assert
        expect(read, accountProgress);
      },
    );

    test('should_return_levels_progress_when_levels_were_saved', () async {
      // Arrange
      final levels = LevelsProgress({
        'lvl-001': LevelAttempt(
          moves: 3,
          stars: 3,
          timeMs: 25000,
          achievedAt: date,
        ),
      });
      final progress = FakeProgressRepository({
        (ProfileId.guest, game): levels,
      });
      final useCase = GetProgressUseCase(progress, FakeProfileRepository());

      // Act
      final read = await useCase.execute(game).right;

      // Assert
      expect(read, levels);
    });
  });
}
