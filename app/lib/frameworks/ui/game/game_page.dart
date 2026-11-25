import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_engine/hexa_engine.dart';

import '../../../adapters/presentation/game/game_cubit.dart';
import '../../../adapters/presentation/game/game_screen_state.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_sizes.dart';
import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_radii.dart';
import '../../theme/hexa_typography.dart';
import '../board/board_geometry.dart';
import '../board/board_preview.dart';
import '../board/board_view.dart';
import '../board/cell_painter.dart';
import '../board/topology_layout.dart';

/// Builds the variant's own part of a slot from the state of its game.
typedef SlotBuilder<TState> = Widget Function(
  BuildContext context,
  TState state,
);

/// Turns the preview of the game screen into the cells the board draws
/// (D-138), or `null` to draw nothing.
typedef PreviewBuilder<C extends Coord, TCell extends Object, TMove, TState> =
    BoardPreview<C, TCell>? Function(TState state, MovePreview<TMove> preview);

/// Wraps the drawn board of a game in [state] (see `BoardDecorator`).
typedef BoardDecoratorBuilder<C extends Coord, TState> = Widget Function(
  BuildContext context,
  TState state,
  BoardGeometry<C> geometry,
  Widget board,
);

/// The game screen, one for the four variants (D-66, page 26 of the design).
///
/// It has five slots, top to bottom: the top bar (the game's name with its
/// color), the markers, the board, the tray and the actions. The board and
/// the score are the same for every variant; the variant's module fills the
/// rest ([trayOf], [actionsOf]) and gives the [cellPainter] and the
/// topology's [layout]. Nothing moves when a slot is empty: Hexa Merge has
/// no tray and its board grows down to the actions. A variant that drags
/// pieces onto the board also gives [previewOf] and [boardDecoratorOf]
/// (HL-02).
///
/// When the game is over, a notice takes the place of the tray, so no piece
/// can be dragged any more (HL-05, D-141); the defeat screen comes with
/// PRG-02.
///
/// The markers are the score and, for a variant that keeps one
/// ([showsRecord]), the saved record beside it (RN-HL-70, page 26 of the
/// design); with no record saved yet, it reads 0.
///
/// It reads the [GameCubit] above it. Pause and "how to play" (NAV-04,
/// NAV-05) come with their stories.
final class GamePage<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    extends StatelessWidget {
  /// The screen of a game titled [titleOf] in [accent].
  const GamePage({
    required this.titleOf,
    required this.accent,
    required this.layout,
    required this.cellPainter,
    this.trayOf,
    this.actionsOf,
    this.previewOf,
    this.boardDecoratorOf,
    this.showsRecord = false,
    super.key,
  });

  /// The game's name, in the player's language.
  final String Function(AppLocalizations texts) titleOf;

  /// The game's color: the dot of the title (REVISION-DISENO).
  final Color accent;

  /// Where the topology draws each cell.
  final TopologyLayout<C> layout;

  /// What the variant draws inside a cell.
  final CellPainter<TCell> cellPainter;

  /// The tray slot, or `null` if the variant has none.
  final SlotBuilder<TState>? trayOf;

  /// The actions slot, or `null` if the variant has none yet.
  final SlotBuilder<TState>? actionsOf;

  /// What the board draws for the preview of a move, or `null` if the
  /// variant has none.
  final PreviewBuilder<C, TCell, TMove, TState>? previewOf;

  /// What wraps the drawn board, or `null` if nothing does.
  final BoardDecoratorBuilder<C, TState>? boardDecoratorOf;

  /// Whether the variant keeps a record, shown beside the score.
  final bool showsRecord;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ColoredBox(
      color: HexaColors.of(context).bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HexaSpacing.s16),
          child:
              BlocBuilder<
                GameCubit<C, TCell, TMove, TState>,
                GameScreenState<C, TMove, TState>
              >(
                builder: (context, screen) => switch (screen) {
                  GameLoading() => _Message(texts.gameLoading),
                  GameNotStarted() => _Message(texts.gameNotStarted),
                  GameReady(
                    :final state,
                    :final phase,
                    :final preview,
                    :final record,
                  ) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TopBar(title: titleOf(texts), accent: accent),
                        const SizedBox(height: HexaSpacing.s16),
                        _Markers(
                          score: state.score,
                          record: showsRecord ? record ?? 0 : null,
                        ),
                        const SizedBox(height: HexaSpacing.s16),
                        Expanded(
                          child: Semantics(
                            label: texts.boardLabel,
                            child: _Panel(
                              bordered: true,
                              child: BoardView<C, TCell>(
                                board: state.board,
                                layout: layout,
                                painter: cellPainter,
                                preview: switch ((preview, previewOf)) {
                                  (final preview?, final previewOf?) =>
                                    previewOf(state, preview),
                                  _ => null,
                                },
                                decorate: switch (boardDecoratorOf) {
                                  null => null,
                                  final decorate =>
                                    (geometry, board) => decorate(
                                      context,
                                      state,
                                      geometry,
                                      board,
                                    ),
                                },
                              ),
                            ),
                          ),
                        ),
                        if (phase is GameOverPhase) ...[
                          const SizedBox(height: HexaSpacing.s16),
                          _GameOverNotice(texts.gameOverTitle),
                        ] else if (trayOf case final trayOf?) ...[
                          const SizedBox(height: HexaSpacing.s16),
                          Semantics(
                            label: texts.trayLabel,
                            child: _Panel(child: trayOf(context, state)),
                          ),
                        ],
                        if (actionsOf case final actionsOf?) ...[
                          const SizedBox(height: HexaSpacing.s16),
                          actionsOf(context, state),
                        ],
                      ],
                    ),
                },
              ),
        ),
      ),
    );
  }
}

final class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.accent});

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        child: const SizedBox.square(dimension: AppSizes.accentDot),
      ),
      const SizedBox(width: HexaSpacing.s8),
      Text(title, style: HexaTypography.subtitle),
    ],
  );
}

/// The score and, if [record] is not `null`, the record beside it.
final class _Markers extends StatelessWidget {
  const _Markers({required this.score, required this.record});

  final int score;
  final int? record;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final scoreMarker = _Marker(label: texts.scoreLabel, value: score);
    return switch (record) {
      null => scoreMarker,
      final record => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: scoreMarker),
          const SizedBox(width: HexaSpacing.s16),
          Expanded(
            child: _Marker(label: texts.recordLabel, value: record),
          ),
        ],
      ),
    };
  }
}

final class _Marker extends StatelessWidget {
  const _Marker({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => _Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: HexaTypography.label.copyWith(
            color: HexaColors.of(context).inkSoft,
          ),
        ),
        Text('$value', style: HexaTypography.title),
      ],
    ),
  );
}

final class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.bordered = false});

  final Widget child;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(HexaRadii.of(context).card),
        border: bordered
            ? Border.all(color: colors.ink, width: HexaBorders.board)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(HexaSpacing.s12),
        child: child,
      ),
    );
  }
}

/// Says that the game is over, as soon as it is (a live region, so a screen
/// reader announces it).
final class _GameOverNotice extends StatelessWidget {
  const _GameOverNotice(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: _Panel(
      child: Center(child: Text(title, style: HexaTypography.subtitle)),
    ),
  );
}

final class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(child: Text(text));
}
