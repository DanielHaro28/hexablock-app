import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const a = FakeCoord(0, 0);

  /// An engine that has played one turn on an empty 3 × 1 board, and the
  /// command for that turn.
  (
    GameEngine<FakeCoord, FakeCell, FakeMove, FakeState>,
    MoveCommand<FakeMove, FakeState>,
  )
  playedOnce() {
    final initial = FakeState(
      Board.of(const FakeTopology(), ShapeSpec('rectangle', const [3, 1])),
    );
    final engine = GameEngine(FakeRules(), initial);
    addTearDown(engine.close);
    engine.submit(const FakeMove(a));
    return (engine, MoveCommand(const FakeMove(a), initial, engine.state));
  }

  group('D-31', () {
    test('should_restore_the_state_before_the_move_when_undone', () {
      // Arrange
      final (engine, command) = playedOnce();

      // Act
      command.undo(engine);

      // Assert
      expect(identical(engine.state, command.before), isTrue);
    });

    test('should_restore_the_state_after_the_move_when_redone', () {
      // Arrange
      final (engine, command) = playedOnce();
      command.undo(engine);

      // Act
      command.redo(engine);

      // Assert
      expect(identical(engine.state, command.after), isTrue);
    });

    test('should_describe_the_move_when_printed', () {
      // Arrange
      final (_, command) = playedOnce();

      // Act
      final printed = command.toString();

      // Assert
      expect(printed, 'MoveCommand(FakeMove((0, 0), x))');
    });
  });
}
