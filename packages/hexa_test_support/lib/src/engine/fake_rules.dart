import 'package:hexa_engine/hexa_engine.dart';

import 'fake_cell.dart';
import 'fake_coord.dart';

/// A move for the engine tests (D-56): put a [FakeCell] labelled [label] on
/// [cell].
final class FakeMove {
  const FakeMove(this.cell, [this.label = 'x']);

  /// Where the cell content goes.
  final FakeCoord cell;

  /// The label of the [FakeCell] that is placed.
  final String label;

  @override
  bool operator ==(Object other) =>
      other is FakeMove && other.cell == cell && other.label == label;

  @override
  int get hashCode => Object.hash(cell, label);

  @override
  String toString() => 'FakeMove($cell, $label)';
}

/// A game state for the engine tests (D-56).
///
/// Besides the board and the score it records [steps]: the names of the turn
/// steps that produced it, in order. The tests read it to check that each
/// step of the Template Method receives the state of the step before
/// (RN-COM-20).
final class FakeState implements GameState<FakeCoord, FakeCell> {
  const FakeState(this.board, {this.score = 0, this.steps = const []});

  @override
  final Board<FakeCoord, FakeCell> board;

  @override
  final int score;

  /// The turn steps that produced this state: `apply`, `resolve`,
  /// `afterResolve`.
  final List<String> steps;

  /// This state after [step], with the given changes.
  FakeState after(
    String step, {
    Board<FakeCoord, FakeCell>? board,
    int? score,
  }) => FakeState(
    board ?? this.board,
    score: score ?? this.score,
    steps: List.unmodifiable([...steps, step]),
  );

  @override
  bool operator ==(Object other) =>
      other is FakeState &&
      other.board == board &&
      other.score == score &&
      _sameSteps(other.steps);

  bool _sameSteps(List<String> others) {
    if (others.length != steps.length) return false;
    for (var i = 0; i < steps.length; i++) {
      if (others[i] != steps[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(board, score, Object.hashAll(steps));

  @override
  String toString() => 'FakeState(score: $score, steps: $steps, $board)';
}

/// An event that a [FakeRules] step publishes; [label] is the step name.
final class FakeEvent extends GameEvent<FakeCoord> {
  const FakeEvent(this.label);

  /// The step that published it.
  final String label;

  @override
  bool operator ==(Object other) => other is FakeEvent && other.label == label;

  @override
  int get hashCode => label.hashCode;

  @override
  String toString() => 'FakeEvent($label)';
}

/// A rejection reason of the fake rules: [cell] is already occupied.
///
/// It stands for the reasons a variant defines on its own (D-95), so the
/// tests show that the engine passes them through without knowing them.
final class CellOccupied extends RejectionReason {
  const CellOccupied(this.cell);

  /// The occupied cell.
  final FakeCoord cell;

  @override
  bool operator ==(Object other) => other is CellOccupied && other.cell == cell;

  @override
  int get hashCode => cell.hashCode;

  @override
  String toString() => 'CellOccupied($cell)';
}

/// Rules for the engine tests (D-56): they implement only the steps of the
/// turn, never `playTurn` (D-36).
///
/// - **Validate:** a cell off the board is an [InvalidMove]; an occupied one,
///   a [CellOccupied] (a reason of its own, D-95).
/// - **Apply:** puts the cell content; publishes `FakeEvent('apply')`.
/// - **Resolve:** adds [pointsPerTurn] to the score; publishes
///   `FakeEvent('resolve')`.
/// - **After resolve:** publishes `FakeEvent('afterResolve')`.
/// - **Evaluate:** [Victory] if [victoryWhen] holds; otherwise the default of
///   `GameRules` (defeat when no move is valid, that is, a full board).
///
/// [onApply] runs inside the apply step. The tests use it to call the engine
/// in the middle of a turn (RN-COM-24) or to make a step fail; real rules are
/// pure and never do this.
final class FakeRules
    extends GameRules<FakeCoord, FakeCell, FakeMove, FakeState> {
  FakeRules({
    this.pointsPerTurn = 0,
    this.victoryWhen,
    this.canContinue = false,
    this.onApply,
  });

  /// Points added in the resolve step of every turn.
  final int pointsPerTurn;

  /// When the evaluated state is a victory; `null` means never.
  final bool Function(FakeState state)? victoryWhen;

  /// Whether a victory lets the player keep playing (RN-COM-31).
  final bool canContinue;

  /// Runs inside the apply step (test hook).
  final void Function()? onApply;

  @override
  Iterable<FakeMove> validMoves(FakeState state) =>
      state.board.emptyCells.map(FakeMove.new);

  @override
  RejectionReason? rejectionOf(FakeState state, FakeMove move) {
    if (!state.board.contains(move.cell)) return const InvalidMove();
    if (state.board.cell(move.cell) != null) return CellOccupied(move.cell);
    return null;
  }

  @override
  Step<FakeCoord, FakeState> apply(FakeState state, FakeMove move) {
    onApply?.call();
    return Step(
      state.after(
        'apply',
        board: state.board.withCells({move.cell: FakeCell(move.label)}),
      ),
      const [FakeEvent('apply')],
    );
  }

  @override
  Step<FakeCoord, FakeState> resolve(FakeState state) => Step(
    state.after('resolve', score: state.score + pointsPerTurn),
    const [FakeEvent('resolve')],
  );

  @override
  Step<FakeCoord, FakeState> afterResolve(FakeState state) =>
      Step(state.after('afterResolve'), const [FakeEvent('afterResolve')]);

  @override
  GameOutcome evaluate(FakeState state) => (victoryWhen?.call(state) ?? false)
      ? Victory(canContinue: canContinue)
      : super.evaluate(state);
}
