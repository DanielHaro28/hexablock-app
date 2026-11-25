import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../../../adapters/presentation/game/game_cubit.dart';
import '../../theme/hexa_colors.dart';
import '../board/topology_layout.dart';
import '../game/game_page.dart';
import 'lines_board_target.dart';
import 'lines_cell_painter.dart';
import 'lines_drag.dart';
import 'lines_preview.dart';
import 'lines_tray.dart';

/// The game screen of Hexa Lines: the common [GamePage] with its painter,
/// its tray, dragging a piece to the board (HL-02) and the record beside the
/// score (HL-06).
///
/// It reads the `GameCubit` of Hexa Lines above it: a drag over the board
/// asks for a preview, and letting the piece go plays the move.
final class LinesGameScreen<C extends Coord> extends StatefulWidget {
  /// The screen of a game drawn with [layout].
  const LinesGameScreen({required this.layout, super.key});

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  @override
  State<LinesGameScreen<C>> createState() => _LinesGameScreenState<C>();
}

final class _LinesGameScreenState<C extends Coord>
    extends State<LinesGameScreen<C>> {
  /// Created with the first state, which brings the topology.
  LinesDragContext<C>? _drag;

  LinesDragContext<C> _dragOn(LinesState<C> state) =>
      _drag ??= LinesDragContext(widget.layout, state.board.topology);

  @override
  void didUpdateWidget(LinesGameScreen<C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layout != widget.layout) _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context
        .read<GameCubit<C, PieceColor, PlacePiece<C>, LinesState<C>>>();
    return GamePage<C, PieceColor, PlacePiece<C>, LinesState<C>>(
      titleOf: (texts) => texts.gameTitleHexaLines,
      accent: HexaColors.of(context).gameLines,
      layout: widget.layout,
      cellPainter: const LinesCellPainter(),
      showsRecord: true,
      previewOf: linesPreviewOf,
      boardDecoratorOf: (context, state, geometry, board) {
        final drag = _dragOn(state)..board = geometry;
        return LinesBoardTarget<C>(
          geometry: geometry,
          drag: drag,
          onPreview: cubit.preview,
          onClear: cubit.clearPreview,
          onDrop: cubit.submit,
          child: board,
        );
      },
      trayOf: (context, state) => LinesTray<C>(
        tray: state.tray,
        drag: _dragOn(state),
        onDragEnd: cubit.clearPreview,
      ),
    );
  }
}
