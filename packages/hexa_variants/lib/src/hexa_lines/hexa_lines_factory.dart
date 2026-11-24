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
  /// [LinesPieceSource.totalWeight].
  HexaLinesFactory(this._topology, this._config)
    : _source = LinesPieceSource(_topology, _config.catalog);

  final GridTopology<C> _topology;
  final LinesConfig<C> _config;
  final LinesPieceSource<C> _source;

  @override
  HexaLinesRules<C> createRules() => HexaLinesRules<C>();

  /// An empty board (RN-HL-10, 11) and a tray of pieces drawn from
  /// `options.seed` (RN-HL-20, RN-COM-41).
  @override
  GameSession<C, PieceColor, PlacePiece<C>, LinesState<C>> createSession(
    NewGameOptions options,
  ) {
    var random = Xorshift32(options.seed);
    final tray = <LinesPiece<C>>[];
    for (var i = 0; i < LinesState.traySize; i++) {
      final (piece, after) = _source.next(random);
      tray.add(piece);
      random = after;
    }
    final state = LinesState(
      board: Board<C, PieceColor>.of(_topology, _config.board),
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
