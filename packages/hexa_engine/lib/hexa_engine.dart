/// Layer 1: the generic game engine (ARQ-02-MOTOR).
///
/// Pure Dart with no dependencies. It knows no variant and no cell shape:
/// the CI fails if their identifiers appear here (ARQ-01-APP §8).
library;

export 'src/board/board.dart';
export 'src/board/coord.dart';
export 'src/board/geometry.dart';
export 'src/board/grid_topology.dart';
export 'src/board/shape.dart';
export 'src/board/shape_spec.dart';
export 'src/board/topology_visitor.dart';
export 'src/game/game_engine.dart';
export 'src/game/game_event.dart';
export 'src/game/game_outcome.dart';
export 'src/game/game_phase.dart';
export 'src/game/game_rules.dart';
export 'src/game/game_state.dart';
export 'src/game/move_result.dart';
export 'src/game/rejection_reason.dart';
export 'src/game/turn_result.dart';
export 'src/random/xorshift32.dart';
export 'src/session/capabilities.dart';
export 'src/session/game_session.dart';
export 'src/session/session_snapshot.dart';
export 'src/strategy/piece_source.dart';
export 'src/strategy/progress_model.dart';
export 'src/strategy/scoring_policy.dart';
export 'src/time/active_timer.dart';
export 'src/time/monotonic_clock.dart';
export 'src/time/timed_engine.dart';
export 'src/undo/move_command.dart';
export 'src/undo/restorable.dart';
export 'src/undo/undo_history.dart';
export 'src/undo/undo_snapshot.dart';
