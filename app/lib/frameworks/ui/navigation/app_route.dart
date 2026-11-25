/// The screens of the app and what each one needs to open (D-149).
///
/// A closed set: the composition root builds each one with an exhaustive
/// `switch`, so a new screen that is not built does not compile. Pause,
/// victory, defeat and leave are sheets over the game, not routes.
sealed class AppRoute {
  const AppRoute();
}

/// The home screen, the first one (NAV-01).
final class HomeRoute extends AppRoute {
  /// The home screen.
  const HomeRoute();

  @override
  bool operator ==(Object other) => other is HomeRoute;

  @override
  int get hashCode => (HomeRoute).hashCode;
}

/// A new game of [gameId], for a game without levels (RN-COM-02).
final class GameRoute extends AppRoute {
  /// A new game of [gameId].
  const GameRoute(this.gameId);

  /// The `gameId` of the contract.
  final String gameId;

  @override
  bool operator ==(Object other) =>
      other is GameRoute && other.gameId == gameId;

  @override
  int get hashCode => gameId.hashCode;
}

/// The level selection of [gameId], for a game with levels (RN-COM-02).
final class LevelSelectRoute extends AppRoute {
  /// The levels of [gameId].
  const LevelSelectRoute(this.gameId);

  /// The `gameId` of the contract.
  final String gameId;

  @override
  bool operator ==(Object other) =>
      other is LevelSelectRoute && other.gameId == gameId;

  @override
  int get hashCode => gameId.hashCode;
}

/// The settings (NAV-02).
final class SettingsRoute extends AppRoute {
  /// The settings.
  const SettingsRoute();

  @override
  bool operator ==(Object other) => other is SettingsRoute;

  @override
  int get hashCode => (SettingsRoute).hashCode;
}
