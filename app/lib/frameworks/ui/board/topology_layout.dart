import 'dart:ui';

import 'package:hexa_engine/hexa_engine.dart';

/// Where a topology draws each cell (ARQ-A-06, ARQ-02 §3.1): one layout per
/// cell shape, registered with its topology in a `TopologyEntry`.
///
/// It works in layout units, where a cell's corners are one unit from its
/// center; `BoardGeometry` scales them to the screen. It knows nothing
/// about what is inside a cell: the variant's `CellPainter` draws that.
abstract interface class TopologyLayout<C extends Coord> {
  /// The center of [cell].
  Offset centerOf(C cell);

  /// The corners of [cell], in drawing order.
  List<Offset> cornersOf(C cell);

  /// The cell whose area contains [point], on an unbounded grid: whether it
  /// is on the board is for the caller to check.
  C cellAt(Offset point);
}
