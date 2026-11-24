import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../board/cells_painter.dart';
import '../board/shape_view.dart';
import 'lines_cell_painter.dart';
import 'lines_drag.dart';

/// The tray of Hexa Lines: its three fixed slots side by side (RN-HL-20,
/// D-133). A slot whose piece was already placed stays, empty, so the
/// other pieces do not move.
///
/// Each piece can be dragged to the board (HL-02): it follows the finger,
/// as large as the board's cells and a little above it, and its slot shows
/// a dashed outline meanwhile. If the move is not played, the piece is
/// back in its slot, because the slot is drawn from the state. [onDragEnd]
/// is called when the player lets go, wherever that is.
final class LinesTray<C extends Coord> extends StatelessWidget {
  /// The view of [tray].
  const LinesTray({
    required this.tray,
    required this.drag,
    required this.onDragEnd,
    super.key,
  });

  /// The slots, `null` where a piece was placed.
  final List<LinesPiece<C>?> tray;

  /// How a dragged piece is drawn.
  final LinesDragContext<C> drag;

  /// Called when a drag ends.
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (index, piece) in tray.indexed) ...[
        if (index > 0) const SizedBox(width: AppSizes.gapSmall),
        Expanded(
          child: switch (piece) {
            null => const _Slot(),
            final piece => Draggable<LinesDragged<C>>(
              data: LinesDragged(index, piece),
              dragAnchorStrategy: (_, _, _) => drag.dragOf(piece.shape).grip,
              feedback: _Dragged(piece: piece, drag: drag),
              childWhenDragging: const _Slot(dashed: true),
              onDragEnd: (_) => onDragEnd(),
              child: _Slot(
                child: ShapeView<C, PieceColor>(
                  shape: piece.shape,
                  content: piece.color,
                  layout: drag.layout,
                  painter: const LinesCellPainter(),
                ),
              ),
            ),
          },
        ),
      ],
    ],
  );
}

final class _Slot extends StatelessWidget {
  const _Slot({this.child, this.dashed = false});

  final Widget? child;
  final bool dashed;

  /// How much of a slot a piece may take, so a line of five still has room.
  static const double _fill = 0.7;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: CustomPaint(
      foregroundPainter: dashed ? const _DashedOutline() : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: switch (child) {
          null => const SizedBox.expand(),
          final child => FractionallySizedBox(
            widthFactor: _fill,
            heightFactor: _fill,
            child: child,
          ),
        },
      ),
    ),
  );
}

/// The piece that follows the finger, as large as the board's cells.
final class _Dragged<C extends Coord> extends StatelessWidget {
  const _Dragged({required this.piece, required this.drag});

  final LinesPiece<C> piece;
  final LinesDragContext<C> drag;

  @override
  Widget build(BuildContext context) {
    final dragged = drag.dragOf(piece.shape);
    return CustomPaint(
      size: dragged.size,
      painter: CellsPainter<C, PieceColor>(
        cells: piece.shape.cells,
        geometry: dragged.geometry,
        contentOf: (_) => piece.color,
        painter: const LinesCellPainter(),
      ),
    );
  }
}

/// The dashed outline of a slot whose piece is being dragged (page 24 of
/// the design).
final class _DashedOutline extends CustomPainter {
  const _DashedOutline();

  @override
  void paint(Canvas canvas, Size size) {
    final inset = AppSizes.borderWidth / 2;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(inset),
          const Radius.circular(AppSizes.radiusSmall),
        ),
      );
    final dashes = Path();
    for (final metric in outline.computeMetrics()) {
      for (
        var start = 0.0;
        start < metric.length;
        start += AppSizes.dashLength + AppSizes.dashGap
      ) {
        dashes.addPath(
          metric.extractPath(start, start + AppSizes.dashLength),
          Offset.zero,
        );
      }
    }
    canvas.drawPath(
      dashes,
      Paint()
        ..color = AppColors.draggedSlot
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSizes.borderWidth,
    );
  }

  @override
  bool shouldRepaint(_DashedOutline oldDelegate) => false;
}
