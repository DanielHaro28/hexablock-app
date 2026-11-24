import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexablock_app/config/registries.dart';
import 'package:hexablock_app/config/topology_entry.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';

/// Tells the coordinate type an entry is visited with.
final class _CoordType implements TopologyEntryVisitor<Type> {
  const _CoordType();

  @override
  Type visit<C extends Coord>(TopologyEntry<C> entry) => C;
}

HexCoord _hex(List<int> cell) => HexCoord(cell[0], cell[1]);

void main() {
  group('ARQ-02 §3.1', () {
    test('should_visit_with_the_real_coordinate_when_added_without_a_type', () {
      // Arrange
      final registry = TopologyRegistry()
        ..add(const TopologyEntry(HexTopology(), HexLayout(), _hex));

      // Act
      final type = registry['hex'].accept(const _CoordType());

      // Assert
      expect(type, HexCoord);
    });

    test('should_throw_a_state_error_when_the_topology_is_not_registered', () {
      // Arrange
      final registry = TopologyRegistry();

      // Act
      TopologyEntry<Coord> find() => registry['square'];

      // Assert
      expect(find, throwsStateError);
    });

    test('should_throw_a_state_error_when_a_topology_is_added_twice', () {
      // Arrange
      final registry = TopologyRegistry()
        ..add(const TopologyEntry(HexTopology(), HexLayout(), _hex));

      // Act
      void addAgain() =>
          registry.add(const TopologyEntry(HexTopology(), HexLayout(), _hex));

      // Assert
      expect(addAgain, throwsStateError);
    });

    test('should_throw_a_state_error_when_the_variant_is_not_registered', () {
      // Arrange
      final registry = VariantRegistry();

      // Act
      void find() => registry['hexa-x'];

      // Assert
      expect(find, throwsStateError);
    });
  });
}
