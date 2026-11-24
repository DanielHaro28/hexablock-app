import 'dart:math' as math;
import 'dart:ui';

import 'package:hexa_topologies/hexa_topologies.dart';

import 'topology_layout.dart';

/// The drawing of hexagonal cells: pointy-top, with the row `r` growing
/// downwards and `q` to the east along a row (RN-HEX-01).
///
/// A cell's center is `(√3 · (q + r / 2), 3 / 2 · r)` and its corners are one
/// unit away, at 30° + k · 60°. A point goes back to a cell by rounding its
/// fractional cube coordinates (the usual method for axial hexagons).
final class HexLayout implements TopologyLayout<HexCoord> {
  /// The hexagonal layout.
  const HexLayout();

  static final double _sqrt3 = math.sqrt(3);

  /// The corner offsets of a cell centered at the origin.
  static final List<Offset> _corners = List.unmodifiable([
    for (var k = 0; k < 6; k++)
      Offset(
        math.cos(math.pi / 6 + k * math.pi / 3),
        math.sin(math.pi / 6 + k * math.pi / 3),
      ),
  ]);

  @override
  Offset centerOf(HexCoord cell) =>
      Offset(_sqrt3 * (cell.q + cell.r / 2), 1.5 * cell.r);

  @override
  List<Offset> cornersOf(HexCoord cell) {
    final center = centerOf(cell);
    return [for (final corner in _corners) center + corner];
  }

  @override
  HexCoord cellAt(Offset point) {
    final q = (_sqrt3 / 3 * point.dx - point.dy / 3);
    final r = 2 / 3 * point.dy;
    return _round(q, r);
  }

  /// The cell nearest to the fractional cell `(q, r)`: round the three cube
  /// coordinates and fix the one that moved most, so they still add to 0.
  static HexCoord _round(double q, double r) {
    final s = -q - r;
    var rq = q.roundToDouble();
    var rr = r.roundToDouble();
    final rs = s.roundToDouble();
    final dq = (rq - q).abs();
    final dr = (rr - r).abs();
    final ds = (rs - s).abs();
    if (dq > dr && dq > ds) {
      rq = -rr - rs;
    } else if (dr > ds) {
      rr = -rq - rs;
    }
    return HexCoord(rq.toInt(), rr.toInt());
  }
}
