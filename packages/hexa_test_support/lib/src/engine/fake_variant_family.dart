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
final class FakeVariantFamily
    implements VariantFamily<FakeCoord, FakeCell, FakeMove, FakeState> {
  /// A family whose games have [width] cells and are played with the rules
  /// that [rules] builds (by default, plain [FakeRules]).
  FakeVariantFamily({this.width = 3, FakeRules Function()? rules})
    : _rules = rules ?? FakeRules.new;

  /// The number of cells of a new board.
  final int width;

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
    final board = Board<FakeCoord, FakeCell>.of(
      const FakeTopology(),
      ShapeSpec('rectangle', [width, 1]),
    );
    return GameSession(GameEngine(createRules(), FakeState(board)));
  }

  @override
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> continueSession(
    SavedGame<FakeState> saved,
  ) {
    continued.add(saved);
    return GameSession(GameEngine.paused(createRules(), saved.state));
  }
}
