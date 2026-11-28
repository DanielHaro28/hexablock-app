import 'dart:async';

import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  group('D-158', () {
    test('should_start_a_unit_only_when_the_previous_one_ends', () async {
      // Arrange
      final unitOfWork = FakeUnitOfWork();
      final firstCanEnd = Completer<void>();
      final order = <String>[];

      // Act
      final first = unitOfWork.run(() async {
        order.add('first starts');
        await firstCanEnd.future;
        order.add('first ends');
      });
      final second = unitOfWork.run(() async => order.add('second starts'));
      await Future<void>.delayed(Duration.zero);
      firstCanEnd.complete();
      await Future.wait([first, second]);

      // Assert
      expect(order, ['first starts', 'first ends', 'second starts']);
      expect(unitOfWork.runs, 2);
    });

    test('should_run_the_next_unit_when_one_fails', () async {
      // Arrange
      final unitOfWork = FakeUnitOfWork();

      // Act
      final failed = unitOfWork.run<int>(() async => throw StateError('x'));
      final next = unitOfWork.run(() async => 7);

      // Assert
      await expectLater(failed, throwsStateError);
      expect(await next, 7);
      expect(unitOfWork.failed, 1);
    });
  });
}
