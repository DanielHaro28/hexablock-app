import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

/// A start use case that opens a game on a given [state] (D-56): a widget
/// test of any variant sets the board and the tray it needs, with no
/// generator involved.
///
/// It plays with [rules] and ignores the start options.
final class StubStartGame<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements
        ICommandService<StartOptions, GameSession<C, TCell, TMove, TState>> {
  /// Starts every game on [state], played with [rules].
  const StubStartGame(this.rules, this.state);

  /// The rules of the game.
  final IGameRules<C, TCell, TMove, TState> rules;

  /// The state every game starts on.
  final TState state;

  @override
  Future<Either<AppFailure, GameSession<C, TCell, TMove, TState>>> execute(
    StartOptions command,
  ) async => Right(GameSession(GameEngine(rules, state)));
}
