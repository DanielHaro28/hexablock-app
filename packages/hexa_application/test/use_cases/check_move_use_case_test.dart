import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const a = FakeCoord(0, 0);

  /// A session on an empty 3 × 1 board.
  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> session() {
    final board = Board<FakeCoord, FakeCell>.of(
      const FakeTopology(),
      ShapeSpec('rectangle', const [3, 1]),
    );
    final engine = GameEngine(FakeRules(), FakeState(board));
    addTearDown(engine.close);
    return GameSession(engine);
  }

  group('D-138', () {
    test('should_find_no_reason_when_the_move_would_be_played', () async {
      // Arrange
      final useCase = CheckMoveUseCase(session());

      // Act
      final reason = await useCase.execute(const FakeMove(a));

      // Assert
      expect(reason, isNull);
    });

    test('should_give_the_reason_when_the_move_would_be_rejected', () async {
      // Arrange
      final played = session()..engine.submit(const FakeMove(a));
      final useCase = CheckMoveUseCase(played);

      // Act
      final reason = await useCase.execute(const FakeMove(a));

      // Assert
      expect(reason, const CellOccupied(a));
    });

    test('should_leave_the_game_as_it_was_when_checking', () async {
      // Arrange
      final game = session();
      final before = game.engine.state;
      final useCase = CheckMoveUseCase(game);

      // Act
      await useCase.execute(const FakeMove(a));

      // Assert
      expect(identical(game.engine.state, before), isTrue);
      expect(game.engine.phase, const PlayingPhase());
    });
  });
}
