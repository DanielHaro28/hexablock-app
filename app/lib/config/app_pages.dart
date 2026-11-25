import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:material_ui/material_ui.dart';

import '../adapters/presentation/home/home_cubit.dart';
import '../frameworks/l10n/app_localizations.dart';
import '../frameworks/ui/navigation/app_navigator.dart';
import '../frameworks/ui/navigation/app_route.dart';
import '../frameworks/ui/screens/home/home_game.dart';
import '../frameworks/ui/screens/home/home_screen.dart';
import '../frameworks/ui/screens/placeholder/placeholder_screen.dart';
import 'dependencies.dart';
import 'game_catalog.dart';
import 'registries.dart';

/// Builds the screen of each [route] (D-149): one exhaustive `switch`, so a
/// new route that is not built here does not compile.
///
/// Until their stories arrive, the level selection (HF-01, HS-01), a game
/// whose module is not registered (HM-01) and the settings (NAV-02) open a
/// [PlaceholderScreen].
Widget pageFor(GetIt getIt, AppRoute route) {
  final navigator = getIt<AppNavigator>();
  return switch (route) {
    HomeRoute() => BlocProvider(
      create: (_) => HomeCubit(
        gameIds: [for (final game in gameCatalog) game.gameId],
        topologyId: defaultTopology,
        // The guest until PRG-03 brings the profiles (D-142).
        getProgress: ErrorHandlingAspect(
          GetProgressUseCase(getIt<IProgressRepository>(), ProfileId.guest),
        ),
      )..load(),
      child: HomeScreen(games: gameCatalog, navigator: navigator),
    ),
    GameRoute(:final gameId) when getIt<VariantRegistry>().contains(gameId) =>
      openGame(getIt, gameId),
    GameRoute(:final gameId) || LevelSelectRoute(:final gameId) => _Placeholder(
      titleOf: _catalogTitle(gameId),
      navigator: navigator,
    ),
    SettingsRoute() => _Placeholder(
      titleOf: (texts) => texts.settingsTitle,
      navigator: navigator,
    ),
  };
}

GameText _catalogTitle(String gameId) =>
    gameCatalog.firstWhere((game) => game.gameId == gameId).titleOf;

/// A [PlaceholderScreen] with its localized title.
final class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.titleOf, required this.navigator});

  final GameText titleOf;
  final AppNavigator navigator;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: titleOf(AppLocalizations.of(context)),
    onBack: () => navigator.back(context),
  );
}
