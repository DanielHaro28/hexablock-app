import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/adapters/presentation/game/game_cubit.dart';
import 'package:hexablock_app/adapters/presentation/game/game_screen_state.dart';

typedef _Cubit = GameCubit<FakeCoord, FakeCell, FakeMove, FakeState>;
typedef _Screen = GameScreenState<FakeCoord, FakeMove, FakeState>;
typedef _Ready = GameReady<FakeCoord, FakeMove, FakeState>;

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
      checkMoveFor: (session) => ErrorHandlingAspect(CheckMoveUseCase(session)),
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
      expect(state, const GameLoading<FakeCoord, FakeMove, FakeState>());
    });

    blocTest<_Cubit, _Screen>(
      'should_show_the_new_game_when_it_starts',
      build: cubitOf,
      act: (cubit) => cubit.start(),
      expect: () => [_Ready(FakeState(emptyBoard), const PlayingPhase())],
    );

    blocTest<_Cubit, _Screen>(
      'should_show_the_failure_when_the_game_does_not_start',
      build: () => GameCubit(
        startGame: const _FailingStart(PersistenceFailure()),
        options: StartNew(NewGameOptions(seed: 1)),
        applyMoveFor: (session) => throw StateError('never called'),
        checkMoveFor: (session) => throw StateError('never called'),
      ),
      act: (cubit) => cubit.start(),
      expect: () => [
        const GameNotStarted<FakeCoord, FakeMove, FakeState>(
          PersistenceFailure(),
        ),
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
        final state = cubit.state as _Ready;
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
        final state = cubit.state as _Ready;
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
        checkMoveFor: (session) =>
            ErrorHandlingAspect(CheckMoveUseCase(session)),
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
      },
      skip: 1,
      expect: () => [
        _Ready(
          FakeState(emptyBoard),
          const PlayingPhase(),
          failure: const PersistenceFailure(),
        ),
      ],
    );
  });

  group('D-138', () {
    blocTest<_Cubit, _Screen>(
      'should_show_a_valid_preview_when_the_move_would_be_played',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.preview(const FakeMove(a));
      },
      skip: 1,
      expect: () => [
        _Ready(
          FakeState(emptyBoard),
          const PlayingPhase(),
          preview: const MovePreview(FakeMove(a)),
        ),
      ],
      verify: (cubit) {
        final preview = (cubit.state as _Ready).preview!;
        expect(preview.isValid, isTrue);
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_show_the_reason_in_the_preview_when_the_move_would_be_rejected',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
        await cubit.preview(const FakeMove(a));
      },
      skip: 2,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(
          state.preview,
          const MovePreview(FakeMove(a), rejection: CellOccupied(a)),
        );
        expect(state.preview!.isValid, isFalse);
        expect(state.events, isEmpty);
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_remove_the_preview_when_it_is_cleared',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.preview(const FakeMove(a));
        cubit.clearPreview();
      },
      skip: 2,
      expect: () => [_Ready(FakeState(emptyBoard), const PlayingPhase())],
    );

    blocTest<_Cubit, _Screen>(
      'should_remove_the_preview_when_the_move_is_played',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        await cubit.preview(const FakeMove(a));
        await cubit.submit(const FakeMove(a));
      },
      skip: 2,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(state.preview, isNull);
        expect(state.state.board.cell(a), const FakeCell('x'));
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_drop_the_answer_of_a_preview_when_it_was_cleared_first',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        final pending = cubit.preview(const FakeMove(a));
        cubit.clearPreview();
        await pending;
      },
      skip: 1,
      expect: () => <_Screen>[],
    );

    blocTest<_Cubit, _Screen>(
      'should_keep_the_game_and_show_the_failure_when_the_check_fails',
      build: () => GameCubit(
        startGame: ErrorHandlingAspect(
          StartGameUseCase(
            FakeVariantFamily(),
            FakeSavedGameRepository<FakeState>(),
            key,
          ),
        ),
        options: StartNew(NewGameOptions(seed: 1)),
        applyMoveFor: (session) => ErrorHandlingAspect(
          ApplyMoveUseCase(session, FakeSavedGameRepository<FakeState>(), key),
        ),
        checkMoveFor: (session) =>
            ErrorHandlingAspect(_ThrowingCheck(StateError('broken'))),
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.preview(const FakeMove(a));
      },
      skip: 1,
      expect: () => [
        _Ready(
          FakeState(emptyBoard),
          const PlayingPhase(),
          failure: const UnexpectedFailure(),
        ),
      ],
    );

    blocTest<_Cubit, _Screen>(
      'should_ignore_a_preview_when_the_game_has_not_started',
      build: cubitOf,
      act: (cubit) => cubit.preview(const FakeMove(a)),
      expect: () => <_Screen>[],
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

/// A check use case that always throws [error].
final class _ThrowingCheck implements UseCase<FakeMove, RejectionReason?> {
  _ThrowingCheck(this.error);

  final Object error;

  @override
  Future<RejectionReason?> execute(FakeMove input) async => throw error;
}
