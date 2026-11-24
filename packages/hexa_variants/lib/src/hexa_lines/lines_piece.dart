import 'package:hexa_engine/hexa_engine.dart';

/// The color of a Hexa Lines cell: only visual, no rule reads it (RN-HL-01).
///
/// [name] is the palette name the configuration gives (for example `teal`);
/// the screen turns it into a color of the theme.
final class PieceColor {
  /// A color named [name].
  const PieceColor(this.name);

  /// The palette name of the color.
  final String name;

  @override
  bool operator ==(Object other) => other is PieceColor && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'PieceColor($name)';
}

/// A piece of the tray: one orientation of a catalog family, with the
/// family's color (RN-HL-22, D-131).
///
/// The [shape] is normalized (RN-COM-15): its first cell in reading order is
/// the one that goes on the anchor of a move (D-92).
final class LinesPiece<C extends Coord> {
  /// A piece with [shape] and [color].
  const LinesPiece(this.shape, this.color);

  /// The cells of the piece, normalized.
  final Shape<C> shape;

  /// The color the piece leaves on the board.
  final PieceColor color;

  @override
  bool operator ==(Object other) =>
      other is LinesPiece<C> && other.shape == shape && other.color == color;

  @override
  int get hashCode => Object.hash(shape, color);

  @override
  String toString() => 'LinesPiece($shape, $color)';
}

/// A family of the piece catalog: a base shape, how likely it is to come
/// out and its color (RN-HL-23, D-131, D-132).
///
/// Only the base shape is configured: its orientations come from the
/// topology (RN-COM-14), so the same catalog format works for any cell
/// shape.
final class LinesFamily<C extends Coord> {
  /// A family with the base [shape], a [weight] out of 100 (RN-HL-24) and
  /// the [color] of all its pieces.
  ///
  /// Throws an [ArgumentError] if [weight] is not positive or [shape] has
  /// more than [maxCells] cells (RN-HL-22). The lower bound of one cell is
  /// already a [Shape]'s own.
  LinesFamily({
    required this.shape,
    required this.weight,
    required this.color,
  }) {
    if (weight <= 0) {
      throw ArgumentError.value(weight, 'weight', 'must be positive');
    }
    final cells = shape.cells.length;
    if (cells > maxCells) {
      throw ArgumentError.value(cells, 'shape', 'at most $maxCells cells');
    }
  }

  /// The most cells a piece can have (RN-HL-22).
  static const int maxCells = 5;

  /// The base shape; any of its orientations works.
  final Shape<C> shape;

  /// How likely the family is, out of the 100 of RN-HL-24.
  final int weight;

  /// The color of every piece of the family (D-131).
  final PieceColor color;
}

/// What Hexa Lines reads from the configuration for one topology
/// (RN-COM-04, RNF-11, D-132, D-139): the board, the piece catalog and the
/// scoring values.
final class LinesConfig<C extends Coord> {
  /// A configuration with the [board] shape (RN-HL-10), the [catalog]
  /// families, in the order of the table (RN-HL-23), and the [scoring]
  /// values (RN-HL-61, 63).
  LinesConfig({
    required this.board,
    required List<LinesFamily<C>> catalog,
    required this.scoring,
  }) : catalog = List.unmodifiable(catalog);

  /// The shape of the board.
  final ShapeSpec board;

  /// The families of the catalog, in their order.
  final List<LinesFamily<C>> catalog;

  /// The values of the scoring formula.
  final LinesScoringConfig scoring;
}

/// The values of the Hexa Lines scoring formula that the configuration
/// gives (RNF-11, D-139); the formula itself is the policy (RN-HL-60 to 64).
final class LinesScoringConfig {
  /// [pointsPerLineCell] for each cell of a cleared line (RN-HL-61; 5 in
  /// D-09) and the [maxStreakMultiplier] of the streak (RN-HL-63; 3 in
  /// D-09).
  ///
  /// Throws an [ArgumentError] if [pointsPerLineCell] is not positive or
  /// [maxStreakMultiplier] is below 1, so a bad configuration fails where
  /// it is read.
  LinesScoringConfig({
    required this.pointsPerLineCell,
    required this.maxStreakMultiplier,
  }) {
    if (pointsPerLineCell <= 0) {
      throw ArgumentError.value(
        pointsPerLineCell,
        'pointsPerLineCell',
        'must be positive',
      );
    }
    if (maxStreakMultiplier < 1) {
      throw ArgumentError.value(
        maxStreakMultiplier,
        'maxStreakMultiplier',
        'must be at least 1',
      );
    }
  }

  /// The points of each cell of a cleared line.
  final int pointsPerLineCell;

  /// The largest streak multiplier.
  final int maxStreakMultiplier;
}
