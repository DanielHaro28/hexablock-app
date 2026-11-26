import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/frameworks/persistence/app_database.dart';
import 'package:hexablock_app/frameworks/persistence/drift_profile_repository.dart';
import 'package:hexablock_app/frameworks/persistence/drift_progress_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProfileRepository repository;
  late FakeClock clock;

  setUp(() {
    clock = FakeClock(startDate: DateTime.utc(2026, 11, 25, 10));
    db = AppDatabase(NativeDatabase.memory(), clock: clock);
    repository = DriftProfileRepository(db);
  });

  tearDown(() async => db.close());

  group('RN-COM-81', () {
    test('should_seed_guest_as_active_when_database_is_created', () async {
      // Arrange & Act
      final active = await repository.active();
      final guest = await repository.guest();

      // Assert
      expect(active.id, ProfileId.guest);
      expect(active.kind, ProfileKind.guest);
      expect(active.isGuest, isTrue);
      expect(active.displayName, isNull);
      expect(active.createdAt, clock.now());
      expect(guest, active);
    });
  });

  group('RN-COM-88 / RN-COM-89', () {
    test(
      'should_switch_active_profile_and_keep_guest_when_account_is_activated',
      () async {
        // Arrange
        final account = Profile(
          id: const ProfileId('user-1'),
          kind: ProfileKind.account,
          displayName: 'Ana',
          createdAt: DateTime.utc(2026, 11, 25, 11),
        );

        // Act
        await repository.activate(account);
        final active = await repository.active();
        final guest = await repository.guest();

        // Assert
        expect(active, account);
        expect(guest.id, ProfileId.guest);
      },
    );

    test('should_keep_stored_account_when_switching_back_to_guest', () async {
      // Arrange
      final account = Profile(
        id: const ProfileId('user-1'),
        kind: ProfileKind.account,
        displayName: 'Ana',
        createdAt: DateTime.utc(2026, 11, 25, 11),
      );
      await repository.activate(account);
      final guest = await repository.guest();

      // Act
      await repository.activate(guest);
      final activeNow = await repository.active();
      final rows = await db.select(db.profiles).get();

      // Assert
      expect(activeNow, guest);
      expect(rows, hasLength(2));
      expect(
        rows.where((row) => row.id == account.id.value).single.isActive,
        isFalse,
      );
    });

    test(
      'should_update_display_name_when_activating_existing_account',
      () async {
        // Arrange
        final original = Profile(
          id: const ProfileId('user-1'),
          kind: ProfileKind.account,
          displayName: 'Ana',
          createdAt: DateTime.utc(2026, 11, 25, 11),
        );
        final renamed = Profile(
          id: const ProfileId('user-1'),
          kind: ProfileKind.account,
          displayName: 'Ana Maria',
          createdAt: DateTime.utc(2026, 11, 25, 11),
        );
        await repository.activate(original);

        // Act
        await repository.activate(renamed);

        // Assert
        expect(await repository.active(), renamed);
        expect(await db.select(db.profiles).get(), hasLength(2));
      },
    );
  });

  group('RNF-35', () {
    test(
      'should_preserve_profile_progress_when_reactivating_existing_profile',
      () async {
        // Arrange
        final account = Profile(
          id: const ProfileId('user-1'),
          kind: ProfileKind.account,
          displayName: 'Ana',
          createdAt: DateTime.utc(2026, 11, 25, 11),
        );
        const linesGame = GameKey('hexa-lines', 'hex');
        const fitGame = GameKey('hexa-fit', 'hex');
        final progress = DriftProgressRepository(db);
        final record = HighScoreProgress(420, clock.now());
        final levels = LevelsProgress({
          'fit-hex-001': LevelAttempt(
            moves: 3,
            stars: 3,
            timeMs: 12000,
            achievedAt: clock.now(),
          ),
        });
        await repository.activate(account);
        await progress.save(account.id, linesGame, record);
        await progress.save(account.id, fitGame, levels);
        await repository.activate(await repository.guest());

        // Act: reactivating the account must upsert without triggering CASCADE.
        await repository.activate(account);

        // Assert
        expect(await progress.load(account.id, linesGame), record);
        expect(await progress.load(account.id, fitGame), levels);
      },
    );
  });

  group('D-39', () {
    test('should_throw_persistence_exception_when_database_fails', () async {
      // Arrange
      await db.customStatement('DROP TABLE level_results');
      await db.customStatement('DROP TABLE records');
      await db.customStatement('DROP TABLE saved_games');
      await db.customStatement('DROP TABLE profiles');

      // Act & Assert
      await expectLater(
        repository.active(),
        throwsA(isA<PersistenceException>()),
      );
    });
  });
}
