import '../board/coord.dart';
import '../game/game_rules.dart';
import '../game/game_state.dart';
import 'game_session.dart';
import 'new_game_options.dart';
import 'saved_game.dart';

/// Builds a consistent family of objects for one variant: its rules and its
/// game sessions (Abstract Factory, D-35; ARQ-02 §9.1).
///
/// Each variant has one concrete factory, generic in `C`, so the same
/// factory works for any cell shape the player chose (D-25). It creates
/// what only it uses (the piece source, the scoring policy, the board
/// shape) and wires it into its rules, so none of that is here (D-100): the
/// interface has only what the composition root and the use cases call.
///
/// `StartGameUseCase` (layer 2) receives any `VariantFamily` and calls
/// [createSession] or [continueSession] without knowing which variant it is
/// (RNF-07), so this interface lives in the engine.
///
/// Every implementation must pass `checkVariantFamilyContract` from
/// `hexa_test_support`, written with the first concrete factory (D-116).
///
/// Type constraints: the same as `GameEngine` (ARQ-02 §4.3).
abstract interface class VariantFamily<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> {
  /// The rules of the variant, with their strategies and decorators wired
  /// (D-96, D-100). A rule change in the defense is one line in the
  /// concrete factory's `createRules()`.
  IGameRules<C, TCell, TMove, TState> createRules();

  /// A new game: the initial state built from [options] (D-93), an engine
  /// that starts playing it and only the capabilities the variant has
  /// (D-33).
  GameSession<C, TCell, TMove, TState> createSession(NewGameOptions options);

  /// The game that [saved] kept (RN-COM-34, D-116): the engine starts
  /// paused with `GameEngine.paused` (D-111), the undo history continues
  /// from `saved.undo` and the active timer from `saved.activeTime`, if
  /// the variant has them. Its `snapshot()` gives [saved] back.
  GameSession<C, TCell, TMove, TState> continueSession(SavedGame<TState> saved);
}
