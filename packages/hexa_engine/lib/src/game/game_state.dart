import '../board/board.dart';
import '../board/coord.dart';

/// What the engine needs to read from any variant's state (D-30).
///
/// Each variant defines its own immutable state (board, tray, counters,
/// generator...) and implements this interface. The engine never learns the
/// rest of it: it only reads the board and the score to notify and to save.
///
/// Type constraints (ARQ-02 §4.3):
/// - `C extends Coord`: the board is keyed by coordinates with value
///   equality.
/// - `TCell extends Object`: an empty cell is `null`, so the content itself
///   can never be nullable.
abstract interface class GameState<C extends Coord, TCell extends Object> {
  /// The board of the game.
  Board<C, TCell> get board;

  /// The current score: an integer ≥ 0 (RN-COM-50).
  int get score;
}
