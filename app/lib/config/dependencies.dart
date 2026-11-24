import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';

import '../frameworks/ui/board/hex_layout.dart';
import 'hexa_lines_module.dart';
import 'topology_entry.dart';
import 'variant_module.dart';

/// The cell shapes the app offers, by topology id (D-29).
typedef TopologyRegistry = Map<String, TopologyEntry<Coord>>;

/// The variants the app offers, by `gameId`.
typedef VariantRegistry = Map<String, VariantModule>;

/// Draws the seed of a new game when the player gives none (RN-COM-45).
typedef SeedSource = int Function();

/// The cell shape of a new game until NAV-08 lets the player choose one:
/// hexagons (RN-TOP-30).
const defaultTopology = 'hex';

/// Registers what the app needs at startup in [getIt] (ARQ-03 §6): the
/// topologies with their layouts, the variant modules with their
/// configuration read from [bundle], and the [newSeed] source (by default,
/// a secure random seed).
Future<void> registerDependencies(
  GetIt getIt,
  AssetBundle bundle, {
  SeedSource? newSeed,
}) async {
  final linesConfig = await _json(bundle, HexaLinesModule.configAsset);
  getIt
    ..registerSingleton<TopologyRegistry>({
      // The type argument is required: inside this map, Dart would infer
      // TopologyEntry<Coord> and the game would open with C = Coord.
      'hex': const TopologyEntry<HexCoord>(
        HexTopology(),
        HexLayout(),
        _hexCoord,
      ),
    })
    ..registerSingleton<VariantRegistry>({
      HexaLinesModule.id: HexaLinesModule(linesConfig),
    })
    ..registerSingleton<SeedSource>(newSeed ?? _secureSeed);
}

/// The screen of a new game of [gameId] on the default cell shape.
///
/// Until NAV-01, `main` opens Hexa Lines with it directly (D-136); then the
/// home screen calls it from the game cards.
Widget openGame(GetIt getIt, String gameId) {
  final entry = getIt<TopologyRegistry>()[defaultTopology]!;
  final module = getIt<VariantRegistry>()[gameId]!;
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
