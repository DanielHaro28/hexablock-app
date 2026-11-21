import 'package:hexa_engine/hexa_engine.dart';

import 'fake_coord.dart';

/// A minimal grid topology for the engine tests (D-56).
///
/// Cells with four neighbors (north, east, south, west), two axes (rows and
/// columns) and one basic rotation of a quarter turn clockwise. The only board
/// shape it builds is `ShapeSpec('rectangle', [width, height])`, with its
/// top-left cell at `(0, 0)`.
///
/// It is deliberately small: it implements only what each topology must
/// provide, so the engine tests exercise the operations that `GridTopology`
/// writes once for every shape (normalize, rotate, orientations, ray).
final class FakeTopology extends GridTopology<FakeCoord> {
  const FakeTopology();

  /// Rows: same `y`, read west to east.
  static const rows = Axis('rows');

  /// Columns: same `x`, read north to south.
  static const columns = Axis('columns');

  static const north = Direction('N', axis: columns, forward: false);
  static const east = Direction('E', axis: rows, forward: true);
  static const south = Direction('S', axis: columns, forward: true);
  static const west = Direction('W', axis: rows, forward: false);

  /// The only basic rotation: 90° clockwise, `(x, y) → (−y, x)`.
  static const quarterTurn = Rotation('cw90');

  /// The only board shape kind this topology accepts.
  static const rectangle = 'rectangle';

  @override
  String get id => 'fake';

  @override
  List<Axis> get axes => const [rows, columns];

  /// Clockwise from 12 o'clock, like the 2D neighbor order (RN-COM-17).
  @override
  List<Direction> get directions => const [north, east, south, west];

  @override
  List<Rotation> get basicRotations => const [quarterTurn];

  @override
  Set<FakeCoord> cellsOf(ShapeSpec spec) {
    if (spec.kind != rectangle ||
        spec.size.length != 2 ||
        spec.size.any((side) => side < 1)) {
      throw ArgumentError.value(spec, 'spec', 'expected rectangle [w, h]');
    }
    final [width, height] = spec.size;
    return {
      for (var y = 0; y < height; y++)
        for (var x = 0; x < width; x++) FakeCoord(x, y),
    };
  }

  @override
  List<FakeCoord> neighbors(FakeCoord cell) => [
    for (final direction in directions) step(cell, direction),
  ];

  @override
  FakeCoord step(FakeCoord cell, Direction direction) {
    final (dx, dy) = switch (direction.id) {
      'N' => (0, -1),
      'E' => (1, 0),
      'S' => (0, 1),
      'W' => (-1, 0),
      _ => throw ArgumentError.value(direction, 'direction'),
    };
    return FakeCoord(cell.x + dx, cell.y + dy);
  }

  @override
  Iterable<List<FakeCoord>> lines(Set<FakeCoord> cells, Axis axis) {
    final int Function(FakeCoord) lineOf;
    if (axis == rows) {
      lineOf = (cell) => cell.y;
    } else if (axis == columns) {
      lineOf = (cell) => cell.x;
    } else {
      throw ArgumentError.value(axis, 'axis');
    }
    final byLine = <int, List<FakeCoord>>{};
    for (final cell in inReadingOrder(cells)) {
      byLine.putIfAbsent(lineOf(cell), () => []).add(cell);
    }
    final keys = byLine.keys.toList()..sort();
    return [for (final key in keys) byLine[key]!];
  }

  /// Row first (top to bottom), then column (left to right) (RN-COM-16).
  @override
  int compareReadingOrder(FakeCoord a, FakeCoord b) =>
      a.y != b.y ? a.y.compareTo(b.y) : a.x.compareTo(b.x);

  @override
  FakeCoord rotateCell(FakeCoord cell, Rotation rotation) {
    if (rotation != quarterTurn) {
      throw ArgumentError.value(rotation, 'rotation');
    }
    return FakeCoord(-cell.y, cell.x);
  }

  /// A single cell type, so every shape is normalized to `(0, 0)`.
  @override
  FakeCoord normalizationOrigin(FakeCoord first) => const FakeCoord(0, 0);

  @override
  FakeCoord translate(FakeCoord cell, FakeCoord from, FakeCoord to) =>
      FakeCoord(cell.x + to.x - from.x, cell.y + to.y - from.y);
}

/// [FakeTopology] with two cell types, like the ▲ and ▼ of triangles
/// (RN-TRI-07), so the engine can test what depends on cell types without a
/// real topology (D-56, D-92).
///
/// A cell is *even* when `x + y` is even and *odd* otherwise, like the
/// squares of a chessboard. Even cells are normalized to `(0, 0)` and odd ones
/// to `(1, 0)`, and a translation must keep the type. The quarter turn keeps
/// it too, so rotations behave as in [FakeTopology].
final class FakeCheckeredTopology extends FakeTopology {
  const FakeCheckeredTopology();

  @override
  String get id => 'fake-checkered';

  /// `(0, 0)` for an even cell, `(1, 0)` for an odd one.
  @override
  FakeCoord normalizationOrigin(FakeCoord first) =>
      _isEven(first) ? const FakeCoord(0, 0) : const FakeCoord(1, 0);

  /// Throws [ArgumentError] if [from] and [to] are of different types.
  @override
  FakeCoord translate(FakeCoord cell, FakeCoord from, FakeCoord to) {
    if (_isEven(from) != _isEven(to)) {
      throw ArgumentError.value(to, 'to', 'not the cell type of $from');
    }
    return super.translate(cell, from, to);
  }

  static bool _isEven(FakeCoord cell) => (cell.x + cell.y).isEven;
}
