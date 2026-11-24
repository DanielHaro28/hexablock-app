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
  /// Throws an [ArgumentError] if [weight] is not positive or [shape] does
  /// not have from [minCells] to [maxCells] cells (RN-HL-22).
  LinesFamily({
    required this.shape,
    required this.weight,
    required this.color,
  }) {
    if (weight <= 0) {
      throw ArgumentError.value(weight, 'weight', 'must be positive');
    }
    final cells = shape.cells.length;
    if (cells < minCells || cells > maxCells) {
      throw ArgumentError.value(
        cells,
        'shape',
        'must have from $minCells to $maxCells cells',
      );
    }
  }

  /// The fewest cells a piece can have (RN-HL-22).
  static const int minCells = 1;

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
/// (RN-COM-04, RNF-11, D-132): the board and the piece catalog.
final class LinesConfig<C extends Coord> {
  /// A configuration with the [board] shape (RN-HL-10) and the [catalog]
  /// families, in the order of the table (RN-HL-23).
  LinesConfig({required this.board, required List<LinesFamily<C>> catalog})
    : catalog = List.unmodifiable(catalog);

  /// The shape of the board.
  final ShapeSpec board;

  /// The families of the catalog, in their order.
  final List<LinesFamily<C>> catalog;
}
