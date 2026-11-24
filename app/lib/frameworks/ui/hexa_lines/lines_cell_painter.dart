import 'dart:ui';

import 'package:hexa_variants/hexa_variants.dart';

import '../../theme/app_colors.dart';
import '../board/cell_painter.dart';

/// Draws a Hexa Lines cell: empty, or filled with its piece's color
/// (RN-HL-01, D-131).
final class LinesCellPainter implements CellPainter<PieceColor> {
  /// The painter.
  const LinesCellPainter();

  @override
  void paintCell(Canvas canvas, Path outline, PieceColor? content) {
    final color = switch (content) {
      null => AppColors.emptyCell,
      PieceColor(:final name) => AppColors.piece(name),
    };
    canvas.drawPath(outline, Paint()..color = color);
  }
}
