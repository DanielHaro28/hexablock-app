import '../profile.dart';

/// Where the local player profiles are kept on the device (ARQ-03 §4,
/// RN-COM-81, 88, 89).
abstract interface class IProfileRepository {
  /// The currently active profile on the device (never `null`; defaults to
  /// the guest profile).
  Future<Profile> active();

  /// Stores or updates [profile] and sets it as the active profile.
  Future<void> activate(Profile profile);

  /// The local guest profile, which always exists (D-05).
  Future<Profile> guest();
}
