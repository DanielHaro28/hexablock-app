import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexablock_app/adapters/repositories/memory_progress_repository.dart';

void main() {
  const hex = GameKey('hexa-lines', 'hex');
  const square = GameKey('hexa-lines', 'square');
  final date = DateTime.utc(2026, 11, 24);

  group('RN-COM-80', () {
    test('should_load_nothing_when_nothing_was_saved', () async {
      // Arrange
      final repository = MemoryProgressRepository();

      // Act
      final progress = await repository.load(ProfileId.guest, hex);

      // Assert
      expect(progress, isNull);
    });

    test('should_load_the_last_progress_when_saved_twice', () async {
      // Arrange
      final repository = MemoryProgressRepository();
      await repository.save(ProfileId.guest, hex, HighScoreProgress(10, date));
      await repository.save(ProfileId.guest, hex, HighScoreProgress(20, date));

      // Act
      final progress = await repository.load(ProfileId.guest, hex);

      // Assert
      expect(progress, HighScoreProgress(20, date));
    });

    test('should_keep_one_progress_per_cell_shape_when_saving_two', () async {
      // Arrange
      final repository = MemoryProgressRepository();
      await repository.save(ProfileId.guest, hex, HighScoreProgress(10, date));
      await repository.save(
        ProfileId.guest,
        square,
        HighScoreProgress(20, date),
      );

      // Act
      final progress = await repository.load(ProfileId.guest, hex);

      // Assert
      expect(progress, HighScoreProgress(10, date));
    });

    test('should_keep_one_progress_per_profile_when_saving_two', () async {
      // Arrange
      final repository = MemoryProgressRepository();
      await repository.save(ProfileId.guest, hex, HighScoreProgress(10, date));
      await repository.save(
        const ProfileId('someone'),
        hex,
        HighScoreProgress(20, date),
      );

      // Act
      final progress = await repository.load(ProfileId.guest, hex);

      // Assert
      expect(progress, HighScoreProgress(10, date));
    });
  });
}
