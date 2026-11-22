import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// The pieces that [source] draws, in order, starting from [random].
List<FakeCell> drawsOf(
  IPieceSource<FakeCell> source,
  Xorshift32 random,
  int count,
) {
  final pieces = <FakeCell>[];
  var current = random;
  for (var i = 0; i < count; i++) {
    final (piece, after) = source.next(current);
    pieces.add(piece);
    current = after;
  }
  return pieces;
}

void main() {
  const source = FakePieceSource(['a', 'b', 'c']);

  group('RN-COM-40', () {
    test('should_draw_with_the_given_generator_when_asked_for_a_piece', () {
      // Arrange: the first value of seed 12345 is 3336926330 (E-COM-1).
      final random = Xorshift32(12345);

      // Act
      final (piece, after) = source.next(random);

      // Assert
      expect(piece, FakeCell(const ['a', 'b', 'c'][3336926330 % 3]));
      expect(after, random.next().$2);
    });
  });

  group('RN-COM-41', () {
    test('should_draw_the_same_pieces_when_the_generator_is_the_same', () {
      // Arrange
      final first = Xorshift32(2024);
      final second = Xorshift32(2024);

      // Act
      final fromFirst = drawsOf(source, first, 20);
      final fromSecond = drawsOf(source, second, 20);

      // Assert
      expect(fromFirst, fromSecond);
    });
  });

  group('RN-COM-42', () {
    test('should_draw_the_same_piece_again_when_the_generator_is_restored', () {
      // Arrange: the state before a turn keeps its generator (the memento).
      final before = Xorshift32(12345);
      final (drawn, _) = source.next(before);

      // Act: undo restores the state, so the same generator draws again.
      final (redrawn, _) = source.next(before);

      // Assert
      expect(redrawn, drawn);
    });

    test('should_share_one_sequence_when_the_rules_draw_before_the_source', () {
      // Arrange: a step that chooses a cell and then asks for a piece.
      final random = Xorshift32(12345);

      // Act
      final (_, afterCell) = random.nextInt(5);
      final (_, afterPiece) = source.next(afterCell);

      // Assert: two draws of the same generator, nothing hidden elsewhere.
      expect(afterPiece, random.next().$2.next().$2);
    });
  });
}
