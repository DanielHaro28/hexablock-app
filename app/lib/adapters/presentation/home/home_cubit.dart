import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexa_application/hexa_application.dart';

import 'home_state.dart';

/// The presenter of the home screen (NAV-01, ARQ-03 §4).
///
/// It reads the progress of each game in [gameIds] on [topologyId] with
/// [getProgress] and says what each card's footer shows (D-155): the record
/// if the game keeps one, «New» if there is no progress, nothing if it could
/// not be read. It knows no game and holds no rules: the ids come from the
/// catalog of the composition root.
final class HomeCubit extends Cubit<HomeState> {
  /// A presenter for the games [gameIds] on the cell shape [topologyId].
  HomeCubit({
    required List<String> gameIds,
    required this._topologyId,
    required this._getProgress,
  }) : _gameIds = List.unmodifiable(gameIds),
       super(const HomeLoading());

  final List<String> _gameIds;
  final String _topologyId;
  final UseCase<GameKey, Result<VariantProgress?>> _getProgress;

  /// Reads the progress of every game again, such as when the player comes
  /// back from a game that may have a new record.
  Future<void> load() async {
    final results = await Future.wait([
      for (final gameId in _gameIds)
        _getProgress.execute(GameKey(gameId, _topologyId)),
    ]);
    if (isClosed) return;
    emit(
      HomeReady({
        for (final (index, gameId) in _gameIds.indexed)
          gameId: _statusOf(results[index]),
      }),
    );
  }

  static HomeCardStatus _statusOf(Result<VariantProgress?> result) =>
      switch (result) {
        Success(value: HighScoreProgress(:final score)) => HomeRecord(score),
        Success(value: null) => const HomeNewGame(),
        Failure() => const HomeUnknownStatus(),
      };
}
