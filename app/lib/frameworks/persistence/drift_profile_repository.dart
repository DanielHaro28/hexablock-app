import 'package:drift/drift.dart';
import 'package:hexa_application/hexa_application.dart';

import 'app_database.dart';
import 'drift_error.dart';

/// Persists local player profiles in SQLite via Drift (ARQ-04 §2, RN-COM-81).
final class DriftProfileRepository implements IProfileRepository {
  /// Creates a profile repository backed by [_db].
  const DriftProfileRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Profile> active() => runDrift(() async {
    final rows = await (_db.select(
      _db.profiles,
    )..where((row) => row.isActive.equals(true))).get();
    return switch (rows) {
      // The port promises the guest when no profile is active.
      [] => await guest(),
      [final row] => _toDomain(row),
      // Only one profile is ever active (ARQ-04 §2): more is corrupt data.
      _ => throw const PersistenceException(),
    };
  });

  @override
  Future<void> activate(Profile profile) => runDrift(
    () => _db.transaction(() async {
      await _db
          .update(_db.profiles)
          .write(const ProfilesCompanion(isActive: Value(false)));
      // Upsert in place so existing progress rows referencing this profile are
      // never dropped by ON DELETE CASCADE (RNF-35). An existing profile keeps
      // its kind and the date it was created on this device; only its name
      // and the active flag change.
      await _db
          .into(_db.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: profile.id.value,
              kind: profile.kind.name,
              displayName: Value(profile.displayName),
              isActive: const Value(true),
              createdAt: profile.createdAt.toUtc().millisecondsSinceEpoch,
            ),
            onConflict: DoUpdate(
              (_) => ProfilesCompanion(
                displayName: Value(profile.displayName),
                isActive: const Value(true),
              ),
            ),
          );
    }),
  );

  @override
  Future<Profile> guest() => runDrift(() async {
    final row = await (_db.select(
      _db.profiles,
    )..where((row) => row.id.equals(ProfileId.guest.value))).getSingleOrNull();
    if (row == null) throw const PersistenceException();
    return _toDomain(row);
  });

  static Profile _toDomain(ProfileRow row) => Profile(
    id: ProfileId(row.id),
    // A kind this version does not know is corrupt data, not a crash (D-39).
    kind:
        ProfileKind.values.asNameMap()[row.kind] ??
        (throw const PersistenceException()),
    displayName: row.displayName,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
  );
}
