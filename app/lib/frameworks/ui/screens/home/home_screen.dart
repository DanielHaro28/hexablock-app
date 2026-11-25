import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../adapters/presentation/home/home_cubit.dart';
import '../../../../adapters/presentation/home/home_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/hexa_colors.dart';
import '../../../theme/hexa_metrics.dart';
import '../../../theme/hexa_typography.dart';
import '../../components/hexa_abi.dart';
import '../../components/hexa_icon.dart';
import '../../components/hexa_menu.dart';
import '../../components/hexa_top_bar.dart';
import '../../components/hexa_variant_card.dart';
import '../../navigation/app_navigator.dart';
import '../../navigation/app_route.dart';
import 'home_game.dart';

/// The home screen (NAV-01): the suite's name, settings and one card per
/// game of the catalog. A game without levels opens a new game; one with
/// levels opens its level selection (RN-COM-02). The account and
/// leaderboard buttons arrive with NAV-06 and NAV-07 (D-154).
///
/// It reads the footers from the [HomeCubit] in its context and reads them
/// again when the player comes back, since a game may leave a new record.
class HomeScreen extends StatelessWidget {
  /// The home screen of [games], moving with [navigator].
  const HomeScreen({required this.games, required this.navigator, super.key});

  /// The games, in the order of their cards.
  final List<HomeGame> games;

  /// Opens the other screens.
  final AppNavigator navigator;

  Future<void> _open(BuildContext context, AppRoute route) async {
    final cubit = context.read<HomeCubit>();
    await navigator.push(context, route);
    if (!cubit.isClosed) await cubit.load();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) => HomeView(
      games: games,
      state: state,
      onSettings: () => _open(context, const SettingsRoute()),
      onPlay: (game) => _open(
        context,
        game.byLevels ? LevelSelectRoute(game.gameId) : GameRoute(game.gameId),
      ),
      // NAV-04 resumes a saved game, paused; until then no card offers it.
      onContinue: (game) => _open(context, GameRoute(game.gameId)),
    ),
  );
}

/// What the home screen draws for a [state]: separate from [HomeScreen] so
/// each state can be shown and tested on its own.
class HomeView extends StatelessWidget {
  /// The home screen of [games] in [state].
  const HomeView({
    required this.games,
    required this.state,
    required this.onSettings,
    required this.onPlay,
    required this.onContinue,
    super.key,
  });

  /// The games, in the order of their cards.
  final List<HomeGame> games;

  /// What the footers say.
  final HomeState state;

  /// Opens the settings.
  final VoidCallback onSettings;

  /// Starts [game]: a new game, or its level selection.
  final void Function(HomeGame game) onPlay;

  /// Resumes the saved game of [game].
  final void Function(HomeGame game) onContinue;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final colors = HexaColors.of(context);
    return ColoredBox(
      color: colors.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HexaTopBar(
              trailing: HexaTopBarAction(
                icon: HexaIconName.settings,
                label: texts.homeSettings,
                onPressed: onSettings,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  HexaSpacing.s16,
                  0,
                  HexaSpacing.s16,
                  HexaSpacing.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: HexaAbi(
                        pose: AbiPose.wave,
                        label: texts.homeAbiLabel,
                      ),
                    ),
                    const SizedBox(height: HexaSpacing.s8),
                    Semantics(
                      header: true,
                      child: Text(
                        texts.appTitle,
                        textAlign: TextAlign.center,
                        style: HexaTypography.display,
                      ),
                    ),
                    const SizedBox(height: HexaSpacing.s8),
                    Text(
                      texts.homeTagline,
                      textAlign: TextAlign.center,
                      style: HexaTypography.body.copyWith(
                        color: colors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: HexaSpacing.s24),
                    Semantics(
                      header: true,
                      child: Text(
                        texts.homeChooseGame,
                        style: HexaTypography.label.copyWith(
                          color: colors.inkSoft,
                        ),
                      ),
                    ),
                    const SizedBox(height: HexaSpacing.s12),
                    _Grid(
                      children: [for (final game in games) _card(texts, game)],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(AppLocalizations texts, HomeGame game) {
    final title = game.titleOf(texts);
    final status = switch (state) {
      HomeReady() && final ready => ready.statusOf(game.gameId),
      HomeLoading() => null,
    };
    final saved = status is HomeSavedGame;
    return HexaVariantCard(
      title: title,
      description: game.descriptionOf(texts),
      artwork: game.artwork,
      onTap: () => saved ? onContinue(game) : onPlay(game),
      footer: switch (status) {
        null || HomeUnknownStatus() => null,
        HomeNewGame() => HexaCardNew(texts.homeNew),
        HomeRecord(:final score) => HexaCardMeta(
          texts.homeRecord(_grouped(score, texts.homeNumberGroupSeparator)),
        ),
        HomeSavedGame() => HexaCardMeta(
          texts.homeContinue,
          icon: HexaIconName.play,
        ),
      },
      menu: saved
          ? HexaMenu(
              label: texts.homeMoreOptions(title),
              elevated: false,
              align: _isStartColumn(game)
                  ? HexaMenuAlign.start
                  : HexaMenuAlign.end,
              items: [
                HexaMenuItem(
                  label: texts.homeNewGame,
                  icon: HexaIconName.retry,
                  onSelected: () => onPlay(game),
                ),
              ],
            )
          : null,
    );
  }

  /// Cards in the start column open their menu towards the end (Menu.md).
  bool _isStartColumn(HomeGame game) =>
      games.indexOf(game) % _Grid.columns == 0;

  /// [value] with its thousands grouped by [separator] («12 850»).
  static String _grouped(int value, String separator) {
    final digits = '$value';
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(separator);
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

/// Two columns of cards; the cards of a row share the tallest height, so a
/// longer text in English grows the whole row and never cuts it.
final class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  /// The cards of a row: two at every width from 360 (README, «Tamaños de
  /// pantalla»).
  static const columns = 2;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var row = 0; row < children.length; row += columns) ...[
        if (row > 0) const SizedBox(height: HexaSpacing.s8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[row]),
              const SizedBox(width: HexaSpacing.s8),
              Expanded(
                child: row + 1 < children.length
                    ? children[row + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}
