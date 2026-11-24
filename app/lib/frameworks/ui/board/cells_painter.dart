import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'board_geometry.dart';
import 'cell_painter.dart';

/// Paints a set of cells with a variant's [CellPainter]: the board or a
/// piece.
final class CellsPainter<C extends Coord, TCell extends Object>
    extends CustomPainter {
  /// Paints [cells] laid out by [geometry], each with [contentOf].
  CellsPainter({
    required this.cells,
    required this.geometry,
    required this.contentOf,
    required this.painter,
  });

  /// The cells to paint, in drawing order.
  final Iterable<C> cells;

  /// Where each cell goes.
  final BoardGeometry<C> geometry;

  /// What each cell holds, or `null` if it is empty.
  final TCell? Function(C cell) contentOf;

  /// The variant's painter.
  final CellPainter<TCell> painter;

  /// The gap between neighboring cells, as a fraction of a cell.
  static const double gap = 0.08;

  @override
  void paint(Canvas canvas, Size size) {
    for (final cell in cells) {
      painter.paintCell(
        canvas,
        geometry.outlineOf(cell, gap: gap),
        contentOf(cell),
      );
    }
  }

  @override
  bool shouldRepaint(CellsPainter<C, TCell> oldDelegate) => true;
}
