import 'coord.dart';
import 'grid_topology.dart';

/// Visitor over topologies that recovers the real coordinate type (D-29).
///
/// The player picks the cell shape at runtime (D-25), so the composition root
/// keeps topologies in a registry as `GridTopology<Coord>`. Calling
/// `topology.accept(visitor)` runs `visitor.visit<C>(topology)` with the real
/// `C` (Dart generics are reified), so the visitor can build a typed
/// `Board<C, TCell>` or `GameEngine<C, …>` without a `switch` or a cast.
///
/// Only `accept` is called on a stored topology; every geometric operation
/// happens inside the visitor, where `C` is concrete (ARQ-02 §11).
abstract interface class TopologyVisitor<R> {
  /// Called once with the visited topology and its coordinate type.
  R visit<C extends Coord>(GridTopology<C> topology);
}
