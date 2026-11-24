import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

void main() {
  group('RN-COM-33', () {
    test('should_find_the_same_entry_when_the_key_is_built_again', () {
      // Arrange
      final saved = {
        const SavedGameKey(ProfileId('guest'), GameKey('hexa-x', 'hex')): 1,
      };

      // Act: new instances, built at run time
      final found =
          saved[SavedGameKey(
            ProfileId(['gu', 'est'].join()),
            GameKey(['hexa', 'x'].join('-'), 'hex'),
          )];

      // Assert
      expect(found, 1);
    });

    test('should_tell_apart_two_keys_when_the_cell_shape_differs', () {
      // Arrange
      const hex = SavedGameKey(ProfileId.guest, GameKey('hexa-x', 'hex'));
      const square = SavedGameKey(ProfileId.guest, GameKey('hexa-x', 'square'));

      // Act
      final same = hex == square;

      // Assert
      expect(same, isFalse);
    });

    test('should_name_the_profile_game_and_shape_when_printed', () {
      // Arrange
      const key = SavedGameKey(ProfileId.guest, GameKey('hexa-x', 'hex'));

      // Act
      final text = '$key';

      // Assert
      expect(text, 'SavedGameKey(ProfileId(guest), GameKey(hexa-x, hex))');
    });
  });
}
