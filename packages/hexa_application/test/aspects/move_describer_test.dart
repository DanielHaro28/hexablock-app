import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const a = FakeCoord(0, 0);

  GameSession<FakeCoord, FakeCell, FakeMove, FakeState> sessionOf() {
    final session = FakeVariantFamily(rules: () => FakeRules(pointsPerTurn: 10))
        .createSession(NewGameOptions(seed: 1));
    addTearDown(session.engine.close);
    return session;
  }

  group('D-40', () {
    test('should_describe_the_move_and_the_board_before_it_is_played', () {
      // Arrange
      final session = sessionOf()..engine.submit(const FakeMove(a));
      final describer = MoveDescriber(session);

      // Act
      final described = describer.command(const FakeMove(FakeCoord(1, 0)));

      // Assert
      expect(described, {
        'move': 'FakeMove((1, 0), x)',
        'board': '{(0, 0): FakeCell(x)}',
      });
    });

    test('should_describe_the_board_events_and_score_when_accepted', () {
      // Arrange
      final session = sessionOf();
      final describer = MoveDescriber(session);
      final result = session.engine.submit(const FakeMove(a));

      // Act
      final described = describer.result(result);

      // Assert
      expect(described['outcome'], 'accepted Ongoing()');
      expect(described['board'], '{(0, 0): FakeCell(x)}');
      expect(described['score'], 10);
      expect(described['events'], contains('FakeEvent(resolve)'));
    });

    test('should_describe_the_reason_when_the_move_is_rejected', () {
      // Arrange
      final session = sessionOf()..engine.submit(const FakeMove(a));
      final describer = MoveDescriber(session);
      final result = session.engine.submit(const FakeMove(a));

      // Act
      final described = describer.result(result);

      // Assert
      expect(described, {
        'outcome': 'rejected',
        'reason': 'CellOccupied((0, 0))',
      });
    });
  });
}
