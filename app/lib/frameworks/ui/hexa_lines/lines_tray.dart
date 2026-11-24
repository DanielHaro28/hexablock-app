import 'package:flutter/widgets.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../../theme/app_colors.dart';
import '../board/shape_view.dart';
import '../board/topology_layout.dart';
import 'lines_cell_painter.dart';

/// The tray of Hexa Lines: its three fixed slots side by side (RN-HL-20,
/// D-133). A slot whose piece was already placed stays, empty, so the
/// other pieces do not move.
final class LinesTray<C extends Coord> extends StatelessWidget {
  /// The view of [tray].
  const LinesTray({required this.tray, required this.layout, super.key});

  /// The slots, `null` where a piece was placed.
  final List<LinesPiece<C>?> tray;

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (index, piece) in tray.indexed) ...[
        if (index > 0) const SizedBox(width: 8),
        Expanded(
          child: _Slot(piece: piece, layout: layout),
        ),
      ],
    ],
  );
}

final class _Slot<C extends Coord> extends StatelessWidget {
  const _Slot({required this.piece, required this.layout});

  final LinesPiece<C>? piece;
  final TopologyLayout<C> layout;

  /// How much of a slot a piece may take, so a line of five still has room.
  static const double _fill = 0.7;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: switch (piece) {
        null => const SizedBox.expand(),
        final piece => FractionallySizedBox(
          widthFactor: _fill,
          heightFactor: _fill,
          child: ShapeView<C, PieceColor>(
            shape: piece.shape,
            content: piece.color,
            layout: layout,
            painter: const LinesCellPainter(),
          ),
        ),
      },
    ),
  );
}
