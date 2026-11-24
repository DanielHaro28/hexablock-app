import 'dart:ui';

/// Draws what is inside a cell for one variant (ARQ-A-06): a color in
/// Lines and Fit, a stack in Sort, a number in Merge.
///
/// The topology's layout gives the [outline]; the painter only fills it, so
/// the same painter works for any cell shape.
abstract interface class CellPainter<TCell extends Object> {
  /// Paints a cell with [outline] holding [content], or empty if `null`.
  void paintCell(Canvas canvas, Path outline, TCell? content);
}
