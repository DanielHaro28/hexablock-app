/// Layer 2: generic use cases, ports and aspects (ARQ-03-APP-DETALLE).
///
/// Depends only on `hexa_engine`: it cannot see variants or topologies, so
/// there is no use case per game (RNF-07).
library;

export 'src/aspects/aspect.dart';
export 'src/aspects/exception_aspect.dart';
export 'src/command_service.dart';
export 'src/either.dart';
export 'src/errors.dart';
export 'src/game_keys.dart';
export 'src/ports/clock.dart';
export 'src/ports/profile_repository.dart';
export 'src/ports/progress_repository.dart';
export 'src/ports/saved_game_repository.dart';
export 'src/ports/unit_of_work.dart';
export 'src/profile.dart';
export 'src/progress.dart';
export 'src/use_cases/apply_move_use_case.dart';
export 'src/use_cases/check_move_use_case.dart';
export 'src/use_cases/get_progress_use_case.dart';
export 'src/use_cases/save_progress_use_case.dart';
export 'src/use_cases/start_game_use_case.dart';
