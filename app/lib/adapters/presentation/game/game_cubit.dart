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
> = UseCase<TMove, Result<MoveResult<C, TState>>> Function(
  GameSession<C, TCell, TMove, TState> session,
);

/// Builds the check use case of a session (D-138), already wrapped by its
/// aspects.
typedef CheckMoveFor<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> = UseCase<TMove, Result<RejectionReason?>> Function(
  GameSession<C, TCell, TMove, TState> session,
);

/// The presenter of the game screen: one for the four variants
/// (ARQ-A-08, ARQ-03 §4).
///
/// It starts the game with [StartGameUseCase] and plays each move with the
/// [ApplyMoveUseCase] of that session, built by `applyMoveFor` once the
/// session exists. While the player drags a move, [preview] asks the
/// [CheckMoveUseCase] built by `checkMoveFor` whether it would be played
/// (D-138). It shows what the use cases return and holds no rules.
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
  }) : super(GameLoading<C, TMove, TState>());

  final UseCase<StartOptions, Result<GameSession<C, TCell, TMove, TState>>>
  _startGame;
  final StartOptions _options;
  final ApplyMoveFor<C, TCell, TMove, TState> _applyMoveFor;
  final CheckMoveFor<C, TCell, TMove, TState> _checkMoveFor;

  GameSession<C, TCell, TMove, TState>? _session;
  UseCase<TMove, Result<MoveResult<C, TState>>>? _applyMove;
  UseCase<TMove, Result<RejectionReason?>>? _checkMove;

  /// Grows with every preview, clear and move, so the answer of a preview
  /// that was overtaken is dropped.
  int _previewVersion = 0;

  /// Starts or continues the game.
  Future<void> start() async {
    final result = await _startGame.execute(_options);
    if (isClosed) {
      if (result case Success(:final value)) await value.engine.close();
      return;
    }
    switch (result) {
      case Success(value: final session):
        _session = session;
        _applyMove = _applyMoveFor(session);
        _checkMove = _checkMoveFor(session);
        emit(GameReady(session.engine.state, session.engine.phase));
      case Failure(:final error):
        emit(GameNotStarted(error));
    }
  }

  /// Plays [move]. Does nothing before the game started.
  Future<void> submit(TMove move) async {
    final session = _session;
    final applyMove = _applyMove;
    if (session == null || applyMove == null) return;
    _previewVersion++;
    final result = await applyMove.execute(move);
    if (isClosed) return;
    final engine = session.engine;
    emit(switch (result) {
      Success(value: AcceptedMove(:final state, :final events)) => GameReady(
        state,
        engine.phase,
        events: events,
      ),
      Success(value: RejectedMove(:final reason, :final events)) => GameReady(
        engine.state,
        engine.phase,
        events: events,
        rejection: reason,
      ),
      Failure(:final error) => GameReady(
        engine.state,
        engine.phase,
        failure: error,
      ),
    });
  }

  /// Shows whether [move] would be played, without playing it (D-138). It
  /// does nothing before the game started.
  ///
  /// The game, its phase and its board stay as they are. The events, the
  /// rejection and the failure of the last move are not shown again, so the
  /// screen does not replay them.
  Future<void> preview(TMove move) async {
    final checkMove = _checkMove;
    if (checkMove == null) return;
    final version = ++_previewVersion;
    final result = await checkMove.execute(move);
    if (isClosed || version != _previewVersion) return;
    final screen = state;
    if (screen is! GameReady<C, TMove, TState>) return;
    emit(switch (result) {
      Success(value: final rejection) => GameReady(
        screen.state,
        screen.phase,
        preview: MovePreview(move, rejection: rejection),
      ),
      Failure(:final error) => GameReady(
        screen.state,
        screen.phase,
        failure: error,
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
    emit(GameReady(screen.state, screen.phase));
  }

  @override
  Future<void> close() async {
    await _session?.engine.close();
    return super.close();
  }
}
