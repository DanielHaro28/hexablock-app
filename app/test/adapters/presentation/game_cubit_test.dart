import 'dart:async';

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
  const b = FakeCoord(1, 0);
  const key = SavedGameKey(ProfileId.guest, GameKey('fake-game', 'fake-shape'));
  final clock = FakeClock();
  final earlier = DateTime.utc(2026, 11, 20);

  /// The empty board of a new [FakeVariantFamily] game.
  final emptyBoard = Board<FakeCoord, FakeCell>.of(
    const FakeTopology(),
    ShapeSpec('rectangle', const [3, 1]),
  );

  /// The empty board of a one-cell game, which the first move ends.
  final oneCell = Board<FakeCoord, FakeCell>.of(
    const FakeTopology(),
    ShapeSpec('rectangle', const [1, 1]),
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

  /// A presenter whose game keeps a record in [progress] (D-142): a board of
  /// [width] cells where each turn adds [points], so with one cell the first
  /// move ends the game with [points].
  _Cubit recordCubitOf(
    FakeProgressRepository progress, {
    int width = 1,
    int points = 40,
    FakeRules Function()? rules,
    UseCase<GameKey, VariantProgress?>? getProgress,
    UseCase<GameResult, VariantProgress>? saveProgress,
  }) {
    final saved = FakeSavedGameRepository<FakeState>();
    final family = FakeVariantFamily(
      width: width,
      rules: rules ?? () => FakeRules(pointsPerTurn: points),
    );
    return GameCubit(
      startGame: ErrorHandlingAspect(StartGameUseCase(family, saved, key)),
      options: StartNew(NewGameOptions(seed: 1)),
      applyMoveFor: (session) =>
          ErrorHandlingAspect(ApplyMoveUseCase(session, saved, key)),
      checkMoveFor: (session) => ErrorHandlingAspect(CheckMoveUseCase(session)),
      record: RecordUseCases(
        game: key.game,
        getProgress: ErrorHandlingAspect(
          getProgress ?? GetProgressUseCase(progress, FakeProfileRepository()),
        ),
        saveProgress: ErrorHandlingAspect(
          saveProgress ??
              SaveProgressUseCase(
                progress,
                FakeProfileRepository(),
                clock,
                FakeUnitOfWork(),
              ),
        ),
      ),
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

  group('RN-COM-31', () {
    blocTest<_Cubit, _Screen>(
      'should_show_the_game_over_phase_when_the_move_ends_the_game',
      build: cubitOf,
      act: (cubit) async {
        // The board has three cells: filling the last one leaves no move.
        await cubit.start();
        await cubit.submit(const FakeMove(a));
        await cubit.submit(const FakeMove(b));
        await cubit.submit(const FakeMove(FakeCoord(2, 0)));
      },
      skip: 3,
      verify: (cubit) => expect(
        cubit.state,
        isA<_Ready>()
            .having((ready) => ready.phase, 'phase', const GameOverPhase())
            .having(
              (ready) => ready.state.board.emptyCells,
              'empty cells',
              isEmpty,
            ),
      ),
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
      'should_show_only_the_last_preview_when_one_overtakes_another',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        final first = cubit.preview(const FakeMove(a));
        await cubit.preview(const FakeMove(b));
        await first;
      },
      skip: 1,
      expect: () => [
        _Ready(
          FakeState(emptyBoard),
          const PlayingPhase(),
          preview: const MovePreview(FakeMove(b)),
        ),
      ],
    );

    blocTest<_Cubit, _Screen>(
      'should_drop_the_answer_of_a_preview_when_a_move_overtakes_it',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        final pending = cubit.preview(const FakeMove(b));
        await cubit.submit(const FakeMove(a));
        await pending;
      },
      skip: 1,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(state.preview, isNull);
        expect(state.state.board.cell(a), const FakeCell('x'));
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_check_against_the_new_board_when_previewing_right_after_a_move',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        final played = cubit.submit(const FakeMove(a));
        await cubit.preview(const FakeMove(a));
        await played;
      },
      skip: 2,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(state.state.board.cell(a), const FakeCell('x'));
        expect(
          state.preview,
          const MovePreview(FakeMove(a), rejection: CellOccupied(a)),
        );
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_emit_nothing_when_clearing_and_there_is_no_preview',
      build: cubitOf,
      act: (cubit) async {
        await cubit.start();
        cubit.clearPreview();
      },
      skip: 1,
      expect: () => <_Screen>[],
    );

    blocTest<_Cubit, _Screen>(
      'should_ignore_a_preview_when_the_game_has_not_started',
      build: cubitOf,
      act: (cubit) => cubit.preview(const FakeMove(a)),
      expect: () => <_Screen>[],
    );
  });
  group('RN-HL-70', () {
    blocTest<_Cubit, _Screen>(
      'should_show_the_saved_record_when_the_game_starts',
      build: () => recordCubitOf(
        FakeProgressRepository({
          (ProfileId.guest, key.game): HighScoreProgress(1240, earlier),
        }),
      ),
      act: (cubit) => cubit.start(),
      verify: (cubit) => expect((cubit.state as _Ready).record, 1240),
    );

    blocTest<_Cubit, _Screen>(
      'should_show_no_record_when_the_game_was_never_finished',
      build: () => recordCubitOf(FakeProgressRepository()),
      act: (cubit) => cubit.start(),
      verify: (cubit) => expect((cubit.state as _Ready).record, isNull),
    );

    blocTest<_Cubit, _Screen>(
      'should_keep_the_saved_record_when_the_score_goes_past_it',
      build: () => recordCubitOf(
        FakeProgressRepository({
          (ProfileId.guest, key.game): HighScoreProgress(10, earlier),
        }),
        width: 3,
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
      },
      skip: 1,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(state.state.score, 40);
        expect(state.phase, const PlayingPhase());
        expect(state.record, 10);
      },
    );

    blocTest<_Cubit, _Screen>(
      'should_keep_the_record_when_the_player_drags_a_move',
      build: () => recordCubitOf(
        FakeProgressRepository({
          (ProfileId.guest, key.game): HighScoreProgress(10, earlier),
        }),
        width: 3,
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.preview(const FakeMove(a));
        cubit.clearPreview();
      },
      skip: 1,
      verify: (cubit) => expect((cubit.state as _Ready).record, 10),
    );
  });

  group('RN-HL-71', () {
    test(
      'should_show_and_save_the_new_record_when_the_game_ends_above_it',
      () async {
        // Arrange
        final progress = FakeProgressRepository({
          (ProfileId.guest, key.game): HighScoreProgress(10, earlier),
        });
        final cubit = recordCubitOf(progress);
        addTearDown(cubit.close);
        await cubit.start();

        // Act
        await cubit.submit(const FakeMove(a));

        // Assert
        final state = cubit.state as _Ready;
        expect(state.phase, const GameOverPhase());
        expect(state.record, 40);
        expect(
          progress.savedAt(ProfileId.guest, key.game),
          HighScoreProgress(40, clock.now()),
        );
      },
    );

    test('should_keep_the_record_when_the_game_ends_below_it', () async {
      // Arrange
      final progress = FakeProgressRepository({
        (ProfileId.guest, key.game): HighScoreProgress(100, earlier),
      });
      final cubit = recordCubitOf(progress);
      addTearDown(cubit.close);
      await cubit.start();

      // Act
      await cubit.submit(const FakeMove(a));

      // Assert
      expect((cubit.state as _Ready).record, 100);
      expect(progress.saves, 0);
    });

    test('should_save_nothing_when_the_turn_does_not_end_the_game', () async {
      // Arrange
      final progress = FakeProgressRepository();
      final cubit = recordCubitOf(progress, width: 3);
      addTearDown(cubit.close);
      await cubit.start();

      // Act
      await cubit.submit(const FakeMove(a));

      // Assert
      expect(progress.saves, 0);
    });

    test('should_save_the_record_when_a_victory_ends_the_game', () async {
      // Arrange
      final progress = FakeProgressRepository();
      final cubit = recordCubitOf(
        progress,
        width: 3,
        rules: () => FakeRules(pointsPerTurn: 40, victoryWhen: (_) => true),
      );
      addTearDown(cubit.close);
      await cubit.start();

      // Act
      await cubit.submit(const FakeMove(a));

      // Assert
      expect((cubit.state as _Ready).record, 40);
    });

    test(
      'should_save_nothing_when_the_player_may_keep_playing_after_winning',
      () async {
        // Arrange: the record is kept when the game ends for good (D-112)
        final progress = FakeProgressRepository();
        final cubit = recordCubitOf(
          progress,
          width: 3,
          rules: () => FakeRules(
            pointsPerTurn: 40,
            victoryWhen: (_) => true,
            canContinue: true,
          ),
        );
        addTearDown(cubit.close);
        await cubit.start();

        // Act
        await cubit.submit(const FakeMove(a));

        // Assert
        expect(progress.saves, 0);
      },
    );
  });

  group('RNF-35', () {
    blocTest<_Cubit, _Screen>(
      'should_start_the_game_and_show_the_failure_when_the_record_is_unreadable',
      build: () => recordCubitOf(
        FakeProgressRepository(),
        getProgress: _Throwing(const PersistenceException()),
      ),
      act: (cubit) => cubit.start(),
      expect: () => [
        _Ready(
          FakeState(oneCell),
          const PlayingPhase(),
          failure: const PersistenceFailure(),
        ),
      ],
    );

    blocTest<_Cubit, _Screen>(
      'should_end_the_game_and_show_the_failure_when_the_record_is_unsaved',
      build: () => recordCubitOf(
        FakeProgressRepository({
          (ProfileId.guest, key.game): HighScoreProgress(10, earlier),
        }),
        saveProgress: _Throwing(const PersistenceException()),
      ),
      act: (cubit) async {
        await cubit.start();
        await cubit.submit(const FakeMove(a));
      },
      skip: 1,
      verify: (cubit) {
        final state = cubit.state as _Ready;
        expect(state.phase, const GameOverPhase());
        expect(state.failure, const PersistenceFailure());
        expect(state.record, 10);
      },
    );
  });
  group('D-138', () {
    test('should_show_the_last_turn_before_the_record_is_saved', () async {
      // Arrange
      final save = _PendingSave();
      final cubit = recordCubitOf(FakeProgressRepository(), saveProgress: save);
      addTearDown(cubit.close);
      await cubit.start();

      // Act
      final submitted = cubit.submit(const FakeMove(a));
      await pumpEventQueue();

      // Assert
      final state = cubit.state as _Ready;
      expect(state.phase, const GameOverPhase());
      expect(state.record, isNull);
      save.finish(HighScoreProgress(40, clock.now()));
      await submitted;
    });

    test('should_keep_the_preview_when_the_record_is_shown_after_it', () async {
      // Arrange
      final save = _PendingSave();
      final cubit = recordCubitOf(
        FakeProgressRepository(),
        width: 2,
        rules: () => FakeRules(pointsPerTurn: 40, victoryWhen: (_) => true),
        saveProgress: save,
      );
      addTearDown(cubit.close);
      await cubit.start();
      final submitted = cubit.submit(const FakeMove(a));
      await pumpEventQueue();
      await cubit.preview(const FakeMove(b));

      // Act
      save.finish(HighScoreProgress(40, clock.now()));
      await submitted;

      // Assert
      final state = cubit.state as _Ready;
      expect(state.record, 40);
      expect(state.preview?.move, const FakeMove(b));
    });
  });
}

/// A save that waits until the test calls [finish].
final class _PendingSave implements UseCase<GameResult, VariantProgress> {
  final _done = Completer<VariantProgress>();

  /// Ends the save with [kept].
  void finish(VariantProgress kept) => _done.complete(kept);

  @override
  Future<VariantProgress> execute(GameResult input) => _done.future;
}

/// A use case that always throws [error].
final class _Throwing<TIn, TOut> implements UseCase<TIn, TOut> {
  _Throwing(this.error);

  final Object error;

  @override
  Future<TOut> execute(TIn input) async => throw error;
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
