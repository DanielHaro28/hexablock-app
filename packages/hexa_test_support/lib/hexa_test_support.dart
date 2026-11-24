/// Hand-written test doubles shared by every package (D-56).
///
/// In-memory repositories (`FakeSavedGameRepository`), a fake clock, seeded
/// randomness, a start use case on a given state (`StubStartGame`), a gateway that answers with the contract examples, the
/// contract test every topology must pass (`checkTopologyContract`), the one
/// every variant factory must pass (`checkVariantFamilyContract`), rules that
/// implement only the steps of a turn (`FakeRules`) and a variant family over
/// them (`FakeVariantFamily`). Only ever a `dev_dependency`.
library;

export 'src/application/fake_saved_game_repository.dart';
export 'src/application/stub_start_game.dart';
export 'src/engine/fake_cell.dart';
export 'src/engine/fake_clock.dart';
export 'src/engine/fake_coord.dart';
export 'src/engine/fake_rules.dart';
export 'src/engine/fake_seeded.dart';
export 'src/engine/fake_strategies.dart';
export 'src/engine/fake_topology.dart';
export 'src/engine/fake_variant_family.dart';
export 'src/engine/topology_contract.dart';
export 'src/engine/variant_family_contract.dart';
