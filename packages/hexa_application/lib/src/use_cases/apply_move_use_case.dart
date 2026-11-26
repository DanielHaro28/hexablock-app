import 'package:hexa_engine/hexa_engine.dart';

import '../command_service.dart';
import '../either.dart';
import '../errors.dart';
import '../game_keys.dart';
import '../ports/saved_game_repository.dart';

/// Plays a move of any variant and keeps the saved game up to date
/// (RF-10, RN-COM-20 to 25, RN-COM-33, RNF-07).
///
/// One is built per game, around its [GameSession]. The engine plays the
/// move synchronously (D-32); then, once `submit` returned, so that the
/// snapshot has the turn (D-113):
///
/// - a game that goes on is saved, without waiting (D-37);
/// - a game that ended is removed (RN-COM-35, D-110);
/// - a victory that lets the player keep playing is neither, because
///   `ContinuePlayingUseCase` saves it if they do (D-112);
/// - a rejected move changes nothing (RN-COM-21).
final class ApplyMoveUseCase<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements ICommandService<TMove, MoveResult<C, TState>> {
  /// Plays the moves of [_session], saving it under [_key].
  ApplyMoveUseCase(this._session, this._savedGames, this._key);

  final GameSession<C, TCell, TMove, TState> _session;
  final ISavedGameRepository<TState> _savedGames;
  final SavedGameKey _key;

  @override
  Future<Either<AppFailure, MoveResult<C, TState>>> execute(
    TMove command,
  ) async {
    final result = _session.engine.submit(command);
    switch (result) {
      case AcceptedMove(outcome: Ongoing()):
        _savedGames.scheduleSave(_key, _session.snapshot());
      case AcceptedMove(outcome: Defeat() || Victory(canContinue: false)):
        _savedGames.delete(_key);
      case AcceptedMove(outcome: Victory(canContinue: true)):
      case RejectedMove():
        break;
    }
    return Right(result);
  }
}
