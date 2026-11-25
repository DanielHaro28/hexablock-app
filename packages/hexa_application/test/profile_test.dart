import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

void main() {
  final createdAt = DateTime.utc(2026, 11, 25, 10);

  group('RN-COM-81', () {
    test('should_be_a_guest_when_kind_is_guest', () {
      // Arrange
      final profile = Profile(
        id: ProfileId.guest,
        kind: ProfileKind.guest,
        createdAt: createdAt,
      );

      // Act
      final isGuest = profile.isGuest;

      // Assert
      expect(isGuest, isTrue);
      expect(profile.displayName, isNull);
    });

    test('should_not_be_a_guest_when_kind_is_account', () {
      // Arrange
      final profile = Profile(
        id: const ProfileId('user-1'),
        kind: ProfileKind.account,
        displayName: 'Ana',
        createdAt: createdAt,
      );

      // Act
      final isGuest = profile.isGuest;

      // Assert
      expect(isGuest, isFalse);
      expect(profile.displayName, 'Ana');
    });

    test('should_equal_another_profile_when_all_fields_match', () {
      // Arrange
      final a = Profile(
        id: const ProfileId('user-1'),
        kind: ProfileKind.account,
        displayName: 'Ana',
        createdAt: createdAt,
      );
      final b = Profile(
        id: const ProfileId('user-1'),
        kind: ProfileKind.account,
        displayName: 'Ana',
        createdAt: createdAt,
      );
      final c = Profile(
        id: const ProfileId('user-1'),
        kind: ProfileKind.account,
        displayName: 'Beto',
        createdAt: createdAt,
      );

      // Act & Assert
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a.toString(), contains('user-1'));
    });
  });
}
