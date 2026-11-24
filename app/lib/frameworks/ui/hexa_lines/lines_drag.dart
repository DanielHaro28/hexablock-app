import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../../theme/app_sizes.dart';
import '../board/board_geometry.dart';
import '../board/piece_drag.dart';
import '../board/topology_layout.dart';

/// What a tray slot gives the board while its piece is dragged.
final class LinesDragged<C extends Coord> {
  /// The piece of slot [trayIndex].
  const LinesDragged(this.trayIndex, this.piece);

  /// The tray slot the piece comes from (D-133).
  final int trayIndex;

  /// The dragged piece.
  final LinesPiece<C> piece;
}

/// What the tray and the board share during a game: the board's geometry,
/// once it is laid out, so a dragged piece is as large as its cells.
final class LinesDragContext<C extends Coord> {
  /// The context of a game drawn with [layout] on [topology].
  LinesDragContext(this.layout, this.topology);

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  /// The topology of the board.
  final GridTopology<C> topology;

  /// The board as it was last laid out, or `null` before that.
  ///
  /// The board writes it while it is laid out and the tray reads it only
  /// when a drag starts, so nothing has to rebuild when it changes. A drag
  /// that is going on when the board changes size keeps the size it started
  /// with.
  BoardGeometry<C>? board;

  /// How [shape] is drawn while it is dragged.
  PieceDrag<C> dragOf(Shape<C> shape) => PieceDrag(
    layout,
    topology,
    shape,
    board?.scale ?? AppSizes.fallbackCellScale,
  );
}
