import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';

import '../adapters/metrics/log_metrics.dart';
import '../frameworks/persistence/app_database.dart';
import '../frameworks/persistence/drift_profile_repository.dart';
import '../frameworks/persistence/drift_progress_repository.dart';
import '../frameworks/persistence/drift_unit_of_work.dart';
import '../frameworks/platform/platform_logger.dart';
import '../frameworks/platform/system_clock.dart';
import '../frameworks/ui/board/hex_layout.dart';
import 'hexa_lines_module.dart';
import 'registries.dart';
import 'topology_entry.dart';
import 'variant_module.dart';

/// Draws the seed of a new game when the player gives none (RN-COM-45).
typedef SeedSource = int Function();

/// The cell shape of a new game until NAV-08 lets the player choose one:
/// hexagons (RN-TOP-30).
const defaultTopology = 'hex';

/// Registers what the app needs at startup in [getIt] (ARQ-03 §6): the
/// topologies with their layouts, the clock, the log ([logger], by default
/// a [PlatformLogger]), the metrics and the [AspectChain] that wraps every
/// use case (D-161, D-163), the Drift database and its repositories
/// (`IProfileRepository`, `IProgressRepository`), the variant modules with
/// their configuration read from [bundle], and the [newSeed] source (by
/// default, a secure random seed).
///
/// The details of each use case are logged only in development builds
/// ([kDebugMode], SEC-MOB-05).
Future<void> registerDependencies(
  GetIt getIt,
  AssetBundle bundle, {
  SeedSource? newSeed,
  QueryExecutor? databaseExecutor,
  IClock? clock,
  ILogger? logger,
}) async {
  final linesConfig = await _json(bundle, HexaLinesModule.configAsset);
  final IClock appClock = clock ?? SystemClock();
  final ILogger appLogger = logger ?? PlatformLogger(verbose: kDebugMode);
  final IMetrics metrics = LogMetrics(appLogger);
  final chain = AspectChain(appLogger, metrics, appClock, verbose: kDebugMode);
  final database = databaseExecutor == null
      ? AppDatabase.open(clock: appClock)
      : AppDatabase(databaseExecutor, clock: appClock);
  final IProfileRepository profiles = DriftProfileRepository(database);
  final IProgressRepository progress = DriftProgressRepository(database);
  final IUnitOfWork unitOfWork = DriftUnitOfWork(database);
  getIt
    ..registerSingleton<IClock>(appClock)
    ..registerSingleton<ILogger>(appLogger)
    ..registerSingleton<IMetrics>(metrics)
    ..registerSingleton<AspectChain>(chain)
    ..registerSingleton<AppDatabase>(database, dispose: (db) => db.close())
    ..registerSingleton<IProfileRepository>(profiles)
    ..registerSingleton<IProgressRepository>(progress)
    ..registerSingleton<IUnitOfWork>(unitOfWork)
    ..registerSingleton(
      TopologyRegistry()
        ..add(const TopologyEntry(HexTopology(), HexLayout(), _hexCoord)),
    )
    ..registerSingleton(
      VariantRegistry()..add(
        HexaLinesModule(
          linesConfig,
          progress,
          profiles,
          appClock,
          unitOfWork,
          chain,
        ),
      ),
    )
    ..registerSingleton<SeedSource>(newSeed ?? _secureSeed);
}

/// The screen of a new game of [gameId] on the default cell shape.
///
/// Until NAV-01, `main` opens Hexa Lines with it directly (D-136); then the
/// home screen calls it from the game cards.
Widget openGame(GetIt getIt, String gameId) {
  final entry = getIt<TopologyRegistry>()[defaultTopology];
  final module = getIt<VariantRegistry>()[gameId];
  final options = StartNew(NewGameOptions(seed: getIt<SeedSource>()()));
  return entry.accept(OpenGame(module, options));
}

Future<Map<String, Object?>> _json(AssetBundle bundle, String asset) async =>
    switch (jsonDecode(await bundle.loadString(asset))) {
      final Map<String, Object?> json => json,
      _ => throw FormatException('expected a JSON object', asset),
    };

HexCoord _hexCoord(List<int> cell) => switch (cell) {
  [final q, final r] => HexCoord(q, r),
  _ => throw FormatException('expected [q, r]', cell),
};

int _secureSeed() => Random.secure().nextInt(Xorshift32.maxSeed + 1);
