import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// Rules that implement only the two primitive steps, to check the defaults
/// of the optional hooks.
final class _MinimalRules
    extends GameRules<FakeCoord, FakeCell, FakeMove, FakeState> {
  const _MinimalRules();

  @override
  Iterable<FakeMove> validMoves(FakeState state) =>
      state.board.emptyCells.map(FakeMove.new);

  @override
  RejectionReason? rejectionOf(FakeState state, FakeMove move) =>
      state.board.cell(move.cell) == null ? null : const InvalidMove();

  @override
  Step<FakeCoord, FakeState> apply(FakeState state, FakeMove move) => Step(
    state.after(
      'apply',
      board: state.board.withCells({move.cell: FakeCell(move.label)}),
    ),
    const [FakeEvent('apply')],
  );
}

void main() {
  const topology = FakeTopology();
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);

  /// An empty 2 × 1 board: (0,0) (1,0).
  FakeState empty2x1() =>
      FakeState(Board.of(topology, ShapeSpec('rectangle', const [2, 1])));

  /// The 2 × 1 board with only (1,0) empty.
  FakeState oneLeft() =>
      FakeState(empty2x1().board.withCells({a: const FakeCell('x')}));

  group('RN-COM-20', () {
    test('should_run_apply_resolve_and_after_resolve_in_order_when_valid', () {
      // Arrange
      final rules = FakeRules();

      // Act
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert
      final played = result as PlayedTurn<FakeCoord, FakeState>;
      expect(played.state.steps, ['apply', 'resolve', 'afterResolve']);
      expect(played.state.board.cell(a), const FakeCell('x'));
    });

    test('should_run_every_step_when_the_rules_have_no_resolution', () {
      // Arrange
      const rules = _MinimalRules();

      // Act
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert
      final played = result as PlayedTurn<FakeCoord, FakeState>;
      expect(played.state.steps, ['apply']);
      expect(played.events, const [FakeEvent('apply')]);
      expect(played.outcome, const Ongoing());
    });
  });

  group('RN-COM-21', () {
    test('should_return_the_same_state_when_the_move_is_invalid', () {
      // Arrange
      final rules = FakeRules(pointsPerTurn: 10);
      final state = oneLeft();

      // Act
      final result = rules.playTurn(state, const FakeMove(a));

      // Assert
      final rejected = result as RejectedTurn<FakeCoord, FakeState>;
      expect(identical(rejected.state, state), isTrue);
      expect(rejected.state.steps, isEmpty);
      expect(rejected.state.score, 0);
    });

    test('should_not_run_any_step_when_the_move_is_invalid', () {
      // Arrange
      var applied = false;
      final rules = FakeRules(onApply: () => applied = true);

      // Act
      rules.playTurn(oneLeft(), const FakeMove(a));

      // Assert
      expect(applied, isFalse);
    });

    test('should_say_whether_a_move_is_valid_when_asked_directly', () {
      // Arrange
      final rules = FakeRules();
      final state = oneLeft();

      // Act
      final occupied = rules.isValid(state, const FakeMove(a));
      final free = rules.isValid(state, const FakeMove(b));

      // Assert
      expect(occupied, isFalse);
      expect(free, isTrue);
    });
  });

  group('D-95', () {
    test('should_carry_the_reason_of_the_rules_when_the_move_is_invalid', () {
      // Arrange
      final rules = FakeRules();

      // Act
      final occupied = rules.playTurn(oneLeft(), const FakeMove(a));
      final offBoard = rules.playTurn(
        oneLeft(),
        const FakeMove(FakeCoord(9, 9)),
      );

      // Assert
      expect((occupied as RejectedTurn).reason, const CellOccupied(a));
      expect((offBoard as RejectedTurn).reason, const InvalidMove());
    });

    test('should_compare_reasons_without_fields_by_type_when_comparing', () {
      // Arrange
      final built = [const InvalidMove()].single;

      // Act
      final same = built == const InvalidMove();

      // Assert
      expect(same, isTrue);
      expect(built.hashCode, const InvalidMove().hashCode);
      expect(const InvalidMove(), isNot(const CellOccupied(a)));
    });
  });

  group('RN-COM-22', () {
    test('should_resolve_once_and_keep_its_stable_result_when_valid', () {
      // Arrange
      final rules = FakeRules(pointsPerTurn: 5);

      // Act
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert: repeating until stable is each variant's resolve (RN-COM-22);
      // the skeleton calls it once and keeps what it returns.
      final played = result as PlayedTurn<FakeCoord, FakeState>;
      expect(
        played.state.steps.where((step) => step == 'resolve'),
        hasLength(1),
      );
      expect(played.state.score, 5);
    });
  });

  group('RN-COM-23', () {
    test('should_evaluate_the_state_after_every_step_when_valid', () {
      // Arrange
      final seen = <List<String>>[];
      final rules = FakeRules(
        victoryWhen: (state) {
          seen.add(state.steps);
          return false;
        },
      );

      // Act
      rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert
      expect(seen, [
        ['apply', 'resolve', 'afterResolve'],
      ]);
    });

    test('should_be_ongoing_when_some_move_is_still_valid', () {
      // Arrange
      final rules = FakeRules();

      // Act
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert
      expect((result as PlayedTurn).outcome, const Ongoing());
    });

    test('should_be_a_defeat_by_default_when_no_move_is_valid', () {
      // Arrange
      final rules = FakeRules();

      // Act
      final result = rules.playTurn(oneLeft(), const FakeMove(b));

      // Assert
      expect((result as PlayedTurn).outcome, const Defeat());
    });

    test('should_be_a_victory_when_victory_and_defeat_hold_together', () {
      // Arrange
      final rules = FakeRules(victoryWhen: (state) => state.board.isFull);

      // Act
      final result = rules.playTurn(oneLeft(), const FakeMove(b));

      // Assert
      expect((result as PlayedTurn).outcome, const Victory());
    });
  });

  group('RN-COM-25', () {
    test('should_list_the_events_of_every_step_in_order_when_valid', () {
      // Arrange
      final rules = FakeRules();

      // Act
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Assert
      expect((result as PlayedTurn).events, const [
        FakeEvent('apply'),
        FakeEvent('resolve'),
        FakeEvent('afterResolve'),
      ]);
    });

    test('should_not_allow_changing_the_events_when_reading_them', () {
      // Arrange
      final rules = FakeRules();
      final result = rules.playTurn(empty2x1(), const FakeMove(a));

      // Act
      void change() => (result as PlayedTurn).events.add(const FakeEvent('x'));

      // Assert
      expect(change, throwsUnsupportedError);
    });
  });
}
