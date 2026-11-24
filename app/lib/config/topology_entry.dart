import 'package:hexa_engine/hexa_engine.dart';

import '../adapters/mappers/lines_config_mapper.dart';
import '../frameworks/ui/board/topology_layout.dart';

/// A cell shape the app offers: the topology, the layout that draws it and
/// how the configuration writes its cells (ARQ-02 §3.1, D-29).
///
/// The registry keeps entries as `TopologyEntry<Coord>`; [accept] hands the
/// entry to a visitor with its real `C`, so the game opens typed end to end
/// without a `switch` or a cast (Visitor, ARQ-A-09).
final class TopologyEntry<C extends Coord> {
  /// The entry of [topology], drawn by [layout], whose cells the
  /// configuration writes as [coordOf] reads them.
  const TopologyEntry(this.topology, this.layout, this.coordOf);

  /// The topology.
  final GridTopology<C> topology;

  /// Where each cell is drawn and which cell a point falls on.
  final TopologyLayout<C> layout;

  /// Reads a cell of the configuration files (`[q, r]` for hexagons).
  final CoordOf<C> coordOf;

  /// Calls `visitor.visit<C>(this)` with the real coordinate type.
  R accept<R>(TopologyEntryVisitor<R> visitor) => visitor.visit<C>(this);
}

/// Something done with a topology entry once its `C` is known.
abstract interface class TopologyEntryVisitor<R> {
  /// Does it with [entry], whose coordinates are `C`.
  R visit<C extends Coord>(TopologyEntry<C> entry);
}
