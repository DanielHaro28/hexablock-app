import 'package:hexa_engine/hexa_engine.dart';

import 'command_describer.dart';

/// Describes a move of any variant for the log: the move with the board
/// before it, and the board, score and events after it (D-40, ARQ-03
/// §5.1; the board dump of section 3.5 of the assignment).
///
/// `LoggingAspect` only asks it in development builds (SEC-MOB-05). The
/// board is its occupied cells, as their own text, so it works with any
/// topology and any cell content (RNF-07).
final class MoveDescriber<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements CommandDescriber<TMove, MoveResult<C, TState>> {
  /// Describes the moves of [_session], reading the board before each one.
  const MoveDescriber(this._session);

  final GameSession<C, TCell, TMove, TState> _session;

  @override
  Map<String, Object?> command(TMove command) => {
    'move': '$command',
    'board': '${_session.engine.state.board.contents}',
  };

  @override
  Map<String, Object?> result(MoveResult<C, TState> result) => switch (result) {
    AcceptedMove(:final state, :final events, :final outcome) => {
      'outcome': 'accepted $outcome',
      'board': '${state.board.contents}',
      'score': state.score,
      'events': [for (final event in events) '$event'],
    },
    RejectedMove(:final reason) => {'outcome': 'rejected', 'reason': '$reason'},
  };
}
