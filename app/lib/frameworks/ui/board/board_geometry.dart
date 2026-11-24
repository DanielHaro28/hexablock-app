import 'dart:math' as math;
import 'dart:ui';

import 'package:hexa_engine/hexa_engine.dart';

import 'topology_layout.dart';

/// A set of cells laid out on a rectangle of the screen: the board or a
/// piece (ARQ-A-06).
///
/// It scales the [TopologyLayout] so the cells fill the rectangle and
/// centers them. It turns a cell into a screen position and back, so a tap
/// or a drop becomes a typed cell `C` and never a loose index
/// (ARQ-02 §3.2).
final class BoardGeometry<C extends Coord> {
  BoardGeometry._(this._layout, this._cells, this.scale, this._origin);

  /// The [cells] of [layout] as large as they fit in [size], centered.
  ///
  /// Throws an [ArgumentError] if [cells] is empty.
  factory BoardGeometry.fit(
    TopologyLayout<C> layout,
    Iterable<C> cells,
    Size size,
  ) {
    final all = Set<C>.unmodifiable(cells);
    if (all.isEmpty) throw ArgumentError.value(cells, 'cells', 'is empty');
    final extent = _extentOf(layout, all);
    final scale = math.min(
      size.width / extent.width,
      size.height / extent.height,
    );
    final drawn = extent.size * scale;
    final origin =
        Offset(
          (size.width - drawn.width) / 2,
          (size.height - drawn.height) / 2,
        ) -
        extent.topLeft * scale;
    return BoardGeometry._(layout, all, scale, origin);
  }

  /// The [cells] of [layout] at [scale] pixels per layout unit, with the
  /// top left corner of their [bounds] at the origin: a piece drawn as large
  /// as the board's cells (HL-02).
  ///
  /// Throws an [ArgumentError] if [cells] is empty.
  factory BoardGeometry.atScale(
    TopologyLayout<C> layout,
    Iterable<C> cells,
    double scale,
  ) {
    final all = Set<C>.unmodifiable(cells);
    if (all.isEmpty) throw ArgumentError.value(cells, 'cells', 'is empty');
    final extent = _extentOf(layout, all);
    return BoardGeometry._(layout, all, scale, -extent.topLeft * scale);
  }

  final TopologyLayout<C> _layout;
  final Set<C> _cells;
  final Offset _origin;

  /// Screen pixels per layout unit: the distance from a cell's center to
  /// its corners.
  final double scale;

  /// The rectangle the cells take on the screen.
  Rect get bounds {
    final extent = _extentOf(_layout, _cells);
    return Rect.fromPoints(
      _toScreen(extent.topLeft),
      _toScreen(extent.bottomRight),
    );
  }

  /// The center of [cell] on the screen.
  Offset centerOf(C cell) => _toScreen(_layout.centerOf(cell));

  /// The outline of [cell] on the screen, shrunk by [gap] (a fraction of
  /// the cell) so neighboring cells do not touch.
  Path outlineOf(C cell, {double gap = 0}) {
    final center = _layout.centerOf(cell);
    final corners = [
      for (final corner in _layout.cornersOf(cell))
        _toScreen(center + (corner - center) * (1 - gap)),
    ];
    return Path()..addPolygon(corners, true);
  }

  /// The cell under [point] of the screen, or `null` if it is not one of
  /// the cells.
  C? cellAt(Offset point) {
    final cell = _layout.cellAt((point - _origin) / scale);
    return _cells.contains(cell) ? cell : null;
  }

  Offset _toScreen(Offset point) => _origin + point * scale;

  static Rect _extentOf<C extends Coord>(
    TopologyLayout<C> layout,
    Set<C> cells,
  ) {
    var left = double.infinity;
    var top = double.infinity;
    var right = double.negativeInfinity;
    var bottom = double.negativeInfinity;
    for (final cell in cells) {
      for (final corner in layout.cornersOf(cell)) {
        left = math.min(left, corner.dx);
        top = math.min(top, corner.dy);
        right = math.max(right, corner.dx);
        bottom = math.max(bottom, corner.dy);
      }
    }
    return Rect.fromLTRB(left, top, right, bottom);
  }
}
