import 'package:flutter/widgets.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';

import 'topology_entry.dart';

/// What a variant registers in the app (ARQ-02 §3.1, EXTENSIBILITY.md): it
/// knows the variant's concrete types and, given a cell shape, wires its
/// factory, the use cases of the game, the `GameCubit` and its painters.
///
/// A fifth variant is a new module registered in `registerDependencies`;
/// nothing else in the app changes.
abstract interface class VariantModule {
  /// The `gameId` of the contract, such as `hexa-lines`.
  String get gameId;

  /// The game screen of this variant on [entry]'s cell shape, started with
  /// [options].
  Widget open<C extends Coord>(TopologyEntry<C> entry, StartOptions options);
}

/// Opens [module]'s game on the visited topology (ARQ-02 §3.1).
final class OpenGame implements TopologyEntryVisitor<Widget> {
  /// Opens [module] with [options].
  const OpenGame(this.module, this.options);

  /// The variant to open.
  final VariantModule module;

  /// How the game starts.
  final StartOptions options;

  @override
  Widget visit<C extends Coord>(TopologyEntry<C> entry) =>
      module.open<C>(entry, options);
}
