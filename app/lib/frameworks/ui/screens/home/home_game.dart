import '../../../l10n/app_localizations.dart';

/// Reads one localized text of a game.
typedef GameText = String Function(AppLocalizations texts);

/// How a game appears on the home screen (NAV-01): what the catalog of the
/// composition root says about it, so the screen only walks a list and a
/// fifth variant is one more entry (EXTENSIBILITY.md).
final class HomeGame {
  /// The card of [gameId].
  const HomeGame({
    required this.gameId,
    required this.byLevels,
    required this.artwork,
    required this.titleOf,
    required this.descriptionOf,
  });

  /// The `gameId` of the contract.
  final String gameId;

  /// Whether the game is played by levels (RN-COM-02): its card opens the
  /// level selection instead of a new game.
  final bool byLevels;

  /// The asset of its SVG, with its colored blob.
  final String artwork;

  /// Its name.
  final GameText titleOf;

  /// One short sentence about it.
  final GameText descriptionOf;
}
