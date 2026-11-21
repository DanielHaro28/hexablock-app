import 'coord.dart';
import 'geometry.dart';
import 'shape.dart';
import 'shape_spec.dart';
import 'topology_visitor.dart';

/// How the cells of one cell shape connect: the geometry behind a board.
///
/// It is the implementor side of the Bridge with `Board` (D-35): the board
/// holds *what* is in the cells, the topology knows *how* the grid is laid
/// out. Four variants × four cell shapes need no sixteen board classes.
///
/// Variants use a topology only through the operations of RN-COM-10. They are
/// split in two:
///
/// - **Each topology implements** the primitives that depend on its geometry:
///   [cellsOf], [neighbors], [step], [lines], [compareReadingOrder],
///   [rotateCell], [normalizationOrigin] and [translate].
/// - **Written once here** for every topology: [inReadingOrder], [normalize],
///   [rotate], [orientations], [ray] and [accept]. A new cell shape gets them
///   for free and cannot get them wrong.
///
/// Topologies hold no state, so they can be `const` and shared, and they are
/// equal when they are of the same class and have the same [id].
///
/// Patterns (D-35): Factory Method ([cellsOf]), Iterator ([ray], [lines]),
/// Visitor ([accept]).
abstract base class GridTopology<C extends Coord> {
  const GridTopology();

  /// Stable identifier, saved with each game and used by the registry
  /// (for example `'hex'`).
  String get id;

  /// The axes of the grid, in a fixed order (RN-COM-12).
  List<Axis> get axes;

  /// Every direction of the grid, in a fixed order (RN-COM-13).
  List<Direction> get directions;

  /// The basic rotations: one in 2D, three in 3D (RN-COM-14).
  List<Rotation> get basicRotations;

  // ---------------------------------------------------------------------------
  // Primitives: each topology implements these.
  // ---------------------------------------------------------------------------

  /// Factory Method: the cells of a board of shape [spec], in reading order.
  ///
  /// Throws [ArgumentError] if this topology does not know `spec.kind` or the
  /// size does not fit it.
  Set<C> cellsOf(ShapeSpec spec);

  /// The cells that share a face with [cell] on an unbounded grid, in the
  /// canonical neighbor order (RN-COM-11, RN-COM-17). `Board.neighbors`
  /// keeps only the ones on the board.
  List<C> neighbors(C cell);

  /// The next cell after [cell] along [direction] on an unbounded grid.
  C step(C cell, Direction direction);

  /// The lines of [cells] along [axis], each one in its fixed order
  /// (RN-COM-12). Throws [ArgumentError] for an axis of another topology.
  Iterable<List<C>> lines(Set<C> cells, Axis axis);

  /// Reading order (RN-COM-16): negative if [a] comes before [b], zero if
  /// they are the same cell. It is the default tie-break between cells.
  int compareReadingOrder(C a, C b);

  /// [cell] turned by one basic [rotation] around the origin (RN-COM-14).
  /// Throws [ArgumentError] for a rotation of another topology.
  C rotateCell(C cell, Rotation rotation);

  /// Where a normalized shape puts its [first] cell in reading order
  /// (RN-COM-15). Usually the origin; topologies with more than one cell type
  /// (triangles ▲ and ▼) return the origin of [first]'s type.
  C normalizationOrigin(C first);

  /// [cell] moved by the vector that takes [from] to [to].
  ///
  /// The vector must keep every cell's type. Topologies with more than one
  /// cell type (triangles ▲ and ▼, RN-TRI-07) throw [ArgumentError] when
  /// [from] and [to] are of different types; [normalize] never asks for that.
  C translate(C cell, C from, C to);

  // ---------------------------------------------------------------------------
  // Written once for every topology.
  // ---------------------------------------------------------------------------

  /// [cells] sorted in reading order (RN-COM-16).
  List<C> inReadingOrder(Iterable<C> cells) =>
      [...cells]..sort(compareReadingOrder);

  /// [shape] translated so that its first cell in reading order lands on
  /// [normalizationOrigin] (RN-COM-15). Keeps the composite structure.
  Shape<C> normalize(Shape<C> shape) {
    final first = shape.cells.reduce(
      (a, b) => compareReadingOrder(a, b) <= 0 ? a : b,
    );
    final origin = normalizationOrigin(first);
    return shape.map((cell) => translate(cell, first, origin));
  }

  /// [shape] turned by one basic [rotation] and normalized (RN-COM-14).
  Shape<C> rotate(Shape<C> shape, Rotation rotation) =>
      normalize(shape.map((cell) => rotateCell(cell, rotation)));

  /// Every distinct orientation of [shape] reachable by combining basic
  /// rotations, normalized (RN-COM-14): up to 6 for hexagons and triangles,
  /// 4 for squares and 24 for cubes.
  ///
  /// The order is deterministic: the normalized [shape] first, then
  /// breadth-first in the order of [basicRotations].
  List<Shape<C>> orientations(Shape<C> shape) {
    final start = normalize(shape);
    final found = <Shape<C>>[start];
    final seen = <Shape<C>>{start};
    for (var i = 0; i < found.length; i++) {
      for (final rotation in basicRotations) {
        final next = rotate(found[i], rotation);
        if (seen.add(next)) found.add(next);
      }
    }
    return found;
  }

  /// The cells after [from] along [direction] while they are in [cells], up
  /// to the border (RN-COM-13). Lazy: a caller can stop at the first hit.
  Iterable<C> ray(Set<C> cells, C from, Direction direction) sync* {
    for (
      var cell = step(from, direction);
      cells.contains(cell);
      cell = step(cell, direction)
    ) {
      yield cell;
    }
  }

  /// Visitor double dispatch: calls `visitor.visit<C>(this)` with the real
  /// coordinate type, even when this topology is stored as
  /// `GridTopology<Coord>` (D-29).
  R accept<R>(TopologyVisitor<R> visitor) => visitor.visit<C>(this);

  /// Topologies hold no state, so two instances of the same class with the
  /// same [id] are interchangeable. Boards compare their topology with this,
  /// so equal boards stay equal even if a registry builds a second instance.
  @override
  bool operator ==(Object other) =>
      other is GridTopology &&
      other.runtimeType == runtimeType &&
      other.id == id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}
