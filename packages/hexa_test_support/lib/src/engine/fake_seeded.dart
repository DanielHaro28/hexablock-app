import 'package:hexa_engine/hexa_engine.dart';

import 'fake_cell.dart';
import 'fake_coord.dart';
import 'fake_rules.dart';
import 'fake_strategies.dart';

/// A game state with a seeded generator, for the tests of undo and of the
/// capabilities (D-56).
///
/// Like a real state, it carries the generator as an immutable value
/// (RN-COM-42, D-97), so restoring a state restores the generator too
/// (RN-COM-61). It records the [seed] it started with (RN-COM-45).
final class FakeSeededState
    implements GameState<FakeCoord, FakeCell>, IRandomSeeded {
  /// A state with an explicit [random] generator.
  const FakeSeededState(
    this.board, {
    required this.seed,
    required this.random,
    this.score = 0,
  });

  /// The first state of a game on [board] seeded with [seed].
  FakeSeededState.start(this.board, {required this.seed})
    : random = Xorshift32(seed),
      score = 0;

  @override
  final Board<FakeCoord, FakeCell> board;

  @override
  final int score;

  @override
  final int seed;

  /// The generator the next draw uses.
  final Xorshift32 random;

  @override
  bool operator ==(Object other) =>
      other is FakeSeededState &&
      other.board == board &&
      other.score == score &&
      other.seed == seed &&
      other.random == random;

  @override
  int get hashCode => Object.hash(board, score, seed, random);

  @override
  String toString() =>
      'FakeSeededState(score: $score, seed: $seed, $random, $board)';
}

/// Rules that draw what they place from the state's generator (D-56): like
/// a variant whose next piece or tile is random.
///
/// - **Validate:** as [FakeRules]: off the board is an [InvalidMove]; an
///   occupied cell, a [CellOccupied].
/// - **Apply:** draws a label with a [FakePieceSource] over [labels] and the
///   state's generator, puts it on the move's cell (the move's own label is
///   ignored), adds [pointsPerTurn] and keeps the generator after the draw.
/// - **Evaluate:** the default of `GameRules` (defeat on a full board).
final class FakeSeededRules
    extends GameRules<FakeCoord, FakeCell, FakeMove, FakeSeededState> {
  const FakeSeededRules({required this.labels, this.pointsPerTurn = 1});

  /// The labels the generator chooses from; never empty.
  final List<String> labels;

  /// Points added by every turn.
  final int pointsPerTurn;

  @override
  Iterable<FakeMove> validMoves(FakeSeededState state) =>
      state.board.emptyCells.map(FakeMove.new);

  @override
  RejectionReason? rejectionOf(FakeSeededState state, FakeMove move) {
    if (!state.board.contains(move.cell)) return const InvalidMove();
    if (state.board.cell(move.cell) != null) return CellOccupied(move.cell);
    return null;
  }

  @override
  Step<FakeCoord, FakeSeededState> apply(FakeSeededState state, FakeMove move) {
    final (piece, after) = FakePieceSource(labels).next(state.random);
    return Step(
      FakeSeededState(
        state.board.withCells({move.cell: piece}),
        seed: state.seed,
        random: after,
        score: state.score + pointsPerTurn,
      ),
      const [FakeEvent('apply')],
    );
  }
}
