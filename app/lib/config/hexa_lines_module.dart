import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../adapters/mappers/lines_config_mapper.dart';
import '../adapters/presentation/game/game_cubit.dart';
import '../adapters/repositories/memory_saved_game_repository.dart';
import '../frameworks/theme/app_colors.dart';
import '../frameworks/ui/game/game_page.dart';
import '../frameworks/ui/hexa_lines/lines_cell_painter.dart';
import '../frameworks/ui/hexa_lines/lines_tray.dart';
import 'topology_entry.dart';
import 'variant_module.dart';

/// Hexa Lines in the app: its configuration, its factory, its painter and
/// its tray (ARQ-02 §3.1).
final class HexaLinesModule implements VariantModule {
  /// The module, with the decoded `assets/config/hexa-lines.json`.
  const HexaLinesModule(this._config);

  /// The `gameId` of Hexa Lines in the contract.
  static const id = 'hexa-lines';

  /// The asset with the board and the catalog per topology (D-132).
  static const configAsset = 'assets/config/hexa-lines.json';

  final Map<String, Object?> _config;

  @override
  String get gameId => id;

  @override
  Widget open<C extends Coord>(TopologyEntry<C> entry, StartOptions options) {
    final config = const LinesConfigMapper().fromJson(
      _config,
      entry.topology.id,
      entry.coordOf,
    );
    final family = HexaLinesFactory<C>(entry.topology, config);
    final key = SavedGameKey(
      ProfileId.guest,
      GameKey(gameId, entry.topology.id),
    );
    // In memory until PRG-03 brings Drift (D-136).
    final savedGames = MemorySavedGameRepository<LinesState<C>>();
    return BlocProvider(
      create: (_) => GameCubit<C, PieceColor, PlacePiece<C>, LinesState<C>>(
        startGame: ErrorHandlingAspect(
          StartGameUseCase(family, savedGames, key),
        ),
        options: options,
        applyMoveFor: (session) =>
            ErrorHandlingAspect(ApplyMoveUseCase(session, savedGames, key)),
      )..start(),
      child: GamePage<C, PieceColor, PlacePiece<C>, LinesState<C>>(
        titleOf: (texts) => texts.gameTitleHexaLines,
        accent: AppColors.hexaLines,
        layout: entry.layout,
        cellPainter: const LinesCellPainter(),
        trayOf: (context, state) =>
            LinesTray<C>(tray: state.tray, layout: entry.layout),
      ),
    );
  }
}
