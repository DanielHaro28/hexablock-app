import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_colors.dart';
import 'package:hexablock_app/frameworks/theme/hexa_metrics.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_icon.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_round_icon_button.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_top_bar.dart';
import 'package:material_ui/material_ui.dart';

import 'themed.dart';

void main() {
  group('HexaRoundIconButton', () {
    testWidgets('should_call_its_action_when_tapped', (tester) async {
      // Arrange
      var taps = 0;
      await pumpThemed(
        tester,
        HexaRoundIconButton(
          icon: HexaIconName.settings,
          label: 'Ajustes',
          onPressed: () => taps++,
        ),
      );

      // Act
      await tester.tap(find.byType(HexaRoundIconButton));

      // Assert
      expect(taps, 1);
    });

    testWidgets('should_be_announced_as_a_button_with_its_label_when_shown', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        HexaRoundIconButton(
          icon: HexaIconName.settings,
          label: 'Ajustes',
          onPressed: () {},
        ),
      );

      // Assert
      expect(
        tester.getSemantics(find.bySemanticsLabel('Ajustes')),
        matchesSemantics(
          label: 'Ajustes',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('should_measure_56_when_no_size_is_given', (tester) async {
      // Arrange
      final button = HexaRoundIconButton(
        icon: HexaIconName.undo,
        label: 'Deshacer',
        onPressed: () {},
      );

      // Act
      await pumpThemed(tester, button);

      // Assert
      expect(
        tester.getSize(find.byType(HexaRoundIconButton)),
        const Size.square(HexaSizes.button),
      );
    });

    testWidgets('should_measure_48_when_it_is_compact', (tester) async {
      // Arrange
      final button = HexaRoundIconButton(
        icon: HexaIconName.back,
        label: 'Volver',
        onPressed: () {},
        size: HexaRoundIconButton.compactSize,
      );

      // Act
      await pumpThemed(tester, button);

      // Assert
      expect(
        tester.getSize(find.byType(HexaRoundIconButton)),
        const Size.square(HexaSizes.touch),
      );
    });

    testWidgets('should_show_an_ink_soft_icon_when_disabled', (tester) async {
      // Arrange
      const button = HexaRoundIconButton(
        icon: HexaIconName.undo,
        label: 'Deshacer',
        onPressed: null,
      );

      // Act
      await pumpThemed(tester, button);

      // Assert
      final icon = tester.widget<HexaIcon>(find.byType(HexaIcon));
      expect(icon.color, HexaColors.crema.inkSoft);
    });

    testWidgets('should_be_announced_as_disabled_when_it_has_no_action', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        const HexaRoundIconButton(
          icon: HexaIconName.undo,
          label: 'Deshacer',
          onPressed: null,
        ),
      );

      // Assert
      expect(
        tester.getSemantics(find.bySemanticsLabel('Deshacer')),
        matchesSemantics(
          label: 'Deshacer',
          isButton: true,
          hasEnabledState: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('should_show_the_count_when_it_has_a_badge', (tester) async {
      // Arrange
      final button = HexaRoundIconButton(
        icon: HexaIconName.undo,
        label: 'Deshacer',
        onPressed: () {},
        badge: 5,
      );

      // Act
      await pumpThemed(tester, button);

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should_announce_the_badge_when_its_label_is_given', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        HexaRoundIconButton(
          icon: HexaIconName.undo,
          label: 'Deshacer',
          onPressed: () {},
          badge: 5,
          badgeLabel: '5 pasos',
        ),
      );

      // Assert
      final node = tester.getSemantics(find.bySemanticsLabel('Deshacer'));
      expect(node.value, '5 pasos');
      handle.dispose();
    });
  });

  group('HexaTopBar', () {
    HexaTopBarAction action(String label, List<String> tapped) =>
        HexaTopBarAction(
          icon: HexaIconName.back,
          label: label,
          onPressed: () => tapped.add(label),
        );

    testWidgets('should_call_each_button_when_tapped', (tester) async {
      // Arrange
      final tapped = <String>[];
      await pumpThemed(
        tester,
        HexaTopBar(
          title: 'Hexa Sort · Nivel 6',
          leading: action('Volver', tapped),
          help: action('Cómo jugar', tapped),
          trailing: action('Ajustes', tapped),
        ),
      );

      // Act
      await tester.tap(find.bySemanticsLabel('Volver'));
      await tester.tap(find.bySemanticsLabel('Cómo jugar'));
      await tester.tap(find.bySemanticsLabel('Ajustes'));

      // Assert
      expect(tapped, ['Volver', 'Cómo jugar', 'Ajustes']);
    });

    testWidgets('should_measure_72_high_when_the_title_fits_one_line', (
      tester,
    ) async {
      // Arrange
      const bar = HexaTopBar(title: 'Ajustes');

      // Act
      await pumpThemed(tester, const SizedBox(width: 390, child: bar));

      // Assert
      expect(tester.getSize(find.byType(HexaTopBar)).height, HexaSizes.topBar);
    });

    testWidgets('should_wrap_instead_of_cutting_when_the_title_is_long', (
      tester,
    ) async {
      // Arrange
      final tapped = <String>[];
      HexaTopBar bar(String title) => HexaTopBar(
        title: title,
        leading: action('Back', tapped),
        help: action('How to play', tapped),
        trailing: action('Settings', tapped),
      );
      await pumpThemed(tester, SizedBox(width: 360, child: bar('Best')));
      final oneLine = tester.getSize(find.text('Best')).height;

      // Act
      await pumpThemed(
        tester,
        SizedBox(width: 360, child: bar('Leaderboard · Hexagons')),
      );

      // Assert
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.text('Leaderboard · Hexagons')).height,
        greaterThan(oneLine),
      );
    });
  });
}
