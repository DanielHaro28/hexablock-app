import 'game_keys.dart';

/// Whether a local profile belongs to the anonymous guest or a registered
/// account (ARQ-04 §2, RN-COM-81).
enum ProfileKind { guest, account }

/// A local player profile on the device (ARQ-04 §2, RN-COM-80, 81).
final class Profile {
  /// A profile identified by [id] of [kind], created at [createdAt].
  const Profile({
    required this.id,
    required this.kind,
    required this.createdAt,
    this.displayName,
  });

  /// The profile identifier: `guest` or the account subject.
  final ProfileId id;

  /// Whether this is the guest profile or an account.
  final ProfileKind kind;

  /// The public display name, or `null` for the guest profile.
  final String? displayName;

  /// When this profile was created locally, in UTC.
  final DateTime createdAt;

  /// Whether this profile is the local guest.
  bool get isGuest => kind == ProfileKind.guest;

  @override
  bool operator ==(Object other) =>
      other is Profile &&
      other.id == id &&
      other.kind == kind &&
      other.displayName == displayName &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, kind, displayName, createdAt);

  @override
  String toString() =>
      'Profile($id, $kind, displayName: $displayName, createdAt: $createdAt)';
}
