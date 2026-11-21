import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const playing = PlayingPhase();
  const resolving = ResolvingPhase();

  group('D-94', () {
    test('should_have_equal_hash_codes_when_two_events_are_equal', () {
      // Arrange: built at run time, so they are not the same constant.
      final score = [10].single;
      final pairs = <(GameEvent<FakeCoord>, GameEvent<FakeCoord>)>[
        (
          PhaseChanged<FakeCoord>(playing, [resolving].single),
          const PhaseChanged<FakeCoord>(playing, resolving),
        ),
        (
          ScoreChanged<FakeCoord>(0, score),
          const ScoreChanged<FakeCoord>(0, 10),
        ),
        (
          MoveRejected<FakeCoord>([const InvalidMove()].single),
          const MoveRejected<FakeCoord>(InvalidMove()),
        ),
      ];

      // Act
      final mismatches = [
        for (final (built, constant) in pairs)
          if (built != constant || built.hashCode != constant.hashCode) built,
      ];

      // Assert
      expect(mismatches, isEmpty);
    });

    test('should_differ_when_an_event_field_differs', () {
      // Arrange
      const event = ScoreChanged<FakeCoord>(0, 10);

      // Act
      final others = [
        const ScoreChanged<FakeCoord>(0, 20),
        const ScoreChanged<FakeCoord>(5, 10),
        const PhaseChanged<FakeCoord>(playing, resolving),
      ];

      // Assert
      expect(others.where((other) => other == event), isEmpty);
    });

    test('should_describe_what_happened_when_printed', () {
      // Arrange
      final values = <Object>[
        const PhaseChanged<FakeCoord>(playing, resolving),
        const ScoreChanged<FakeCoord>(0, 10),
        const MoveRejected<FakeCoord>(InvalidMove()),
        const PausedPhase(),
        const VictoryPhase(canContinue: true),
        const GameOverPhase(),
        const Ongoing(),
        const Victory(),
        const Defeat(),
      ];

      // Act
      final printed = values.map((value) => value.toString()).toList();

      // Assert
      expect(printed, [
        'PhaseChanged(PlayingPhase() → ResolvingPhase())',
        'ScoreChanged(0 → 10)',
        'MoveRejected(InvalidMove())',
        'PausedPhase()',
        'VictoryPhase(canContinue: true)',
        'GameOverPhase()',
        'Ongoing()',
        'Victory(canContinue: false)',
        'Defeat()',
      ]);
    });

    test('should_name_the_engine_reason_when_printed', () {
      // Arrange
      final engine = GameEngine(
        FakeRules(),
        FakeState(
          Board.of(const FakeTopology(), ShapeSpec('rectangle', const [1, 1])),
        ),
      )..pause();
      addTearDown(engine.close);

      // Act
      final result = engine.submit(const FakeMove(FakeCoord(0, 0)));

      // Assert
      expect((result as RejectedMove).reason.toString(), 'NotAcceptingMoves()');
    });
  });
}
