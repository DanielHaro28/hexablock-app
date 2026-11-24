import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/adapters/presentation/game/game_cubit.dart';
import 'package:hexablock_app/adapters/presentation/game/game_screen_state.dart';

typedef _Cubit = GameCubit<FakeCoord, FakeCell, FakeMove, FakeState>;
typedef _Screen = GameScreenState<FakeCoord, FakeState>;

/// A start use case that always fails with [failure].
final class _FailingStart
    implements
        UseCase<
          StartOptions,
          Result<GameSession<FakeCoord, FakeCell, FakeMove, FakeState>>
        > {
  const _FailingStart(this.failure);

  final AppFailure failure;

  @override
  Future<Result<GameSession<FakeCoord, FakeCell, FakeMove, FakeState>>> execute(
    StartOptions input,
  ) async => Failure(failure);
}

void main() {
  const a = FakeCoord(0, 0);
  const key = SavedGameKey(ProfileId.guest, GameKey('fake-game', 'fake-shape'));

  /// The empty board of a new [FakeVariantFamily] game.
  final emptyBoard = Board<FakeCoord, FakeCell>.of(
    const FakeTopology(),
    ShapeSpec('rectangle', const [3, 1]),
  );

  /// A presenter wired as the composition root does, over the fakes.
  _Cubit cubitOf({ISavedGameRepository<FakeState>? savedGames}) {
    final saved = savedGames ?? FakeSavedGameRepository<FakeState>();
    return GameCubit(
      startGame: ErrorHandlingAspect(
        StartGameUseCase(FakeVariantFamily(), saved, key),
      ),
      options: StartNew(NewGameOptions(seed: 1)),
      applyMoveFor: (session) =>
          ErrorHandlingAspect(ApplyMoveUseCase(session, saved, key)),
    );
  }

  group('ARQ-A-08', () {
    test('should_be_loading_when_created', () {
      // Arrange
      final cubit = cubitOf();
      addTearDown(cubit.close);

      // Act
      final state = cubit.state;

      // Assert
      expect(state, const GameLoading<FakeCoord, FakeState>());
    });

    blocTest<_Cubit, _Screen>(
      'should_show_the_new_game_when_it_starts',
      build: cubitOf,
      act: (cubit) => cubit.start(),
      expect: () => [
        GameReady<FakeCoord, FakeState>(
          FakeState(emptyBoard),
          const PlayingPhase(),
        ),
      ],
    );

    blocTest<_Cubit, _Screen>(
      'should_show_the_failure_when_the_game_does_not_start',
      build: () => GameCubit(
        startGame: const _FailingStart(PersistenceFailure()),
        options: StartNew(NewGameOptions(seed: 1)),
        applyMoveFor: (session) => throw StateError('never called'),
      ),
      act: (cubit) => cubit.start(),
      expect: () => [
        const GameNotStarted<FakeCoord, FakeState>(PersistenceFailure()),
      ],
    );

    blocTest<_Cubit, _Screen>(
      'should_ignore_a_move_when_the_game_has_not_started',
      build: cubitOf,
      act: (cubit) => cubit.submit(const FakeMove(a)),
      expect: () => <_Screen>[],
    );
  });

  group('RN-COM-20', () {
    blocTest<_Cubit, _Screen>(
      'should_show_the_new_state_and_its_events_when_the_move_is_played',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
      },
      skip: 1,
      verify: (cubit) {
        final state = cubit.state as GameReady<FakeCoord, FakeState>;
        expect(state.state.board.cell(a), const FakeCell('x'));
        expect(state.phase, const PlayingPhase());
        expect(state.events, contains(const FakeEvent('apply')));
        expect(state.rejection, isNull);
      },
    );
  });

  group('RN-COM-21', () {
    blocTest<_Cubit, _Screen>(
      'should_keep_the_state_and_show_the_reason_when_the_move_is_rejected',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
        await cubit.submit(const FakeMove(a));
      },
      skip: 2,
      verify: (cubit) {
        final state = cubit.state as GameReady<FakeCoord, FakeState>;
        expect(state.rejection, const CellOccupied(a));
        expect(state.state.board.cell(a), const FakeCell('x'));
      },
    );
  });

  group('RNF-35', () {
    blocTest<_Cubit, _Screen>(
      'should_keep_the_game_and_show_the_failure_when_the_move_use_case_fails',
      build: () => GameCubit(
        startGame: ErrorHandlingAspect(
          StartGameUseCase(
            FakeVariantFamily(),
            FakeSavedGameRepository<FakeState>(),
            key,
          ),
        ),
        options: StartNew(NewGameOptions(seed: 1)),
        applyMoveFor: (session) =>
            ErrorHandlingAspect(_ThrowingMove(const PersistenceException())),
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
      },
      skip: 1,
      expect: () => [
        GameReady<FakeCoord, FakeState>(
          FakeState(emptyBoard),
          const PlayingPhase(),
          failure: const PersistenceFailure(),
        ),
      ],
    );
  });
}

/// A move use case that always throws [error].
final class _ThrowingMove
    implements UseCase<FakeMove, MoveResult<FakeCoord, FakeState>> {
  _ThrowingMove(this.error);

  final Object error;

  @override
  Future<MoveResult<FakeCoord, FakeState>> execute(FakeMove input) async =>
      throw error;
}
