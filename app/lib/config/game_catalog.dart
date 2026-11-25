import '../frameworks/ui/screens/home/home_game.dart';
import 'hexa_lines_module.dart';

/// The four games of the suite, in the order of their home cards
/// (RN-COM-01), and whether each is played by levels (RN-COM-02).
///
/// The home screen only walks this list: a fifth variant is one more entry
/// here and its module in `registerDependencies` (EXTENSIBILITY.md). A game
/// whose module is not registered yet opens a temporary screen (`pageFor`).
final List<HomeGame> gameCatalog = List.unmodifiable([
  HomeGame(
    gameId: HexaLinesModule.id,
    byLevels: false,
    artwork: 'assets/games/hexa-lines.svg',
    titleOf: (texts) => texts.gameTitleHexaLines,
    descriptionOf: (texts) => texts.gameDescriptionHexaLines,
  ),
  HomeGame(
    gameId: 'hexa-fit',
    byLevels: true,
    artwork: 'assets/games/hexa-fit.svg',
    titleOf: (texts) => texts.gameTitleHexaFit,
    descriptionOf: (texts) => texts.gameDescriptionHexaFit,
  ),
  HomeGame(
    gameId: 'hexa-sort',
    byLevels: true,
    artwork: 'assets/games/hexa-sort.svg',
    titleOf: (texts) => texts.gameTitleHexaSort,
    descriptionOf: (texts) => texts.gameDescriptionHexaSort,
  ),
  HomeGame(
    gameId: 'hexa-merge',
    byLevels: false,
    artwork: 'assets/games/hexa-merge.svg',
    titleOf: (texts) => texts.gameTitleHexaMerge,
    descriptionOf: (texts) => texts.gameDescriptionHexaMerge,
  ),
]);
