import 'package:hexa_application/hexa_application.dart';

/// Keeps the profiles in memory until PR 2/2 of PRG-03 brings the Drift one.
final class MemoryProfileRepository implements IProfileRepository {
  /// A repository whose guest profile was created at [createdAt].
  MemoryProfileRepository(DateTime createdAt)
    : _guest = Profile(
        id: ProfileId.guest,
        kind: ProfileKind.guest,
        createdAt: createdAt,
      ) {
    _profiles[_guest.id] = _guest;
    _active = _guest;
  }

  final Profile _guest;
  final Map<ProfileId, Profile> _profiles = {};
  late Profile _active;

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
