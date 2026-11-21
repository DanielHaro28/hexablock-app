import 'package:hexa_engine/hexa_engine.dart';

/// A hexagonal cell in axial coordinates `(q, r)`, with `s = −q − r`
/// (RN-HEX-01).
///
/// Cells are pointy-top: `r` is the row, growing downwards, and `q` grows to
/// the east along a row. The third coordinate [s] is derived, so the three
/// always add up to zero.
///
/// It compares by value, as `Coord` requires: a board uses coordinates as map
/// keys (ARQ-02 §4.3).
final class HexCoord extends Coord {
  const HexCoord(this.q, this.r);

  /// Column, growing to the east.
  final int q;

  /// Row, growing downwards.
  final int r;

  /// The third axial coordinate, `−q − r`.
  int get s => -q - r;

  /// Number of steps between this cell and [other] on an unbounded grid:
  /// `(|Δq| + |Δr| + |Δs|) / 2` (RN-HEX-07).
  ///
  /// It is not a topology operation (RN-COM-10), so variants do not use it;
  /// it is here for the hexagonal geometry only.
  int distanceTo(HexCoord other) =>
      ((q - other.q).abs() + (r - other.r).abs() + (s - other.s).abs()) ~/ 2;

  @override
  bool operator ==(Object other) =>
      other is HexCoord && other.q == q && other.r == r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  String toString() => '($q, $r)';
}
