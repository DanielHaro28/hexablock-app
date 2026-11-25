import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  group('RN-COM-81', () {
    test('should_start_with_guest_as_active_profile', () async {
      // Arrange
      final profiles = FakeProfileRepository();

      // Act
      final active = await profiles.active();
      final guest = await profiles.guest();

      // Assert
      expect(active.id, ProfileId.guest);
      expect(active.isGuest, isTrue);
      expect(active, guest);
    });

    test(
      'should_switch_active_profile_and_keep_guest_when_activated',
      () async {
        // Arrange
        final profiles = FakeProfileRepository();
        final account = Profile(
          id: const ProfileId('user-1'),
          kind: ProfileKind.account,
          displayName: 'Ana',
          createdAt: DateTime.utc(2026, 11, 25),
        );

        // Act
        await profiles.activate(account);

        // Assert
        expect(await profiles.active(), account);
        expect((await profiles.guest()).id, ProfileId.guest);
        expect(
          profiles.stored.keys,
          containsAll([ProfileId.guest, account.id]),
        );
      },
    );
  });
}
