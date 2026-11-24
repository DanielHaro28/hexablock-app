import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'board_geometry.dart';
import 'cell_painter.dart';
import 'cells_painter.dart';
import 'topology_layout.dart';

/// A piece drawn on its own, as large as it fits: every cell of [shape]
/// holds [content] (for example, a piece of the tray).
final class ShapeView<C extends Coord, TCell extends Object>
    extends StatelessWidget {
  /// The view of [shape] filled with [content].
  const ShapeView({
    required this.shape,
    required this.content,
    required this.layout,
    required this.painter,
    super.key,
  });

  /// The cells of the piece.
  final Shape<C> shape;

  /// What each cell holds.
  final TCell content;

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  /// What the variant draws inside a cell.
  final CellPainter<TCell> painter;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      return CustomPaint(
        size: size,
        painter: CellsPainter<C, TCell>(
          cells: shape.cells,
          geometry: BoardGeometry.fit(layout, shape.cells, size),
          contentOf: (_) => content,
          painter: painter,
        ),
      );
    },
  );
}
