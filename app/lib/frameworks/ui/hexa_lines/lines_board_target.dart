import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../board/board_geometry.dart';
import 'piece_drag.dart';

/// The board of Hexa Lines as the target of a dragged piece (HL-02).
///
/// While a piece is over it, the cell under the piece's first cell is the
/// anchor (D-92): [onPreview] receives the move each time the anchor
/// changes, and [onClear] when the piece leaves the board. Letting the
/// piece go plays the move with [onDrop]; whether it fits is for the rules
/// (RN-HL-31): a rejected move changes nothing and the piece stays in its
/// slot (RN-HL-32).
final class LinesBoardTarget<C extends Coord> extends StatefulWidget {
  /// The target over [child], the board laid out by [geometry].
  const LinesBoardTarget({
    required this.geometry,
    required this.drag,
    required this.onPreview,
    required this.onClear,
    required this.onDrop,
    required this.child,
    super.key,
  });

  /// The board as it is laid out.
  final BoardGeometry<C> geometry;

  /// How a dragged piece is drawn.
  final LinesDragContext<C> drag;

  /// Shows whether a move would be played.
  final ValueChanged<PlacePiece<C>> onPreview;

  /// Stops showing a preview.
  final VoidCallback onClear;

  /// Plays a move.
  final ValueChanged<PlacePiece<C>> onDrop;

  /// The drawn board.
  final Widget child;

  @override
  State<LinesBoardTarget<C>> createState() => _LinesBoardTargetState<C>();
}

final class _LinesBoardTargetState<C extends Coord>
    extends State<LinesBoardTarget<C>> {
  /// The last move previewed, so a move inside the same cell asks nothing.
  PlacePiece<C>? _shown;

  @override
  Widget build(BuildContext context) => DragTarget<LinesDragged<C>>(
    onWillAcceptWithDetails: (_) => true,
    onMove: (details) => _show(_moveOf(details)),
    onLeave: (_) => _show(null),
    onAcceptWithDetails: (details) {
      final move = _moveOf(details);
      _shown = null;
      if (move == null) {
        widget.onClear();
      } else {
        widget.onDrop(move);
      }
    },
    builder: (context, _, _) => widget.child,
  );

  void _show(PlacePiece<C>? move) {
    if (move == _shown) return;
    _shown = move;
    if (move == null) {
      widget.onClear();
    } else {
      widget.onPreview(move);
    }
  }

  /// The move of the dragged piece with its first cell where it is now, or
  /// `null` if that point is not a cell of the board.
  PlacePiece<C>? _moveOf(DragTargetDetails<LinesDragged<C>> details) {
    if (context.findRenderObject() case final RenderBox box) {
      final drag = widget.drag.dragOf(details.data.piece.shape);
      final point = box.globalToLocal(details.offset + drag.anchorCenter);
      final anchor = widget.geometry.cellAt(point);
      if (anchor != null) return PlacePiece(details.data.trayIndex, anchor);
    }
    return null;
  }
}
