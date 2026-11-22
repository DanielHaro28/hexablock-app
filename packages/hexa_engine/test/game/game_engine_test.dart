import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

typedef _Engine = GameEngine<FakeCoord, FakeCell, FakeMove, FakeState>;

void main() {
  const topology = FakeTopology();
  const a = FakeCoord(0, 0);
  const b = FakeCoord(1, 0);
  const c = FakeCoord(2, 0);
  const playing = PlayingPhase();
  const resolving = ResolvingPhase();
  const paused = PausedPhase();

  /// An empty 3 × 1 board: (0,0) (1,0) (2,0).
  FakeState empty3x1() =>
      FakeState(Board.of(topology, ShapeSpec('rectangle', const [3, 1])));

  /// An engine over [rules] that is closed when the test ends.
  _Engine engineWith(FakeRules rules, [FakeState? initial]) {
    final engine = GameEngine(rules, initial ?? empty3x1());
    addTearDown(engine.close);
    return engine;
  }

  /// Every event [engine] publishes synchronously, from now on.
  List<GameEvent<FakeCoord>> recordSync(_Engine engine) {
    final events = <GameEvent<FakeCoord>>[];
    final subscription = engine.syncEvents.listen(events.add);
    addTearDown(subscription.cancel);
    return events;
  }

  group('RN-COM-20', () {
    test('should_start_playing_with_the_initial_state_when_created', () {
      // Arrange
      final initial = empty3x1();

      // Act
      final engine = engineWith(FakeRules(), initial);

      // Assert
      expect(identical(engine.state, initial), isTrue);
      expect(engine.phase, playing);
    });

    test('should_return_and_keep_the_new_state_when_the_move_is_valid', () {
      // Arrange
      final engine = engineWith(FakeRules(pointsPerTurn: 10));

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      final accepted = result as AcceptedMove<FakeCoord, FakeState>;
      expect(accepted.state.board.cell(a), const FakeCell('x'));
      expect(accepted.state.score, 10);
      expect(accepted.outcome, const Ongoing());
      expect(identical(engine.state, accepted.state), isTrue);
    });
  });

  group('RN-COM-21', () {
    test('should_keep_the_state_and_phase_when_the_rules_reject_the_move', () {
      // Arrange
      final engine = engineWith(FakeRules(pointsPerTurn: 10));
      engine.submit(const FakeMove(a));
      final before = engine.state;

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(result, isA<RejectedMove<FakeCoord, FakeState>>());
      expect(identical(engine.state, before), isTrue);
      expect(engine.state.score, 10);
      expect(engine.phase, playing);
    });

    test('should_publish_only_move_rejected_when_the_rules_reject_it', () {
      // Arrange
      final engine = engineWith(FakeRules());
      engine.submit(const FakeMove(a));
      final published = recordSync(engine);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      const expected = [MoveRejected<FakeCoord>(CellOccupied(a))];
      expect(result.events, expected);
      expect(published, expected);
    });
  });

  group('D-95', () {
    test('should_return_the_reason_of_the_rules_when_they_reject_the_move', () {
      // Arrange
      final engine = engineWith(FakeRules());
      engine.submit(const FakeMove(a));

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect((result as RejectedMove).reason, const CellOccupied(a));
    });

    test('should_give_the_generic_reason_when_the_rules_use_it', () {
      // Arrange
      final engine = engineWith(FakeRules());

      // Act
      final result = engine.submit(const FakeMove(FakeCoord(9, 9)));

      // Assert
      expect((result as RejectedMove).reason, const InvalidMove());
    });
  });

  group('RN-COM-24', () {
    test('should_reject_with_not_accepting_moves_when_paused', () {
      // Arrange
      final engine = engineWith(FakeRules())..pause();
      final before = engine.state;

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect((result as RejectedMove).reason, isA<NotAcceptingMoves>());
      expect(identical(engine.state, before), isTrue);
      expect(engine.phase, paused);
    });

    test('should_reject_with_not_accepting_moves_when_the_game_is_lost', () {
      // Arrange
      final engine = engineWith(FakeRules())
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b))
        ..submit(const FakeMove(c));

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(engine.phase, const GameOverPhase());
      expect((result as RejectedMove).reason, isA<NotAcceptingMoves>());
    });

    test('should_reject_with_not_accepting_moves_when_the_game_is_won', () {
      // Arrange
      final engine = engineWith(FakeRules(victoryWhen: (_) => true))
        ..submit(const FakeMove(a));

      // Act
      final result = engine.submit(const FakeMove(b));

      // Assert
      expect(engine.phase, const VictoryPhase(canContinue: false));
      expect((result as RejectedMove).reason, isA<NotAcceptingMoves>());
    });

    test('should_reject_a_move_when_it_is_submitted_while_resolving', () {
      // Arrange
      late final _Engine engine;
      final nested = <MoveResult<FakeCoord, FakeState>>[];
      final phases = <GamePhase>[];
      engine = engineWith(
        FakeRules(
          onApply: () {
            phases.add(engine.phase);
            nested.add(engine.submit(const FakeMove(b)));
          },
        ),
      );

      // Act
      final outer = engine.submit(const FakeMove(a));

      // Assert
      expect(phases, [resolving]);
      expect((nested.single as RejectedMove).reason, isA<NotAcceptingMoves>());
      expect(outer, isA<AcceptedMove<FakeCoord, FakeState>>());
      expect(engine.state.board.cell(b), isNull);
    });

    test('should_publish_move_rejected_when_the_phase_refuses_the_move', () {
      // Arrange
      final engine = engineWith(FakeRules())..pause();
      final published = recordSync(engine);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(result.events, hasLength(1));
      final event = result.events.single as MoveRejected<FakeCoord>;
      expect(event.reason, isA<NotAcceptingMoves>());
      expect(published, result.events);
    });
  });

  group('RN-COM-25', () {
    test(
      'should_list_phase_rule_score_and_phase_events_when_the_turn_is_played',
      () {
        // Arrange
        final engine = engineWith(FakeRules(pointsPerTurn: 10));

        // Act
        final result = engine.submit(const FakeMove(a));

        // Assert (D-94)
        expect(result.events, const [
          PhaseChanged<FakeCoord>(playing, resolving),
          FakeEvent('apply'),
          FakeEvent('resolve'),
          FakeEvent('afterResolve'),
          ScoreChanged<FakeCoord>(0, 10),
          PhaseChanged<FakeCoord>(resolving, playing),
        ]);
      },
    );

    test('should_leave_out_score_changed_when_the_score_stays_the_same', () {
      // Arrange
      final engine = engineWith(FakeRules());

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(result.events.whereType<ScoreChanged<FakeCoord>>(), isEmpty);
    });

    test('should_end_with_the_phase_the_turn_led_to_when_the_game_ends', () {
      // Arrange
      final engine = engineWith(
        FakeRules(victoryWhen: (_) => true, canContinue: true),
      );

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(
        result.events.last,
        const PhaseChanged<FakeCoord>(
          resolving,
          VictoryPhase(canContinue: true),
        ),
      );
    });

    test('should_not_allow_changing_the_events_when_reading_the_result', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final result = engine.submit(const FakeMove(a));

      // Act
      void change() => result.events.add(const FakeEvent('x'));

      // Assert
      expect(change, throwsUnsupportedError);
    });
  });

  group('D-32', () {
    test('should_notify_sync_listeners_when_submit_has_not_returned_yet', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final published = recordSync(engine);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(published, result.events);
    });

    test('should_notify_async_listeners_when_submit_has_returned', () async {
      // Arrange
      final engine = engineWith(FakeRules());
      final published = <GameEvent<FakeCoord>>[];
      final subscription = engine.events.listen(published.add);
      addTearDown(subscription.cancel);

      // Act
      final result = engine.submit(const FakeMove(a));
      final whenReturned = List.of(published);
      await pumpEventQueue();

      // Assert
      expect(whenReturned, isEmpty);
      expect(published, result.events);
    });

    test('should_throw_when_a_sync_listener_submits_a_move', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final errors = <Object>[];
      final subscription = engine.syncEvents.listen((_) {
        try {
          engine.submit(const FakeMove(b));
        } on StateError catch (error) {
          errors.add(error);
        }
      });
      addTearDown(subscription.cancel);

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(errors, isNotEmpty);
      expect(engine.state.board.cell(b), isNull);
    });

    test('should_throw_when_a_sync_listener_changes_the_phase', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final errors = <Object>[];
      final subscription = engine.syncEvents.listen((_) {
        try {
          engine.pause();
        } on StateError catch (error) {
          errors.add(error);
        }
      });
      addTearDown(subscription.cancel);

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(errors, isNotEmpty);
      expect(engine.phase, playing);
    });
  });

  group('RN-COM-31', () {
    test('should_pause_and_publish_the_change_when_playing', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final published = recordSync(engine);

      // Act
      engine.pause();

      // Assert
      expect(engine.phase, paused);
      expect(published, const [PhaseChanged<FakeCoord>(playing, paused)]);
    });

    test('should_play_again_when_resumed_after_a_pause', () {
      // Arrange
      final engine = engineWith(FakeRules())..pause();
      final published = recordSync(engine);

      // Act
      engine.resume();
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(published.first, const PhaseChanged<FakeCoord>(paused, playing));
      expect(result, isA<AcceptedMove<FakeCoord, FakeState>>());
    });

    test('should_go_to_game_over_when_the_turn_is_a_defeat', () {
      // Arrange
      final engine = engineWith(FakeRules())
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b));

      // Act
      final result = engine.submit(const FakeMove(c));

      // Assert
      expect((result as AcceptedMove).outcome, const Defeat());
      expect(engine.phase, const GameOverPhase());
    });

    test('should_keep_playing_after_a_victory_when_the_rules_allow_it', () {
      // Arrange
      final engine = engineWith(
        FakeRules(
          victoryWhen: (s) => s.board.cell(a) != null,
          canContinue: true,
        ),
      )..submit(const FakeMove(a));
      final published = recordSync(engine);

      // Act
      engine.continuePlaying();
      final result = engine.submit(const FakeMove(b));

      // Assert
      expect(
        published.first,
        const PhaseChanged<FakeCoord>(VictoryPhase(canContinue: true), playing),
      );
      expect(result, isA<AcceptedMove<FakeCoord, FakeState>>());
    });

    test('should_stay_in_victory_when_continuing_is_not_allowed', () {
      // Arrange
      final engine = engineWith(FakeRules(victoryWhen: (_) => true))
        ..submit(const FakeMove(a));
      final published = recordSync(engine);

      // Act
      engine.continuePlaying();

      // Assert
      expect(engine.phase, const VictoryPhase(canContinue: false));
      expect(published, isEmpty);
    });

    test('should_publish_nothing_when_pause_or_resume_change_nothing', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final published = recordSync(engine);

      // Act
      engine
        ..resume()
        ..continuePlaying()
        ..pause()
        ..pause();

      // Assert
      expect(published, const [PhaseChanged<FakeCoord>(playing, paused)]);
    });
  });

  group('D-94', () {
    test('should_restore_the_phase_and_state_when_the_rules_throw', () {
      // Arrange
      final engine = engineWith(
        FakeRules(onApply: () => throw StateError('broken rule')),
      );
      final before = engine.state;
      final published = recordSync(engine);

      // Act
      void submit() => engine.submit(const FakeMove(a));

      // Assert
      expect(submit, throwsStateError);
      expect(engine.phase, playing);
      expect(identical(engine.state, before), isTrue);
      expect(published, isEmpty);
    });
  });

  group('D-32', () {
    test('should_throw_when_a_sync_listener_closes_the_engine', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final errors = <Object>[];
      final subscription = engine.syncEvents.listen((_) {
        try {
          engine.close();
        } on StateError catch (error) {
          errors.add(error);
        }
      });
      addTearDown(subscription.cancel);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(errors, hasLength(result.events.length));
      expect(engine.isClosed, isFalse);
    });

    test('should_throw_when_used_after_being_closed', () async {
      // Arrange
      final engine = GameEngine(FakeRules(), empty3x1());

      // Act
      await engine.close();

      // Assert
      expect(() => engine.submit(const FakeMove(a)), throwsStateError);
      expect(engine.pause, throwsStateError);
      expect(engine.isClosed, isTrue);
    });

    test('should_close_both_streams_when_closed', () async {
      // Arrange
      final engine = GameEngine(FakeRules(), empty3x1());
      final syncDone = engine.syncEvents.isEmpty;
      final asyncDone = engine.events.isEmpty;

      // Act
      await engine.close();

      // Assert
      expect(await syncDone, isTrue);
      expect(await asyncDone, isTrue);
    });
  });

  group('D-102', () {
    test('should_keep_playing_with_the_snapshot_when_restored', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial)
        ..submit(const FakeMove(a));

      // Act
      engine.restore(initial);

      // Assert
      expect(identical(engine.state, initial), isTrue);
      expect(engine.phase, playing);
    });

    test('should_throw_and_change_nothing_when_restored_while_paused', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial)
        ..submit(const FakeMove(a))
        ..pause();
      final before = engine.state;
      final published = recordSync(engine);

      // Act
      void restore() => engine.restore(initial);

      // Assert
      expect(restore, throwsStateError);
      expect(identical(engine.state, before), isTrue);
      expect(engine.phase, paused);
      expect(published, isEmpty);
    });

    test('should_throw_when_a_sync_listener_restores', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial);
      final errors = <Object>[];
      final subscription = engine.syncEvents.listen((_) {
        try {
          engine.restore(initial);
        } on StateError catch (error) {
          errors.add(error);
        }
      });
      addTearDown(subscription.cancel);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(errors, hasLength(result.events.length));
      expect(engine.state.board.cell(a), const FakeCell('x'));
    });

    test('should_throw_when_restored_after_being_closed', () async {
      // Arrange
      final initial = empty3x1();
      final engine = GameEngine(FakeRules(), initial);
      await engine.close();

      // Act
      void restore() => engine.restore(initial);

      // Assert
      expect(restore, throwsStateError);
    });
  });

  group('RN-COM-63', () {
    test('should_throw_when_restored_after_a_defeat', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial)
        ..submit(const FakeMove(a))
        ..submit(const FakeMove(b))
        ..submit(const FakeMove(c)); // a full board is a defeat

      // Act
      void restore() => engine.restore(initial);

      // Assert
      expect(engine.phase, const GameOverPhase());
      expect(restore, throwsStateError);
    });

    test('should_throw_when_restored_after_a_victory', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(victoryWhen: (_) => true), initial)
        ..submit(const FakeMove(a));

      // Act
      void restore() => engine.restore(initial);

      // Assert
      expect(engine.phase, const VictoryPhase(canContinue: false));
      expect(restore, throwsStateError);
    });
  });

  group('D-103', () {
    test('should_publish_state_restored_then_score_changed_when_restored', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(pointsPerTurn: 10), initial)
        ..submit(const FakeMove(a));
      final published = recordSync(engine);

      // Act
      engine.restore(initial);

      // Assert
      expect(published, const [
        StateRestored<FakeCoord>(),
        ScoreChanged<FakeCoord>(10, 0),
      ]);
    });

    test('should_publish_only_state_restored_when_the_score_is_the_same', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial)
        ..submit(const FakeMove(a));
      final published = recordSync(engine);

      // Act
      engine.restore(initial);

      // Assert
      expect(published, const [StateRestored<FakeCoord>()]);
    });

    test('should_publish_the_same_events_later_when_restored', () async {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(pointsPerTurn: 10), initial)
        ..submit(const FakeMove(a));
      await pumpEventQueue(); // deliver the turn before listening
      final published = <GameEvent<FakeCoord>>[];
      final subscription = engine.events.listen(published.add);
      addTearDown(subscription.cancel);

      // Act
      engine.restore(initial);
      final beforeDelivery = List.of(published);
      await pumpEventQueue();

      // Assert
      expect(beforeDelivery, isEmpty);
      expect(published, const [
        StateRestored<FakeCoord>(),
        ScoreChanged<FakeCoord>(10, 0),
      ]);
    });
  });

  group('D-31', () {
    /// Every command [engine] commits, from now on.
    List<MoveCommand<FakeMove, FakeState>> recordCommits(_Engine engine) {
      final commands = <MoveCommand<FakeMove, FakeState>>[];
      final subscription = engine.committedTurns.listen(commands.add);
      addTearDown(subscription.cancel);
      return commands;
    }

    test('should_commit_the_move_and_both_states_when_a_turn_is_played', () {
      // Arrange
      final initial = empty3x1();
      final engine = engineWith(FakeRules(), initial);
      final commands = recordCommits(engine);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      final accepted = result as AcceptedMove<FakeCoord, FakeState>;
      expect(commands, hasLength(1));
      expect(commands.single.move, const FakeMove(a));
      expect(identical(commands.single.before, initial), isTrue);
      expect(identical(commands.single.after, accepted.state), isTrue);
    });

    test('should_commit_the_turn_when_it_ends_the_game', () {
      // Arrange
      final engine = engineWith(FakeRules(victoryWhen: (_) => true));
      final commands = recordCommits(engine);

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(commands, hasLength(1));
    });

    test('should_commit_after_publishing_the_turn_events_when_played', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final published = recordSync(engine);
      final seenAtCommit = <int>[];
      final subscription = engine.committedTurns.listen(
        (_) => seenAtCommit.add(published.length),
      );
      addTearDown(subscription.cancel);

      // Act
      final result = engine.submit(const FakeMove(a));

      // Assert
      expect(seenAtCommit, [result.events.length]);
    });

    test('should_throw_when_a_commit_listener_calls_the_engine', () {
      // Arrange
      final engine = engineWith(FakeRules());
      final errors = <Object>[];
      final subscription = engine.committedTurns.listen((_) {
        try {
          engine.pause();
        } on StateError catch (error) {
          errors.add(error);
        }
      });
      addTearDown(subscription.cancel);

      // Act
      engine.submit(const FakeMove(a));

      // Assert
      expect(errors, hasLength(1));
      expect(engine.phase, playing);
    });

    test('should_close_the_committed_turns_when_closed', () async {
      // Arrange
      final engine = GameEngine(FakeRules(), empty3x1());
      final done = engine.committedTurns.isEmpty;

      // Act
      await engine.close();

      // Assert
      expect(await done, isTrue);
    });
  });

  group('RN-COM-21', () {
    test('should_commit_nothing_when_the_move_is_rejected', () {
      // Arrange
      final engine = engineWith(FakeRules())..submit(const FakeMove(a));
      final commands = <Object>[];
      final subscription = engine.committedTurns.listen(commands.add);
      addTearDown(subscription.cancel);

      // Act
      engine
        ..submit(const FakeMove(a)) // occupied: rejected by the rules
        ..pause()
        ..submit(const FakeMove(b)); // paused: rejected by the phase

      // Assert
      expect(commands, isEmpty);
    });
  });
}
