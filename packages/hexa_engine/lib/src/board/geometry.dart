/// The geometric vocabulary every topology defines (RN-COM-10, glosario).
///
/// They are plain values with an `id` instead of enums: each topology declares
/// its own instances (three axes for hexagons, two for squares), and the
/// engine handles them without knowing which ones exist.
library;

/// One family of parallel lines of the grid (RN-COM-12).
///
/// Hexagons have three axes (`q`, `r`, `s`), squares two (rows, columns),
/// triangles three and cubes three.
final class Axis {
  const Axis(this.id);

  /// Name of the axis inside its topology, for example `'r'`.
  final String id;

  @override
  bool operator ==(Object other) => other is Axis && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Axis($id)';
}

/// An axis plus a sense (RN-COM-13), for example east = axis `r`, forward.
final class Direction {
  const Direction(this.id, {required this.axis, required this.forward});

  /// Name of the direction inside its topology, for example `'NE'`.
  final String id;

  /// The axis whose lines this direction runs along.
  final Axis axis;

  /// Whether it runs in the order of the axis' lines (`true`) or against it.
  final bool forward;

  @override
  bool operator ==(Object other) =>
      other is Direction &&
      other.id == id &&
      other.axis == axis &&
      other.forward == forward;

  @override
  int get hashCode => Object.hash(id, axis, forward);

  @override
  String toString() => 'Direction($id)';
}

/// A basic rotation of the grid (RN-COM-14).
///
/// 2D topologies have one (a clockwise step: 60° for hexagons and triangles,
/// 90° for squares); cubes have three, one per axis.
final class Rotation {
  const Rotation(this.id);

  /// Name of the rotation inside its topology, for example `'cw60'`.
  final String id;

  @override
  bool operator ==(Object other) => other is Rotation && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Rotation($id)';
}
