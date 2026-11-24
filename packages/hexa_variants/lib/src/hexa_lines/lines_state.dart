import 'package:hexa_engine/hexa_engine.dart';

import 'lines_piece.dart';

/// The state of a Hexa Lines game (ARQ-02 §4.2): immutable, so a turn
/// returns a new one.
///
/// The tray has [traySize] fixed slots (D-133): placing a piece leaves its
/// slot `null`, so the other pieces keep their index. The generator is part
/// of the state (RN-COM-42), and [seed] is the one the game started with
/// (RN-COM-45).
final class LinesState<C extends Coord>
    implements GameState<C, PieceColor>, IRandomSeeded {
  /// A state with [board], [tray], the generator [random], the [seed] the
  /// game started with and [score].
  ///
  /// Throws an [ArgumentError] if [tray] does not have [traySize] slots.
  LinesState({
    required this.board,
    required List<LinesPiece<C>?> tray,
    required this.random,
    required this.seed,
    this.score = 0,
  }) : tray = List.unmodifiable(tray) {
    if (tray.length != traySize) {
      throw ArgumentError.value(tray, 'tray', 'must have $traySize slots');
    }
  }

  /// How many pieces the tray holds (RN-HL-20).
  static const int traySize = 3;

  @override
  final Board<C, PieceColor> board;

  /// The tray slots, in order; `null` where a piece was already placed.
  final List<LinesPiece<C>?> tray;

  /// The game's generator, after the last draw.
  final Xorshift32 random;

  @override
  final int seed;

  @override
  final int score;

  /// This state with the given changes.
  LinesState<C> copyWith({
    Board<C, PieceColor>? board,
    List<LinesPiece<C>?>? tray,
    Xorshift32? random,
    int? score,
  }) => LinesState(
    board: board ?? this.board,
    tray: tray ?? this.tray,
    random: random ?? this.random,
    seed: seed,
    score: score ?? this.score,
  );

  @override
  bool operator ==(Object other) =>
      other is LinesState<C> &&
      other.board == board &&
      other.random == random &&
      other.seed == seed &&
      other.score == score &&
      _sameTray(other.tray);

  bool _sameTray(List<LinesPiece<C>?> others) {
    for (var i = 0; i < traySize; i++) {
      if (others[i] != tray[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(board, Object.hashAll(tray), random, seed, score);

  @override
  String toString() =>
      'LinesState(score: $score, seed: $seed, tray: $tray, $board)';
}

/// The only Hexa Lines move: put the piece of tray slot [trayIndex] with
/// its first cell on [anchor] (RN-HL-30, D-92).
final class PlacePiece<C extends Coord> {
  /// A move that places the piece of slot [trayIndex] on [anchor].
  const PlacePiece(this.trayIndex, this.anchor);

  /// The tray slot, from 0.
  final int trayIndex;

  /// Where the first cell of the piece goes.
  final C anchor;

  @override
  bool operator ==(Object other) =>
      other is PlacePiece<C> &&
      other.trayIndex == trayIndex &&
      other.anchor == anchor;

  @override
  int get hashCode => Object.hash(trayIndex, anchor);

  @override
  String toString() => 'PlacePiece($trayIndex, $anchor)';
}

/// What a Hexa Lines turn did, for the screen, the sound and the analytics,
/// in the order of RN-HL §11 (RN-COM-25).
sealed class LinesEvent<C extends Coord> extends GameEvent<C> {
  const LinesEvent();
}

/// The piece of slot [trayIndex] now fills [cells] (RN-HL-32).
final class PiecePlaced<C extends Coord> extends LinesEvent<C> {
  /// The piece of slot [trayIndex] was placed on [cells].
  const PiecePlaced(this.trayIndex, this.cells);

  /// The tray slot the piece came from.
  final int trayIndex;

  /// The cells it occupies.
  final Set<C> cells;

  @override
  bool operator ==(Object other) =>
      other is PiecePlaced<C> &&
      other.trayIndex == trayIndex &&
      other.cells.length == cells.length &&
      other.cells.containsAll(cells);

  @override
  int get hashCode => Object.hash(trayIndex, Object.hashAllUnordered(cells));

  @override
  String toString() => 'PiecePlaced($trayIndex, $cells)';
}
