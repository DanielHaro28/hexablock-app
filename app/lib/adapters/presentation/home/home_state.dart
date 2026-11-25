/// What the home screen shows (NAV-01): one card per game, in the order of
/// the catalog, with what its footer says (D-155).
library;

/// What the footer of a game's card says.
sealed class HomeCardStatus {
  const HomeCardStatus();
}

/// The game has no progress yet: «Nuevo» / «New».
final class HomeNewGame extends HomeCardStatus {
  /// A game never played.
  const HomeNewGame();

  @override
  bool operator ==(Object other) => other is HomeNewGame;

  @override
  int get hashCode => (HomeNewGame).hashCode;
}

/// The game keeps a record: «Récord 12 850» / «Best 12,850».
final class HomeRecord extends HomeCardStatus {
  /// A record of [score].
  const HomeRecord(this.score);

  /// The best score.
  final int score;

  @override
  bool operator ==(Object other) => other is HomeRecord && other.score == score;

  @override
  int get hashCode => score.hashCode;
}

/// The game has a saved game: «Continuar», with «Nueva partida» in its menu
/// (DIS-11). The screen draws it; NAV-04 brings the saved game it comes
/// from, so the presenter does not produce it yet.
final class HomeSavedGame extends HomeCardStatus {
  /// A game that can be continued.
  const HomeSavedGame();

  @override
  bool operator ==(Object other) => other is HomeSavedGame;

  @override
  int get hashCode => (HomeSavedGame).hashCode;
}

/// The progress could not be read: the footer says nothing, and the game
/// can still be played (RNF-35).
final class HomeUnknownStatus extends HomeCardStatus {
  /// Progress that could not be read.
  const HomeUnknownStatus();

  @override
  bool operator ==(Object other) => other is HomeUnknownStatus;

  @override
  int get hashCode => (HomeUnknownStatus).hashCode;
}

/// The state of the home screen.
sealed class HomeState {
  const HomeState();
}

/// The progress is being read: the cards show no footer yet.
final class HomeLoading extends HomeState {
  /// While loading.
  const HomeLoading();

  @override
  bool operator ==(Object other) => other is HomeLoading;

  @override
  int get hashCode => (HomeLoading).hashCode;
}

/// The footer of every game, by `gameId`.
final class HomeReady extends HomeState {
  /// The [statuses] of the games.
  const HomeReady(this.statuses);

  /// What each game's footer says, by `gameId`.
  final Map<String, HomeCardStatus> statuses;

  /// The status of [gameId], or `null` if the presenter does not know it.
  HomeCardStatus? statusOf(String gameId) => statuses[gameId];

  @override
  bool operator ==(Object other) =>
      other is HomeReady &&
      other.statuses.length == statuses.length &&
      statuses.entries.every((e) => other.statuses[e.key] == e.value);

  @override
  int get hashCode => Object.hashAllUnordered(
    statuses.entries.map((e) => Object.hash(e.key, e.value)),
  );

  @override
  String toString() => 'HomeReady($statuses)';
}
