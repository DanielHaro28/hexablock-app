import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hexa_application/hexa_application.dart';

import '../platform/system_clock.dart';

part 'app_database.g.dart';

/// Local player profiles (`guest` and signed-in accounts, ARQ-04 §2).
@DataClassName('ProfileRow')
class Profiles extends Table {
  /// `guest` or the account JWT subject.
  TextColumn get id => text()();

  /// `guest` or `account`.
  TextColumn get kind => text()();

  /// Public display name, `null` for the guest profile.
  TextColumn get displayName => text().nullable()();

  /// Whether this profile is currently active on the device.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  /// Creation timestamp in UTC milliseconds.
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Best attempt per completed level for level-based variants (ARQ-04 §2, D-49).
@DataClassName('LevelResultRow')
class LevelResults extends Table {
  /// Owner profile identifier.
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Variant identifier from the contract.
  TextColumn get gameId => text()();

  /// Topology identifier.
  TextColumn get topology => text()();

  /// Level identifier (`D-47`).
  TextColumn get levelId => text()();

  /// Earned stars (1 to 3), if applicable.
  IntColumn get stars => integer().nullable()();

  /// Active completion time in milliseconds, if applicable.
  IntColumn get timeMs => integer().nullable()();

  /// Moves taken to complete the level.
  IntColumn get moves => integer()();

  /// Score reached in the level, if applicable.
  IntColumn get score => integer().nullable()();

  /// Timestamp in UTC milliseconds when this attempt was achieved.
  IntColumn get achievedAt => integer()();

  /// Whether this result has pending changes to sync (D-49).
  BoolColumn get pending => boolean().withDefault(const Constant(true))();

  /// Monotonically incremented local revision counter (D-49).
  IntColumn get revision => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {profileId, gameId, topology, levelId};
}

/// High-score records for endless variants (ARQ-04 §2, D-49).
@DataClassName('RecordRow')
class Records extends Table {
  /// Owner profile identifier.
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Variant identifier from the contract.
  TextColumn get gameId => text()();

  /// Topology identifier.
  TextColumn get topology => text()();

  /// Best score achieved.
  IntColumn get score => integer()();

  /// Timestamp in UTC milliseconds when the record was achieved.
  IntColumn get achievedAt => integer()();

  /// Whether this record has pending changes to sync (D-49).
  BoolColumn get pending => boolean().withDefault(const Constant(true))();

  /// Monotonically incremented local revision counter (D-49).
  IntColumn get revision => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {profileId, gameId, topology};
}

/// In-progress or paused games persisted across app restarts (ARQ-04 §2, D-37).
@DataClassName('SavedGameRow')
class SavedGames extends Table {
  /// Owner profile identifier.
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Variant identifier from the contract.
  TextColumn get gameId => text()();

  /// Topology identifier.
  TextColumn get topology => text()();

  /// Serialized state, generator, undo history and active time (`D-37`).
  TextColumn get stateJson => text()();

  /// Codec version used to encode [stateJson].
  IntColumn get codecVersion => integer()();

  /// Timestamp in UTC milliseconds when the snapshot was written.
  IntColumn get savedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {profileId, gameId, topology};
}

/// Validated remote levels cached on the device (ARQ-04 §2, RN-COM-71, 76).
@DataClassName('DownloadedLevelRow')
class DownloadedLevels extends Table {
  /// Level identifier (`D-47`).
  TextColumn get id => text()();

  /// Variant identifier from the contract.
  TextColumn get gameId => text()();

  /// Topology identifier or `any`.
  TextColumn get topology => text()();

  /// Display order within the level list.
  IntColumn get order => integer()();

  /// Level definition version.
  IntColumn get version => integer()();

  /// Complete validated level JSON.
  TextColumn get json => text()();

  /// Timestamp in UTC milliseconds when the level was cached.
  IntColumn get downloadedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Incremental level download cursors per variant and topology (ARQ-04 §2, D-48).
@DataClassName('LevelSyncCursorRow')
class LevelSyncCursors extends Table {
  /// Variant identifier from the contract.
  TextColumn get gameId => text()();

  /// Topology identifier.
  TextColumn get topology => text()();

  /// `nextCursor` returned by the API.
  TextColumn get cursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {gameId, topology};
}

/// Local SQLite database backed by Drift (ARQ-04, ADR-001 §2.1).
@DriftDatabase(
  tables: [
    Profiles,
    LevelResults,
    Records,
    SavedGames,
    DownloadedLevels,
    LevelSyncCursors,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates the database over a custom [QueryExecutor] (such as an in-memory
  /// database in tests, D-57).
  AppDatabase(super.e, {IClock? clock}) : _clock = clock ?? SystemClock();

  /// Opens the default persistent SQLite database on the device.
  AppDatabase.open({IClock? clock})
    : _clock = clock ?? SystemClock(),
      super(driftDatabase(name: 'hexablock'));

  final IClock _clock;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(profiles).insert(
        ProfilesCompanion.insert(
          id: ProfileId.guest.value,
          kind: ProfileKind.guest.name,
          isActive: const Value(true),
          createdAt: _clock.now().toUtc().millisecondsSinceEpoch,
        ),
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
