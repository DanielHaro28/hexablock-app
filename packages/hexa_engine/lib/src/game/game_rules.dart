import '../board/coord.dart';
import 'game_outcome.dart';
import 'game_state.dart';
import 'rejection_reason.dart';
import 'turn_result.dart';

/// The rules of a game, as the engine sees them: the Strategy that
/// `GameEngine` uses without knowing which game it is (D-35, RNF-02).
///
/// The initial state is not created here: the variant's factory builds it
/// (new game) or the saved-game codec reads it (continue), and passes it to
/// the engine (D-93).
///
/// Type constraints (ARQ-02 §4.3):
/// - `C extends Coord` and `TCell extends Object`, as in `Board`.
/// - `TState extends GameState<C, TCell>`: the engine reads the board and
///   the score of any state to notify and to save.
/// - `TMove` has none: the engine never inspects a move, it only passes it on.
abstract interface class IGameRules<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
> {
  /// The valid moves in [state]. It is lazy, so asking whether there is any
  /// stops at the first one.
  Iterable<TMove> validMoves(TState state);

  /// Plays [move] on [state]: the whole turn, or a rejection that leaves
  /// [state] unchanged (RN-COM-20, RN-COM-21).
  TurnResult<C, TState> playTurn(TState state, TMove move);
}

/// The skeleton of every turn: the Template Method (D-35, D-36).
///
/// [playTurn] fixes the order validate → apply → resolve → after resolve →
/// evaluate (RN-COM-20). A variant implements only the steps:
///
/// - [rejectionOf] and [apply] are required (primitive operations).
/// - [resolve] and [afterResolve] do nothing by default (a game without
///   resolution).
/// - [evaluate] is, by default, "defeat when no move is valid", the end shared
///   by most games; a variant with a victory checks it first and then calls
///   `super.evaluate` (RN-COM-23).
///
/// **[playTurn] must not be overridden.** Dart has no `final` methods and
/// layer 1 cannot depend on `package:meta`, so D-36 protects it with a rule in
/// the pull request template and a CI check that fails if a variant declares
/// `playTurn`. The steps are meant to be called only by [playTurn].
abstract base class GameRules<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements IGameRules<C, TCell, TMove, TState> {
  const GameRules();

  /// Template method: the fixed skeleton of a turn (RN-COM-20). Do not
  /// override it (D-36).
  @override
  TurnResult<C, TState> playTurn(TState state, TMove move) {
    if (rejectionOf(state, move) case final reason?) {
      return RejectedTurn(state, reason); // RN-COM-21: nothing changes
    }
    final applied = apply(state, move);
    final resolved = resolve(applied.state);
    final settled = afterResolve(resolved.state);
    return PlayedTurn(
      settled.state,
      events: List.unmodifiable([
        ...applied.events,
        ...resolved.events,
        ...settled.events,
      ]),
      outcome: evaluate(settled.state), // after resolving (RN-COM-23)
    );
  }

  /// Why [move] is rejected in [state], or `null` if it is valid (D-95).
  ///
  /// Return `const InvalidMove()` when the reason does not matter, or a
  /// reason of the variant's own family when the screen should tell the
  /// player why.
  RejectionReason? rejectionOf(TState state, TMove move);

  /// Whether [move] is valid in [state]: [rejectionOf] is `null`. Handy for
  /// [validMoves], so that the validation is written only once.
  bool isValid(TState state, TMove move) => rejectionOf(state, move) == null;

  /// Applies a valid [move] (for example, puts a piece on the board).
  Step<C, TState> apply(TState state, TMove move);

  /// Resolves the automatic effects until the board is stable (RN-COM-22).
  /// It is called once per turn, so the variant repeats inside it whatever
  /// must be repeated. By default, nothing happens.
  Step<C, TState> resolve(TState state) => Step(state);

  /// What happens after resolving (for example, a new piece or tile). By
  /// default, nothing.
  Step<C, TState> afterResolve(TState state) => Step(state);

  /// How the turn leaves the game, on the state after every step
  /// (RN-COM-23). By default, a defeat when no move is valid; [validMoves] is
  /// lazy, so this stops at the first valid move.
  GameOutcome evaluate(TState state) =>
      validMoves(state).isEmpty ? const Defeat() : const Ongoing();
}
