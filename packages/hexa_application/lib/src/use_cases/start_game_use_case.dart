import 'package:hexa_engine/hexa_engine.dart';

import '../errors.dart';
import '../game_keys.dart';
import '../ports/saved_game_repository.dart';
import '../use_case.dart';

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
/// for every game. A new game removes the saved one first (RN-COM-35); a
/// saved game continues paused (RN-COM-34, D-111).
final class StartGameUseCase<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements UseCase<StartOptions, GameSession<C, TCell, TMove, TState>> {
  /// Starts games of [_family] saved under [_key] in [_savedGames].
  StartGameUseCase(this._family, this._savedGames, this._key);

  /// The [RuleException] code when there is no saved game to continue.
  static const noSavedGame = 'no-saved-game';

  final VariantFamily<C, TCell, TMove, TState> _family;
  final ISavedGameRepository<TState> _savedGames;
  final SavedGameKey _key;

  @override
  Future<GameSession<C, TCell, TMove, TState>> execute(
    StartOptions input,
  ) async {
    switch (input) {
      case StartNew(:final newGame):
        _savedGames.delete(_key); // RN-COM-35
        return _family.createSession(newGame);
      case ContinueSaved():
        final saved = await _savedGames.load(_key);
        if (saved == null) throw const RuleException(noSavedGame);
        return _family.continueSession(saved);
    }
  }
}
