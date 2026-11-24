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
> =
    UseCase<TMove, Result<MoveResult<C, TState>>> Function(
      GameSession<C, TCell, TMove, TState> session,
    );

/// The presenter of the game screen: one for the four variants
/// (ARQ-A-08, ARQ-03 §4).
///
/// It starts the game with [StartGameUseCase] and plays each move with the
/// [ApplyMoveUseCase] of that session, built by `applyMoveFor` once the
/// session exists. It shows what the use cases return and holds no rules.
final class GameCubit<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    extends Cubit<GameScreenState<C, TState>> {
  /// A presenter that starts the game with `options`.
  GameCubit({
    required this._startGame,
    required this._options,
    required this._applyMoveFor,
  }) : super(GameLoading<C, TState>());

  final UseCase<StartOptions, Result<GameSession<C, TCell, TMove, TState>>>
  _startGame;
  final StartOptions _options;
  final ApplyMoveFor<C, TCell, TMove, TState> _applyMoveFor;

  GameSession<C, TCell, TMove, TState>? _session;
  UseCase<TMove, Result<MoveResult<C, TState>>>? _applyMove;

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

  @override
  Future<void> close() async {
    await _session?.engine.close();
    return super.close();
  }
}
