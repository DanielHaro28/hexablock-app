import 'package:hexa_engine/hexa_engine.dart';

import '../command_service.dart';
import '../either.dart';
import '../errors.dart';
import '../game_keys.dart';
import '../ports/saved_game_repository.dart';

/// How a game starts: anew or from the saved one (ARQ-03 §3).
sealed class StartOptions {
  const StartOptions();
}

/// A new game with [newGame] (D-124).
final class StartNew extends StartOptions {
  /// A new game with [newGame].
  const StartNew(this.newGame);

  /// The options of the new game.
  final NewGameOptions newGame;
}

/// The saved game, which comes back paused (RN-COM-34).
final class ContinueSaved extends StartOptions {
  /// Continue the saved game.
  const ContinueSaved();
}

/// Starts a game of any variant (RF-01, RNF-07).
///
/// It sees the variant only as a [VariantFamily], so there is one use case
/// for every game. A new game replaces the saved one (RN-COM-35); a
/// saved game continues paused (RN-COM-34, D-111); with none to continue,
/// it returns a [RuleFailure] with [noSavedGame] (D-161).
final class StartGameUseCase<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements
        ICommandService<StartOptions, GameSession<C, TCell, TMove, TState>> {
  /// Starts games of [_family] saved under [_key] in [_savedGames].
  StartGameUseCase(this._family, this._savedGames, this._key);

  /// The [RuleFailure] code when there is no saved game to continue.
  static const noSavedGame = 'no-saved-game';

  final VariantFamily<C, TCell, TMove, TState> _family;
  final ISavedGameRepository<TState> _savedGames;
  final SavedGameKey _key;

  @override
  Future<Either<AppFailure, GameSession<C, TCell, TMove, TState>>> execute(
    StartOptions command,
  ) async {
    switch (command) {
      case StartNew(:final newGame):
        final session = _family.createSession(newGame);
        // After creating it, so a failure keeps the saved game (RN-COM-35).
        _savedGames.delete(_key);
        return Right(session);
      case ContinueSaved():
        final saved = await _savedGames.load(_key);
        if (saved == null) return const Left(RuleFailure(noSavedGame));
        return Right(_family.continueSession(saved));
    }
  }
}
