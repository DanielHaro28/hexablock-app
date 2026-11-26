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
    final row = await (_db.select(
      _db.profiles,
    )..where((row) => row.isActive.equals(true))).getSingleOrNull();
    if (row == null) throw const PersistenceException();
    return _toDomain(row);
  });

  @override
  Future<void> activate(Profile profile) => runDrift(
    () => _db.transaction(() async {
      await _db
          .update(_db.profiles)
          .write(const ProfilesCompanion(isActive: Value(false)));
      // Upsert in place so existing progress rows referencing this profile are
      // never dropped by ON DELETE CASCADE (RNF-35).
      await _db
          .into(_db.profiles)
          .insertOnConflictUpdate(
            ProfilesCompanion.insert(
              id: profile.id.value,
              kind: profile.kind.name,
              displayName: Value(profile.displayName),
              isActive: const Value(true),
              createdAt: profile.createdAt.toUtc().millisecondsSinceEpoch,
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
    kind: ProfileKind.values.byName(row.kind),
    displayName: row.displayName,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
  );
}
