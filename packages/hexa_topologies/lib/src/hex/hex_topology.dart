import 'package:hexa_engine/hexa_engine.dart';

import 'hex_coord.dart';

/// The hexagonal grid of annex A of 02-RN-TOPOLOGIAS (RN-HEX-01 to 08).
///
/// It implements only the primitives of [GridTopology] (D-90); normalizing,
/// rotating, orientations, rays, placing and the reading-order sort come from
/// the base class. Being stateless, it is `const` and shared.
///
/// | Axis | Lines            | Read             | Forward | Backward |
/// |------|------------------|------------------|---------|----------|
/// | `r`  | rows (`r` fixed) | west to east     | E       | W        |
/// | `q`  | `q` fixed        | northwest to southeast | SE | NW       |
/// | `s`  | `s` fixed        | northeast to southwest | SW | NE       |
///
/// The order of the axes, of the lines and of the cells inside each line is
/// the one of the reference simulator (`tools/reference-sim/hexsim.py`), which
/// the rule examples were checked with.
final class HexTopology extends GridTopology<HexCoord> {
  const HexTopology();

  /// Rows: `r` constant.
  static const axisR = Axis('r');

  /// `q` constant.
  static const axisQ = Axis('q');

  /// `s` constant.
  static const axisS = Axis('s');

  /// `(+1, −1)`, about 1 o'clock.
  static const northEast = Direction('NE', axis: axisS, forward: false);

  /// `(+1, 0)`, 3 o'clock.
  static const east = Direction('E', axis: axisR, forward: true);

  /// `(0, +1)`, about 5 o'clock.
  static const southEast = Direction('SE', axis: axisQ, forward: true);

  /// `(−1, +1)`, about 7 o'clock.
  static const southWest = Direction('SW', axis: axisS, forward: true);

  /// `(−1, 0)`, 9 o'clock.
  static const west = Direction('W', axis: axisR, forward: false);

  /// `(0, −1)`, about 11 o'clock.
  static const northWest = Direction('NW', axis: axisQ, forward: false);

  /// The only basic rotation: 60° clockwise (RN-HEX-06).
  static const clockwise = Rotation('cw60');

  /// The only board shape kind: `ShapeSpec('hexagon', [radius])`
  /// (RN-HEX-05).
  static const hexagon = 'hexagon';

  @override
  String get id => 'hex';

  /// `r`, `q` and `s`, in that order (RN-HEX-04).
  @override
  List<Axis> get axes => const [axisR, axisQ, axisS];

  /// Clockwise from 12 o'clock, the neighbor order of RN-HEX-08.
  @override
  List<Direction> get directions => const [
    northEast,
    east,
    southEast,
    southWest,
    west,
    northWest,
  ];

  @override
  List<Rotation> get basicRotations => const [clockwise];

  /// Every cell with `max(|q|, |r|, |s|) ≤ radius`, in reading order: a board
  /// of `3R(R + 1) + 1` cells (RN-HEX-05). The radius can be zero.
  @override
  Set<HexCoord> cellsOf(ShapeSpec spec) {
    if (spec.kind != hexagon || spec.size.length != 1 || spec.size[0] < 0) {
      throw ArgumentError.value(spec, 'spec', 'expected hexagon [radius]');
    }
    final [radius] = spec.size;
    return {
      for (var r = -radius; r <= radius; r++)
        for (var q = -radius; q <= radius; q++)
          if ((q + r).abs() <= radius) HexCoord(q, r),
    };
  }

  /// The six cells around [cell], clockwise from northeast (RN-HEX-03, 08).
  @override
  List<HexCoord> neighbors(HexCoord cell) => [
    for (final direction in directions) step(cell, direction),
  ];

  /// [cell] plus the offset of [direction] (RN-HEX-02). Throws
  /// [ArgumentError] for a direction of another topology.
  @override
  HexCoord step(HexCoord cell, Direction direction) {
    final (dq, dr) = switch (direction) {
      east => (1, 0),
      west => (-1, 0),
      northEast => (1, -1),
      southWest => (-1, 1),
      northWest => (0, -1),
      southEast => (0, 1),
      _ => throw ArgumentError.value(direction, 'direction'),
    };
    return HexCoord(cell.q + dq, cell.r + dr);
  }

  /// The lines along [axis], from the smallest constant coordinate to the
  /// largest; inside each, cells go in reading order, which is the forward
  /// sense of the axis (RN-HEX-04).
  @override
  Iterable<List<HexCoord>> lines(Set<HexCoord> cells, Axis axis) {
    final int Function(HexCoord) lineOf = switch (axis) {
      axisR => (cell) => cell.r,
      axisQ => (cell) => cell.q,
      axisS => (cell) => cell.s,
      _ => throw ArgumentError.value(axis, 'axis'),
    };
    final byLine = <int, List<HexCoord>>{};
    for (final cell in inReadingOrder(cells)) {
      byLine.putIfAbsent(lineOf(cell), () => []).add(cell);
    }
    final keys = byLine.keys.toList()..sort();
    return [for (final key in keys) byLine[key]!];
  }

  /// Row `r` first (top to bottom), then `q` (west to east) (RN-COM-16).
  @override
  int compareReadingOrder(HexCoord a, HexCoord b) =>
      a.r != b.r ? a.r.compareTo(b.r) : a.q.compareTo(b.q);

  /// `(q, r, s) → (−r, −s, −q)`, which in axial coordinates is
  /// `(q, r) → (−r, q + r)` (RN-HEX-06). Throws [ArgumentError] for a
  /// rotation of another topology.
  @override
  HexCoord rotateCell(HexCoord cell, Rotation rotation) {
    if (rotation != clockwise) {
      throw ArgumentError.value(rotation, 'rotation');
    }
    return HexCoord(-cell.r, cell.q + cell.r);
  }

  /// A single cell type, so every shape is normalized to `(0, 0)`.
  @override
  HexCoord normalizationOrigin(HexCoord first) => const HexCoord(0, 0);

  @override
  HexCoord translate(HexCoord cell, HexCoord from, HexCoord to) =>
      HexCoord(cell.q + to.q - from.q, cell.r + to.r - from.r);
}
