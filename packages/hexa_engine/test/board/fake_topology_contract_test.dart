import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// The engine's own doubles pass the same contract as every real topology,
/// so a test that relies on them relies on nothing a real one would not do.
void main() {
  final rectangle = ShapeSpec(FakeTopology.rectangle, const [4, 3]);

  group('contract (RN-COM-10 to 17), FakeTopology', () {
    checkTopologyContract(const FakeTopology(), rectangle);
  });

  group('contract (RN-COM-10 to 17), FakeCheckeredTopology', () {
    checkTopologyContract(const FakeCheckeredTopology(), rectangle);
  });
}
