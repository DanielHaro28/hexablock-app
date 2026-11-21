import 'coord.dart';

/// A set of cells relative to an origin, with no place on a board (glosario).
///
/// Composite pattern (D-35): a [CellShape] is a leaf and a [CompositeShape]
/// is made of parts. A piece is a composition of cells, and a level's figure
/// can be a composition of regions. Rotating, translating and normalizing go
/// through [map], so they treat a cell, a piece and a whole figure alike.
///
/// Two shapes are equal when they cover the same cells, however they were
/// built: that is what orientations compare (RN-COM-15).
sealed class Shape<C extends Coord> {
  const Shape();

  /// A shape made of one [CellShape] per cell.
  factory Shape.fromCells(Iterable<C> cells) =>
      CompositeShape([for (final cell in cells) CellShape(cell)]);

  /// Every cell the shape covers. Never empty.
  Set<C> get cells;

  /// The same structure with [transform] applied to every cell.
  Shape<C> map(C Function(C cell) transform);

  @override
  bool operator ==(Object other) =>
      other is Shape<C> &&
      other.cells.length == cells.length &&
      cells.containsAll(other.cells);

  @override
  int get hashCode => Object.hashAllUnordered(cells);

  @override
  String toString() => 'Shape$cells';
}

/// A shape of exactly one cell: the leaf of the composite.
final class CellShape<C extends Coord> extends Shape<C> {
  const CellShape(this.cell);

  /// The only cell.
  final C cell;

  @override
  Set<C> get cells => {cell};

  @override
  Shape<C> map(C Function(C cell) transform) => CellShape(transform(cell));
}

/// A shape made of other shapes: the node of the composite.
final class CompositeShape<C extends Coord> extends Shape<C> {
  /// Copies [parts] (reading them once, so a lazy iterable is fine); throws
  /// [ArgumentError] if there is none, because a shape with no cells cannot
  /// be normalized or placed.
  factory CompositeShape(Iterable<Shape<C>> parts) {
    final copied = List<Shape<C>>.unmodifiable(parts);
    if (copied.isEmpty) {
      throw ArgumentError.value(parts, 'parts', 'a shape needs a cell');
    }
    return CompositeShape._(
      copied,
      Set.unmodifiable({for (final part in copied) ...part.cells}),
    );
  }

  CompositeShape._(this.parts, this.cells);

  /// The shapes it is made of, in the order they were given.
  final List<Shape<C>> parts;

  @override
  final Set<C> cells;

  @override
  Shape<C> map(C Function(C cell) transform) =>
      CompositeShape([for (final part in parts) part.map(transform)]);
}
