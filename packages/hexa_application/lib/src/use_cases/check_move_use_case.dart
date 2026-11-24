import 'package:hexa_engine/hexa_engine.dart';

import '../use_case.dart';

/// Tells whether a move of any variant would be played, without playing it
/// (D-138, RNF-07): the preview of a drag (HL-02).
///
/// One is built per game, around its [GameSession]. It gives `null` if the
/// move would be played, or why it would be rejected: the phase
/// (`NotAcceptingMoves`) or the rules. The game does not change and nothing
/// is saved.
final class CheckMoveUseCase<
  C extends Coord,
  TCell extends Object,
  TMove,
  TState extends GameState<C, TCell>
>
    implements UseCase<TMove, RejectionReason?> {
  /// Checks the moves of [_session].
  const CheckMoveUseCase(this._session);

  final GameSession<C, TCell, TMove, TState> _session;

  @override
  Future<RejectionReason?> execute(TMove input) async =>
      _session.engine.check(input);
}
