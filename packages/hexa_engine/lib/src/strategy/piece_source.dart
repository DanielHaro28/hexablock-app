import '../random/xorshift32.dart';

/// Where a game's random pieces come from: a Strategy that the variant's
/// factory chooses and injects into its rules (D-35, D-97).
///
/// A source holds only configuration (a catalog, its weights, a palette),
/// never the generator. The generator lives in the game state (RN-COM-42):
/// the rules pass it in and keep the one that comes back. So there is one
/// sequence per game, which the rules can also draw from themselves (for
/// example, a cell before the piece that goes in it), and undoing a turn
/// restores it with the rest of the state, without any source knowing.
///
/// A game without randomness has no source. Anything a source would need to
/// remember besides the generator (for example, which pieces are left in a
/// bag) lives in the variant's state too, like the tray.
///
/// `TPiece` has no constraint: a piece may be a shape, a stack or a tile,
/// and the source only hands out values (ARQ-02 §4.3).
abstract interface class IPieceSource<TPiece> {
  /// The next piece, drawn with [random], and the generator after the draw.
  ///
  /// The same [random] always gives the same piece (RN-COM-41).
  (TPiece piece, Xorshift32 after) next(Xorshift32 random);
}
