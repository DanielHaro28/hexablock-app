import 'package:hexa_engine/hexa_engine.dart';

import 'topology_entry.dart';
import 'variant_module.dart';

/// The cell shapes the app offers, by topology id (D-29).
///
/// [add] is generic, so Dart takes `C` from the entry itself: an entry can
/// never be kept as a `TopologyEntry<Coord>` by mistake, which would open
/// the game with `C = Coord` and fail at run time (ARQ-02, covariance).
final class TopologyRegistry {
  final Map<String, TopologyEntry<Coord>> _entries = {};

  /// Registers [entry] under its topology's id.
  ///
  /// Throws a [StateError] if that id is already registered.
  void add<C extends Coord>(TopologyEntry<C> entry) {
    final id = entry.topology.id;
    if (_entries.containsKey(id)) {
      throw StateError('topology $id is already registered');
    }
    _entries[id] = entry;
  }

  /// The entry of the topology [id].
  ///
  /// Throws a [StateError] if it is not registered.
  TopologyEntry<Coord> operator [](String id) =>
      _entries[id] ?? (throw StateError('no topology registered as $id'));

  /// The ids of the registered topologies, in registration order.
  Iterable<String> get ids => _entries.keys;
}

/// The variants the app offers, by `gameId`.
final class VariantRegistry {
  final Map<String, VariantModule> _modules = {};

  /// Registers [module] under its `gameId`.
  ///
  /// Throws a [StateError] if that `gameId` is already registered.
  void add(VariantModule module) {
    final id = module.gameId;
    if (_modules.containsKey(id)) {
      throw StateError('variant $id is already registered');
    }
    _modules[id] = module;
  }

  /// The module of [gameId].
  ///
  /// Throws a [StateError] if it is not registered.
  VariantModule operator [](String gameId) =>
      _modules[gameId] ??
      (throw StateError('no variant registered as $gameId'));

  /// Whether [gameId] has a registered module.
  bool contains(String gameId) => _modules.containsKey(gameId);
}
