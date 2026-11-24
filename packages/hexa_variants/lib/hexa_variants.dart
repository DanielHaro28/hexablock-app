/// Layer 1: the four variants, one folder each under `lib/src/`.
///
/// Rules work on the topology abstraction, so they run on any shape.
/// Variants implement the turn steps and never override `playTurn` (D-36).
library;

export 'src/hexa_lines/hexa_lines_factory.dart';
export 'src/hexa_lines/hexa_lines_rules.dart';
export 'src/hexa_lines/lines_piece.dart';
export 'src/hexa_lines/lines_piece_source.dart';
export 'src/hexa_lines/lines_scoring.dart';
export 'src/hexa_lines/lines_state.dart';
