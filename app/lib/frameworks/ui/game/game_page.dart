import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_engine/hexa_engine.dart';

import '../../../adapters/presentation/game/game_cubit.dart';
import '../../../adapters/presentation/game/game_screen_state.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../board/board_view.dart';
import '../board/cell_painter.dart';
import '../board/topology_layout.dart';

/// Builds the variant's own part of a slot from the state of its game.
typedef SlotBuilder<TState> = Widget Function(
  BuildContext context,
  TState state,
);

/// The game screen, one for the four variants (D-66, page 26 of the design).
///
/// It has five slots, top to bottom: the top bar (the game's name with its
/// color), the markers, the board, the tray and the actions. The board and
/// the score are the same for every variant; the variant's module fills the
/// rest ([trayOf], [actionsOf]) and gives the [cellPainter] and the
/// topology's [layout]. Nothing moves when a slot is empty: Hexa Merge has
/// no tray and its board grows down to the actions.
///
/// It reads the [GameCubit] above it. Pause and "how to play" (NAV-04,
/// NAV-05) and the record (HL-06) come with their stories.
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

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.gapLarge),
          child:
              BlocBuilder<
                GameCubit<C, TCell, TMove, TState>,
                GameScreenState<C, TState>
              >(
                builder: (context, screen) => switch (screen) {
                  GameLoading() => _Message(texts.gameLoading),
                  GameNotStarted() => _Message(texts.gameNotStarted),
                  GameReady(:final state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(title: titleOf(texts), accent: accent),
                      const SizedBox(height: AppSizes.gapLarge),
                      _Marker(label: texts.scoreLabel, value: state.score),
                      const SizedBox(height: AppSizes.gapLarge),
                      Expanded(
                        child: Semantics(
                          label: texts.boardLabel,
                          child: _Panel(
                            bordered: true,
                            child: BoardView<C, TCell>(
                              board: state.board,
                              layout: layout,
                              painter: cellPainter,
                            ),
                          ),
                        ),
                      ),
                      if (trayOf case final trayOf?) ...[
                        const SizedBox(height: AppSizes.gapLarge),
                        Semantics(
                          label: texts.trayLabel,
                          child: _Panel(child: trayOf(context, state)),
                        ),
                      ],
                      if (actionsOf case final actionsOf?) ...[
                        const SizedBox(height: AppSizes.gapLarge),
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
      const SizedBox(width: AppSizes.gapSmall),
      Text(title, style: AppTextStyles.title),
    ],
  );
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
        Text(label, style: AppTextStyles.markerLabel),
        Text('$value', style: AppTextStyles.markerValue),
      ],
    ),
  );
}

final class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.bordered = false});

  final Widget child;
  final bool bordered;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      border: bordered
          ? Border.all(color: AppColors.ink, width: AppSizes.borderWidth)
          : null,
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSizes.gapMedium),
      child: child,
    ),
  );
}

final class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(child: Text(text));
}
