import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'board_geometry.dart';
import 'board_preview.dart';
import 'cell_painter.dart';
import 'cells_painter.dart';
import 'topology_layout.dart';

/// Wraps the drawn board, once it is laid out, with what a variant needs on
/// top of it, such as the target of a drag (HL-02). [geometry] turns a point
/// of [board] into a cell.
typedef BoardDecorator<C extends Coord> = Widget Function(
  BoardGeometry<C> geometry,
  Widget board,
);

/// The board of any variant on any cell shape: the topology's [layout]
/// times the variant's [painter] (ARQ-A-06, ARQ-02 §3.2).
///
/// It takes all the space it is given. A tap on a cell reaches
/// [onCellTap] as a typed cell `C`; a tap between or outside the cells is
/// ignored. A [preview] is drawn over the cells, and [decorate] wraps the
/// drawn board.
final class BoardView<C extends Coord, TCell extends Object>
    extends StatelessWidget {
  /// The view of [board].
  const BoardView({
    required this.board,
    required this.layout,
    required this.painter,
    this.onCellTap,
    this.preview,
    this.decorate,
    super.key,
  });

  /// The board to draw.
  final Board<C, TCell> board;

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  /// What the variant draws inside a cell.
  final CellPainter<TCell> painter;

  /// Called with the cell the player tapped.
  final ValueChanged<C>? onCellTap;

  /// The piece the player is dragging over the board, or `null`.
  final BoardPreview<C, TCell>? preview;

  /// Wraps the drawn board, or `null` to leave it as it is.
  final BoardDecorator<C>? decorate;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      final geometry = BoardGeometry.fit(layout, board.cells, size);
      final drawn = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final cell = geometry.cellAt(details.localPosition);
          if (cell != null) onCellTap?.call(cell);
        },
        child: CustomPaint(
          size: size,
          painter: CellsPainter<C, TCell>(
            cells: board.cells,
            geometry: geometry,
            contentOf: board.cell,
            painter: painter,
          ),
          foregroundPainter: switch (preview) {
            null => null,
            final preview => PreviewPainter<C, TCell>(
              preview: preview,
              geometry: geometry,
              painter: painter,
            ),
          },
        ),
      );
      return decorate?.call(geometry, drawn) ?? drawn;
    },
  );
}
