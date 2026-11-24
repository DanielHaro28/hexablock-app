import 'package:hexa_engine/hexa_engine.dart';

import 'hexa_lines_rules.dart';
import 'lines_piece.dart';
import 'lines_piece_source.dart';
import 'lines_state.dart';

/// The family of Hexa Lines (Abstract Factory, D-35, D-100): its rules, its
/// piece source and its sessions, for any cell shape (D-25).
///
/// A game is endless, has no undo (RN-HL-80) and no timer, so its session
/// is the engine alone (D-33).
final class HexaLinesFactory<C extends Coord>
    implements VariantFamily<C, PieceColor, PlacePiece<C>, LinesState<C>> {
  /// The factory for [topology] with its [config] (D-132).
  ///
  /// Throws an [ArgumentError] if the catalog weights do not add up to
  /// [LinesPieceSource.totalWeight] or [topology] does not know the board
  /// shape, so a bad configuration fails where the factory is registered.
  HexaLinesFactory(GridTopology<C> topology, LinesConfig<C> config)
    : _source = LinesPieceSource(topology, config.catalog),
      _emptyBoard = Board.of(topology, config.board);

  final IPieceSource<LinesPiece<C>> _source;
  final Board<C, PieceColor> _emptyBoard;

  /// Not `const`: a constant cannot use the type variable `C`, so Dart
  /// would infer `HexaLinesRules<Never>`, which covariance lets through and
  /// fails only when a state is passed in.
  @override
  HexaLinesRules<C> createRules() => HexaLinesRules<C>();

  /// An empty board (RN-HL-10, 11) and a tray of pieces drawn from
  /// `options.seed` (RN-HL-20, RN-COM-41).
  @override
  GameSession<C, PieceColor, PlacePiece<C>, LinesState<C>> createSession(
    NewGameOptions options,
  ) {
    final (tray, random) = drawTray(
      _source,
      Xorshift32(options.seed),
      LinesState.traySize,
    );
    final state = LinesState(
      board: _emptyBoard,
      tray: tray,
      random: random,
      seed: options.seed,
    );
    return GameSession(GameEngine(createRules(), state));
  }

  /// The saved game, paused until the player resumes it (D-111, RN-COM-34).
  @override
  GameSession<C, PieceColor, PlacePiece<C>, LinesState<C>> continueSession(
    SavedGame<LinesState<C>> saved,
  ) => GameSession(GameEngine.paused(createRules(), saved.state));
}
