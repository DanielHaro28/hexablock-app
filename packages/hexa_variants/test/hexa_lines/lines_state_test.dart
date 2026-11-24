import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

void main() {
  final mono = tablePiece(0, 0);

  LinesState<HexCoord> stateWith(List<LinesPiece<HexCoord>?> tray) =>
      LinesState(
        board: Board<HexCoord, PieceColor>.of(hexTopology, hexRadius4),
        tray: tray,
        random: Xorshift32(7),
        seed: 7,
      );

  group('RN-HL-20', () {
    test('should_throw_when_the_tray_does_not_have_3_slots', () {
      // Act
      LinesState<HexCoord> build() => stateWith([mono, mono]);

      // Assert
      expect(build, throwsArgumentError);
    });
  });

  group('D-133', () {
    test('should_be_equal_when_the_same_slots_are_empty', () {
      // Arrange
      final state = stateWith([mono, null, mono]);

      // Act
      final same = stateWith([mono, null, mono]);

      // Assert
      expect(same, state);
      expect(same.hashCode, state.hashCode);
    });

    test('should_differ_when_another_slot_is_empty', () {
      // Arrange
      final state = stateWith([mono, null, mono]);

      // Act
      final other = stateWith([null, mono, mono]);

      // Assert
      expect(other, isNot(state));
    });
  });
}
