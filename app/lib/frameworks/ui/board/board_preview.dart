import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';

import '../../theme/app_colors.dart';
import 'board_geometry.dart';
import 'cell_painter.dart';
import 'cells_painter.dart';

/// What the board shows over its cells while the player drags a piece
/// (HL-02, D-138): the [cells] the piece would take, what they would hold
/// and whether the move would be played.
///
/// The variant builds it from the `MovePreview` of the game screen; the
/// board only draws it.
final class BoardPreview<C extends Coord, TCell extends Object> {
  /// A preview of [content] on [cells], [valid] or not.
  BoardPreview({
    required Iterable<C> cells,
    required this.content,
    required this.valid,
  }) : cells = Set.unmodifiable(cells);

  /// The board cells the piece would take.
  final Set<C> cells;

  /// What each of those cells would hold.
  final TCell content;

  /// Whether the move would be played.
  final bool valid;

  @override
  bool operator ==(Object other) =>
      other is BoardPreview<C, TCell> &&
      other.content == content &&
      other.valid == valid &&
      other.cells.length == cells.length &&
      other.cells.containsAll(cells);

  @override
  int get hashCode =>
      Object.hash(content, valid, Object.hashAllUnordered(cells));
}

/// Paints a [BoardPreview] over the board: the piece, lighter, where it
/// fits; the error color where it does not.
final class PreviewPainter<C extends Coord, TCell extends Object>
    extends CustomPainter {
  /// Paints [preview] laid out by [geometry] with the variant's [painter].
  PreviewPainter({
    required this.preview,
    required this.geometry,
    required this.painter,
  });

  /// What to paint.
  final BoardPreview<C, TCell> preview;

  /// Where each cell goes.
  final BoardGeometry<C> geometry;

  /// The variant's painter, for a valid preview.
  final CellPainter<TCell> painter;

  @override
  void paint(Canvas canvas, Size size) {
    for (final cell in preview.cells) {
      final outline = geometry.outlineOf(cell, gap: CellsPainter.gap);
      if (preview.valid) {
        // A layer only takes the alpha of its paint: the color is not drawn.
        final light = Paint()
          ..color = const Color(0xFF000000)
              .withValues(alpha: AppColors.previewOpacity);
        canvas.saveLayer(outline.getBounds(), light);
        painter.paintCell(canvas, outline, preview.content);
        canvas.restore();
      } else {
        canvas.drawPath(outline, Paint()..color = AppColors.invalidPreview);
      }
    }
  }

  @override
  bool shouldRepaint(PreviewPainter<C, TCell> oldDelegate) =>
      oldDelegate.preview != preview ||
      oldDelegate.geometry != geometry ||
      oldDelegate.painter != painter;
}
