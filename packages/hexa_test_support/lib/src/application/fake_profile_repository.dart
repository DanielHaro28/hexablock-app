import 'package:hexa_application/hexa_application.dart';

/// A profile repository in memory for tests (D-56).
///
/// Starts with [ProfileId.guest] as both the guest and active profile.
final class FakeProfileRepository implements IProfileRepository {
  /// A repository whose guest profile was created at [guestCreatedAt].
  FakeProfileRepository({DateTime? guestCreatedAt})
    : _guest = Profile(
        id: ProfileId.guest,
        kind: ProfileKind.guest,
        createdAt: guestCreatedAt ?? DateTime.utc(2026, 11, 20),
      ) {
    _profiles[_guest.id] = _guest;
    _active = _guest;
  }

  final Profile _guest;
  final Map<ProfileId, Profile> _profiles = {};
  late Profile _active;

  /// All profiles currently stored, keyed by id.
  Map<ProfileId, Profile> get stored => Map.unmodifiable(_profiles);

  @override
  Future<Profile> active() async => _active;

  @override
  Future<void> activate(Profile profile) async {
    _profiles[profile.id] = profile;
    _active = profile;
  }

  @override
  Future<Profile> guest() async => _guest;
}
