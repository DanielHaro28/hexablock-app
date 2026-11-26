import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'game_screen_state.dart';

/// Builds the move use case of a session, already wrapped by its aspects.
typedef ApplyMoveFor<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> = ICommandService<TMove, MoveResult<C, TState>> Function(
  GameSession<C, TCell, TMove, TState> session,
);

/// Builds the check use case of a session (D-138), already wrapped by its
/// aspects.
typedef CheckMoveFor<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> = ICommandService<TMove, RejectionReason?> Function(
  GameSession<C, TCell, TMove, TState> session,
);

/// The use cases of the record of a [game] (RN-HL-70, 71), for a variant
/// that keeps one (D-142).
final class RecordUseCases {
  /// Reads the record of [game] with [getProgress] and keeps a new one with
  /// [saveProgress].
  const RecordUseCases({
    required this.game,
    required this.getProgress,
    required this.saveProgress,
  });

  /// Which variant and cell shape the record belongs to.
  final GameKey game;

  /// Reads the saved record.
  final ICommandService<GameKey, VariantProgress?> getProgress;

  /// Keeps the score of a finished game if it beats the record.
  final ICommandService<GameResult, VariantProgress> saveProgress;
}

/// The presenter of the game screen: one for the four variants
/// (ARQ-A-08, ARQ-03 §4).
///
/// It starts the game with [StartGameUseCase] and plays each move with the
/// [ApplyMoveUseCase] of that session, built by `applyMoveFor` once the
/// session exists. While the player drags a move, [preview] asks the
/// [CheckMoveUseCase] built by `checkMoveFor` whether it would be played
/// (D-138). A variant that keeps a record gives its [RecordUseCases]: the
/// record is read when the game starts and kept when it ends (RN-HL-70, 71).
/// It shows what the use cases return and holds no rules.
final class GameCubit<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    extends Cubit<GameScreenState<C, TMove, TState>> {
  /// A presenter that starts the game with `options`.
  GameCubit({
    required this._startGame,
    required this._options,
    required this._applyMoveFor,
    required this._checkMoveFor,
    RecordUseCases? record,
  }) : _recordUseCases = record,
       super(GameLoading<C, TMove, TState>());

  final ICommandService<StartOptions, GameSession<C, TCell, TMove, TState>>
  _startGame;
  final StartOptions _options;
  final ApplyMoveFor<C, TCell, TMove, TState> _applyMoveFor;
  final CheckMoveFor<C, TCell, TMove, TState> _checkMoveFor;
  final RecordUseCases? _recordUseCases;

  GameSession<C, TCell, TMove, TState>? _session;
  ICommandService<TMove, MoveResult<C, TState>>? _applyMove;
  ICommandService<TMove, RejectionReason?>? _checkMove;

  /// The saved record, as the screen shows it (RN-HL-70).
  int? _record;

  /// Grows with every preview, clear and move, so the answer of a preview
  /// that was overtaken is dropped.
  int _previewVersion = 0;

  /// Starts or continues the game, with its saved record if it keeps one
  /// (RN-HL-70).
  ///
  /// A record that cannot be read does not stop the game: it starts without
  /// it and shows the failure (RNF-35).
  Future<void> start() async {
    final result = await _startGame.execute(_options);
    if (isClosed) {
      if (result case Right(:final value)) await value.engine.close();
      return;
    }
    switch (result) {
      case Right(value: final session):
        final failure = await _readRecord();
        if (isClosed) {
          await session.engine.close();
          return;
        }
        _session = session;
        _applyMove = _applyMoveFor(session);
        _checkMove = _checkMoveFor(session);
        emit(
          GameReady(
            session.engine.state,
            session.engine.phase,
            failure: failure,
            record: _record,
          ),
        );
      case Left(value: final error):
        emit(GameNotStarted(error));
    }
  }

  /// Plays [move]. Does nothing before the game started.
  ///
  /// If the move ends the game, the score is then kept as the record when it
  /// beats it (RN-HL-71), and the new record is shown. The move is shown
  /// first, without waiting for that save, so a [preview] keeps the order
  /// it relies on.
  Future<void> submit(TMove move) async {
    final session = _session;
    final applyMove = _applyMove;
    if (session == null || applyMove == null) return;
    _previewVersion++;
    final result = await applyMove.execute(move);
    if (isClosed) return;
    final engine = session.engine;
    emit(switch (result) {
      Right(value: AcceptedMove(:final state, :final events)) => GameReady(
        state,
        engine.phase,
        events: events,
        record: _record,
      ),
      Right(value: RejectedMove(:final reason, :final events)) => GameReady(
        engine.state,
        engine.phase,
        events: events,
        rejection: reason,
        record: _record,
      ),
      Left(value: final error) => GameReady(
        engine.state,
        engine.phase,
        failure: error,
        record: _record,
      ),
    });
    if (result case Right(
      value: AcceptedMove(
        :final state,
        outcome: Defeat() || Victory(canContinue: false),
      ),
    )) {
      await _keepRecord(state);
    }
  }

  /// Shows whether [move] would be played, without playing it (D-138). It
  /// does nothing before the game started.
  ///
  /// The game, its phase and its board stay as they are. The events, the
  /// rejection and the failure of the last move are not shown again, so the
  /// screen does not replay them.
  ///
  /// The answer is about the engine's state and is shown on the last state
  /// emitted, and both agree: a [submit] started after this call drops its
  /// answer, and the engine plays a [submit] started before it as soon as it
  /// is called, whose state is emitted first because [ApplyMoveUseCase] only
  /// takes microtasks (it does not wait for the save). An aspect that waits
  /// for real work would break this; then the preview must be checked
  /// against the emitted state. The record that [submit] keeps after a game
  /// ends is shown later, on the last state emitted, and keeps its preview.
  Future<void> preview(TMove move) async {
    final checkMove = _checkMove;
    if (checkMove == null) return;
    final version = ++_previewVersion;
    final result = await checkMove.execute(move);
    if (isClosed || version != _previewVersion) return;
    final screen = state;
    if (screen is! GameReady<C, TMove, TState>) return;
    emit(switch (result) {
      Right(value: final rejection) => GameReady(
        screen.state,
        screen.phase,
        preview: MovePreview(move, rejection: rejection),
        record: screen.record,
      ),
      Left(value: final error) => GameReady(
        screen.state,
        screen.phase,
        failure: error,
        record: screen.record,
      ),
    });
  }

  /// Stops showing the preview: the player let go of the move or took it
  /// away from the board.
  void clearPreview() {
    _previewVersion++;
    final screen = state;
    if (screen is! GameReady<C, TMove, TState> || screen.preview == null) {
      return;
    }
    emit(GameReady(screen.state, screen.phase, record: screen.record));
  }

  /// Reads the saved record into [_record]; returns why it could not, or
  /// `null`.
  Future<AppFailure?> _readRecord() async {
    final useCases = _recordUseCases;
    if (useCases == null) return null;
    switch (await useCases.getProgress.execute(useCases.game)) {
      case Right(value: final progress):
        _record = _scoreOf(progress);
        return null;
      case Left(value: final error):
        return error;
    }
  }

  /// Keeps the final score of [finished] as the record if it beats it, and
  /// shows the record that is kept, or why it could not be saved (RNF-35).
  ///
  /// It is shown on the last state emitted, which a [preview] may have
  /// changed while saving: its preview stays, and the events, the rejection
  /// and the failure already shown are not shown again.
  Future<void> _keepRecord(TState finished) async {
    final useCases = _recordUseCases;
    if (useCases == null) return;
    final result = await useCases.saveProgress.execute(
      HighScoreResult(useCases.game, finished.score),
    );
    if (isClosed) return;
    final screen = state;
    if (screen is! GameReady<C, TMove, TState>) return;
    switch (result) {
      case Right(value: final progress):
        final record = _scoreOf(progress);
        if (record == _record) return;
        _record = record;
        emit(
          GameReady(
            screen.state,
            screen.phase,
            preview: screen.preview,
            record: record,
          ),
        );
      case Left(value: final error):
        emit(
          GameReady(
            screen.state,
            screen.phase,
            failure: error,
            preview: screen.preview,
            record: _record,
          ),
        );
    }
  }

  static int? _scoreOf(VariantProgress? progress) => switch (progress) {
    HighScoreProgress(:final score) => score,
    LevelsProgress() || null => null,
  };

  @override
  Future<void> close() async {
    await _session?.engine.close();
    return super.close();
  }
}
