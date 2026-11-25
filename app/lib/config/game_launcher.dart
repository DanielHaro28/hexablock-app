import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'registries.dart';
import 'variant_module.dart';

/// Draws the seed of a new game when the player gives none (RN-COM-45).
typedef SeedSource = int Function();

/// The cell shape of a new game until NAV-08 lets the player choose one:
/// hexagons (RN-TOP-30).
const defaultTopology = 'hex';

/// The screen of a new game of [gameId] on the default cell shape, with
/// what `registerDependencies` registered in [getIt].
///
/// The home screen opens it from the card of a game without levels
/// (NAV-01), through `pageFor`.
Widget openGame(GetIt getIt, String gameId) {
  final entry = getIt<TopologyRegistry>()[defaultTopology];
  final module = getIt<VariantRegistry>()[gameId];
  final options = StartNew(NewGameOptions(seed: getIt<SeedSource>()()));
  return entry.accept(OpenGame(module, options));
}
