import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  final start = Xorshift32(7);

  group('StubPieceSource', () {
    test(
      'should_hand_out_the_pieces_in_order_when_drawn_one_after_another',
      () {
        // Arrange
        final source = StubPieceSource(start, ['a', 'b', 'c']);

        // Act
        final (first, afterFirst) = source.next(start);
        final (second, afterSecond) = source.next(afterFirst);
        final (third, _) = source.next(afterSecond);

        // Assert
        expect([first, second, third], ['a', 'b', 'c']);
      },
    );

    test('should_advance_the_generator_when_it_draws_a_piece', () {
      // Arrange
      final source = StubPieceSource(start, ['a']);

      // Act
      final (_, after) = source.next(start);

      // Assert
      expect(after, start.next().$2);
    });

    test('should_give_the_same_piece_when_the_generator_is_the_same', () {
      // Arrange (RN-COM-41)
      final source = StubPieceSource(start, ['a', 'b']);
      final (_, afterFirst) = source.next(start);

      // Act
      final again = source.next(afterFirst);

      // Assert
      expect(again, source.next(afterFirst));
      expect(again.$1, 'b');
    });

    test('should_throw_when_more_pieces_are_drawn_than_given', () {
      // Arrange
      final source = StubPieceSource(start, ['a']);
      final (_, after) = source.next(start);

      // Act
      void drawAgain() => source.next(after);

      // Assert
      expect(drawAgain, throwsStateError);
    });
  });
}
