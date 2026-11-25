import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/adapters/presentation/home/home_cubit.dart';
import 'package:hexablock_app/adapters/presentation/home/home_state.dart';

/// A progress reader that always fails, as a broken local database would.
final class _FailingProgress
    implements UseCase<GameKey, Result<VariantProgress?>> {
  const _FailingProgress();

  @override
  Future<Result<VariantProgress?>> execute(GameKey input) async =>
      const Failure(UnexpectedFailure());
}

void main() {
  const shape = 'fake-shape';
  const endless = 'fake-endless';
  const byLevels = 'fake-levels';
  final reachedAt = DateTime.utc(2026, 11, 24);

  HomeCubit cubitOver(FakeProgressRepository repository) => HomeCubit(
    gameIds: const [endless, byLevels],
    topologyId: shape,
    getProgress: ErrorHandlingAspect(
      GetProgressUseCase(repository, ProfileId.guest),
    ),
  );

  group('NAV-01', () {
    test('should_start_loading_when_created', () {
      // Arrange
      final cubit = cubitOver(FakeProgressRepository());
      addTearDown(cubit.close);

      // Act
      final state = cubit.state;

      // Assert
      expect(state, const HomeLoading());
    });

    blocTest<HomeCubit, HomeState>(
      'should_say_new_for_every_game_when_nothing_was_played',
      build: () => cubitOver(FakeProgressRepository()),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeReady({endless: HomeNewGame(), byLevels: HomeNewGame()}),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should_show_the_record_when_a_game_keeps_one',
      build: () => cubitOver(
        FakeProgressRepository({
          (ProfileId.guest, const GameKey(endless, shape)): HighScoreProgress(
            12850,
            reachedAt,
          ),
        }),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeReady({endless: HomeRecord(12850), byLevels: HomeNewGame()}),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should_ignore_the_record_of_another_cell_shape_when_reading_progress',
      build: () => cubitOver(
        FakeProgressRepository({
          (ProfileId.guest, const GameKey(endless, 'other-shape')):
              HighScoreProgress(500, reachedAt),
        }),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeReady({endless: HomeNewGame(), byLevels: HomeNewGame()}),
      ],
    );
  });

  group('RNF-35', () {
    blocTest<HomeCubit, HomeState>(
      'should_leave_the_footer_empty_when_the_progress_cannot_be_read',
      build: () => HomeCubit(
        gameIds: const [endless],
        topologyId: shape,
        getProgress: const _FailingProgress(),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeReady({endless: HomeUnknownStatus()}),
      ],
    );
  });

  group('RN-HL-70', () {
    late FakeProgressRepository repository;

    blocTest<HomeCubit, HomeState>(
      'should_show_the_new_record_when_loaded_again_after_a_game',
      setUp: () => repository = FakeProgressRepository(),
      build: () => cubitOver(repository),
      act: (cubit) async {
        await cubit.load();
        await repository.save(
          ProfileId.guest,
          const GameKey(endless, shape),
          HighScoreProgress(320, reachedAt),
        );
        await cubit.load();
      },
      expect: () => [
        const HomeReady({endless: HomeNewGame(), byLevels: HomeNewGame()}),
        const HomeReady({endless: HomeRecord(320), byLevels: HomeNewGame()}),
      ],
    );
  });
}
