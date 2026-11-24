import 'dart:ui';

import 'package:hexa_engine/hexa_engine.dart';

import '../../theme/app_sizes.dart';
import 'board_geometry.dart';
import 'topology_layout.dart';

/// Where a dragged piece is drawn around the finger (HL-02, page 24 of the
/// design): as large as the board's cells and a little above the finger,
/// so the finger does not hide it.
///
/// The tray and the board both use it, so the cell under the piece's
/// [anchorCenter] is the anchor of the move (D-92). It knows no variant:
/// Hexa Fit can drag its pieces with it too (HF-02).
final class PieceDrag<C extends Coord> {
  /// The drag of [shape] at [scale] pixels per layout unit, the scale of
  /// the board.
  factory PieceDrag(
    TopologyLayout<C> layout,
    GridTopology<C> topology,
    Shape<C> shape,
    double scale,
  ) {
    final geometry = BoardGeometry.atScale(layout, shape.cells, scale);
    final first = topology.inReadingOrder(shape.cells).first;
    final size = geometry.bounds.size;
    return PieceDrag._(
      geometry,
      size,
      geometry.centerOf(first),
      Offset(size.width / 2, size.height + scale * AppSizes.dragLiftCells),
    );
  }

  PieceDrag._(this.geometry, this.size, this.anchorCenter, this.grip);

  /// The cells of the piece, with their top left corner at the origin.
  final BoardGeometry<C> geometry;

  /// The size of the drawn piece.
  final Size size;

  /// The center of the cell that goes on the anchor, from the top left
  /// corner of the drawn piece.
  final Offset anchorCenter;

  /// Where the finger holds the drawn piece, from its top left corner:
  /// centered and below it.
  final Offset grip;
}
