import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexablock_app/adapters/repositories/memory_saved_game_repository.dart';

void main() {
  const lines = SavedGameKey(ProfileId.guest, GameKey('hexa-lines', 'hex'));
  const merge = SavedGameKey(ProfileId.guest, GameKey('hexa-merge', 'hex'));

  group('RN-COM-33', () {
    test('should_load_the_last_game_saved_when_saved_twice', () async {
      // Arrange
      final repository = MemorySavedGameRepository<String>();
      repository
        ..scheduleSave(lines, const SavedGame('first'))
        ..scheduleSave(lines, const SavedGame('second'));

      // Act
      final saved = await repository.load(lines);

      // Assert
      expect(saved?.state, 'second');
    });

    test('should_keep_one_game_per_key_when_saving_two_games', () async {
      // Arrange
      final repository = MemorySavedGameRepository<String>()
        ..scheduleSave(lines, const SavedGame('lines'))
        ..scheduleSave(merge, const SavedGame('merge'));

      // Act
      final saved = await repository.load(merge);

      // Assert
      expect(saved?.state, 'merge');
      expect(await repository.exists(ProfileId.guest), isTrue);
    });
  });

  group('RN-COM-35', () {
    test('should_load_nothing_when_the_game_was_deleted', () async {
      // Arrange
      final repository = MemorySavedGameRepository<String>()
        ..scheduleSave(lines, const SavedGame('lines'))
        ..delete(lines);

      // Act
      await repository.flush();
      final saved = await repository.load(lines);

      // Assert
      expect(saved, isNull);
      expect(await repository.exists(ProfileId.guest), isFalse);
    });
  });
}
