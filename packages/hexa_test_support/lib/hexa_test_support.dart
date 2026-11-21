/// Hand-written test doubles shared by every package (D-56).
///
/// In-memory repositories, a fake clock, seeded randomness, a gateway that
/// answers with the contract examples and the contract test every topology
/// must pass (`checkTopologyContract`). Only ever a `dev_dependency`.
library;

export 'src/engine/fake_cell.dart';
export 'src/engine/fake_coord.dart';
export 'src/engine/fake_topology.dart';
export 'src/engine/topology_contract.dart';
