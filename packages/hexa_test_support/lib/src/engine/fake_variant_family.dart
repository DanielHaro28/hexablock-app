import 'package:hexa_engine/hexa_engine.dart';

import 'fake_cell.dart';
import 'fake_coord.dart';
import 'fake_rules.dart';
import 'fake_topology.dart';

/// A variant family over [FakeRules] for the use case tests (D-56).
///
/// A new game is an empty board of [width] × 1 cells; a saved game comes
/// back paused (D-111). It records what it was asked for in [newGames] and
/// [continued], so a test can tell which of the two a use case called.
///
/// With [levels] it is played by levels, like Fit and Sort (D-125): the
/// catalog maps each level id to its board width, a new game looks up
/// `NewGameOptions.levelId` there and its state is a [FakeLevelState]; a
/// missing or unknown id throws an [ArgumentError]. Without [levels] it
/// ignores `levelId`.
final class FakeVariantFamily
    implements VariantFamily<FakeCoord, FakeCell, FakeMove, FakeState> {
  /// A family whose games have [width] cells, or the width of their level
  /// in [levels], and are played with the rules that [rules] builds (by
  /// default, plain [FakeRules]).
  FakeVariantFamily({this.width = 3, this.levels, FakeRules Function()? rules})
    : _rules = rules ?? FakeRules.new;

  /// The number of cells of a new board when the game is not played by
  /// levels.
  final int width;

  /// The level catalog, from level id to board width, or `null` if the
  /// game is not played by levels.
  final Map<String, int>? levels;

  final FakeRules Function() _rules;

  /// The options of every new game, in order.
  final List<NewGameOptions> newGames = [];

  /// The saved games that were continued, in order.
  final List<SavedGame<FakeState>> continued = [];

  @override
  FakeRules createRules() => _rules();

  @override
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> createSession(
    NewGameOptions options,
  ) {
    newGames.add(options);
    return GameSession(GameEngine(createRules(), _initialState(options)));
  }

  FakeState _initialState(NewGameOptions options) {
    final catalog = levels;
    if (catalog == null) return FakeState(_board(width));
    final levelId = options.levelId;
    final levelWidth = catalog[levelId];
    if (levelId == null || levelWidth == null) {
      throw ArgumentError.value(levelId, 'levelId', 'not in the catalog');
    }
    return FakeLevelState(_board(levelWidth), levelId: levelId);
  }

  Board<FakeCoord, FakeCell> _board(int cells) =>
      Board.of(const FakeTopology(), ShapeSpec('rectangle', [cells, 1]));

  @override
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> continueSession(
    SavedGame<FakeState> saved,
  ) {
    continued.add(saved);
    return GameSession(GameEngine.paused(createRules(), saved.state));
  }
}
