import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';

import '../adapters/repositories/memory_progress_repository.dart';
import '../frameworks/platform/system_clock.dart';
import '../frameworks/ui/board/hex_layout.dart';
import '../frameworks/ui/navigation/app_navigator.dart';
import 'app_pages.dart';
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
/// topologies with their layouts, the clock, the progress repository (one
/// for the whole app, in memory until PRG-03, D-142), the variant modules
/// with their configuration read from [bundle], the [newSeed] source (by
/// default, a secure random seed) and the [AppNavigator], which builds each
/// screen with `pageFor` (D-149).
Future<void> registerDependencies(
  GetIt getIt,
  AssetBundle bundle, {
  SeedSource? newSeed,
}) async {
  final linesConfig = await _json(bundle, HexaLinesModule.configAsset);
  final IClock clock = SystemClock();
  final IProgressRepository progress = MemoryProgressRepository();
  getIt
    ..registerSingleton<IClock>(clock)
    ..registerSingleton<IProgressRepository>(progress)
    ..registerSingleton(
      TopologyRegistry()
        ..add(const TopologyEntry(HexTopology(), HexLayout(), _hexCoord)),
    )
    ..registerSingleton(
      VariantRegistry()..add(HexaLinesModule(linesConfig, progress, clock)),
    )
    ..registerSingleton<SeedSource>(newSeed ?? _secureSeed)
    ..registerSingleton(AppNavigator((route) => pageFor(getIt, route)));
}

/// The screen of a new game of [gameId] on the default cell shape.
///
/// The home screen opens it from the card of a game without levels
/// (NAV-01), through `pageFor`.
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
