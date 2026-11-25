import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import '../adapters/mappers/lines_config_mapper.dart';
import '../adapters/presentation/game/game_cubit.dart';
import '../adapters/repositories/memory_saved_game_repository.dart';
import '../frameworks/ui/hexa_lines/lines_game_screen.dart';
import 'topology_entry.dart';
import 'variant_module.dart';

/// Hexa Lines in the app: its configuration, its factory, its use cases and
/// its screen (ARQ-02 §3.1). Its record is kept in the app's progress
/// repository, dated by the app's clock (RN-HL-70, 71).
final class HexaLinesModule implements VariantModule {
  /// The module, with the decoded `assets/config/hexa-lines.json`, keeping
  /// its record for the active profile of [_profiles] in [_progress] with the
  /// dates of [_clock].
  const HexaLinesModule(
    this._config,
    this._progress,
    this._profiles,
    this._clock,
  );

  /// The `gameId` of Hexa Lines in the contract.
  static const id = 'hexa-lines';

  /// The asset with the board and the catalog per topology (D-132).
  static const configAsset = 'assets/config/hexa-lines.json';

  final Map<String, Object?> _config;
  final IProgressRepository _progress;
  final IProfileRepository _profiles;
  final IClock _clock;

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
    // In memory until NAV-04 brings Drift saved_games + codec (D-136, D-154).
    final savedGames = MemorySavedGameRepository<LinesState<C>>();
    return BlocProvider(
      create: (_) => GameCubit<C, PieceColor, PlacePiece<C>, LinesState<C>>(
        startGame: ErrorHandlingAspect(
          StartGameUseCase(family, savedGames, key),
        ),
        options: options,
        applyMoveFor: (session) =>
            ErrorHandlingAspect(ApplyMoveUseCase(session, savedGames, key)),
        checkMoveFor: (session) =>
            ErrorHandlingAspect(CheckMoveUseCase(session)),
        record: RecordUseCases(
          game: key.game,
          getProgress: ErrorHandlingAspect(
            GetProgressUseCase(_progress, _profiles),
          ),
          saveProgress: ErrorHandlingAspect(
            SaveProgressUseCase(_progress, _profiles, _clock),
          ),
        ),
      )..start(),
      child: LinesGameScreen<C>(layout: entry.layout),
    );
  }
}
