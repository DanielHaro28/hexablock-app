import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const game = GameKey('fake-game', 'fake-shape');
  const profile = ProfileId.guest;

  group('RN-HL-70', () {
    test('should_return_the_saved_record_when_there_is_one', () async {
      // Arrange
      final record = HighScoreProgress(1240, DateTime.utc(2026, 11, 12));
      final progress = FakeProgressRepository({(profile, game): record});
      final useCase = GetProgressUseCase(progress, profile);

      // Act
      final read = await useCase.execute(game);

      // Assert
      expect(read, record);
    });

    test('should_return_null_when_the_game_was_never_finished', () async {
      // Arrange
      final useCase = GetProgressUseCase(FakeProgressRepository(), profile);

      // Act
      final read = await useCase.execute(game);

      // Assert
      expect(read, isNull);
    });

    test('should_ignore_other_profiles_when_reading_the_record', () async {
      // Arrange
      final progress = FakeProgressRepository({
        (const ProfileId('someone'), game): HighScoreProgress(
          900,
          DateTime.utc(2026, 11, 12),
        ),
      });
      final useCase = GetProgressUseCase(progress, profile);

      // Act
      final read = await useCase.execute(game);

      // Assert
      expect(read, isNull);
    });
  });
}
