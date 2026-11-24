/// Layer 2: generic use cases, ports and aspects (ARQ-03-APP-DETALLE).
///
/// Depends only on `hexa_engine`: it cannot see variants or topologies, so
/// there is no use case per game (RNF-07).
library;

export 'src/aspects/error_handling_aspect.dart';
export 'src/errors.dart';
export 'src/game_keys.dart';
export 'src/ports/saved_game_repository.dart';
export 'src/use_case.dart';
export 'src/use_cases/apply_move_use_case.dart';
export 'src/use_cases/start_game_use_case.dart';
