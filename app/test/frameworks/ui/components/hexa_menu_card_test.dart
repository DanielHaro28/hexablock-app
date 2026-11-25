import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_colors.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_icon.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_menu.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_variant_card.dart';
import 'package:material_ui/material_ui.dart';

import 'themed.dart';

void main() {
  group('HexaMenu', () {
    testWidgets('should_show_its_items_when_the_more_button_is_tapped', (
      tester,
    ) async {
      // Arrange
      await pumpThemed(
        tester,
        HexaMenu(
          label: 'Más opciones',
          items: [
            HexaMenuItem(
              label: 'Nueva partida',
              icon: HexaIconName.retry,
              onSelected: () {},
            ),
          ],
        ),
      );

      // Act
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Nueva partida'), findsOneWidget);
    });

    testWidgets('should_run_the_item_and_close_when_an_item_is_chosen', (
      tester,
    ) async {
      // Arrange
      var chosen = 0;
      await pumpThemed(
        tester,
        HexaMenu(
          label: 'Más opciones',
          items: [
            HexaMenuItem(label: 'Nueva partida', onSelected: () => chosen++),
          ],
        ),
      );
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Nueva partida'));
      await tester.pumpAndSettle();

      // Assert
      expect(chosen, 1);
      expect(find.text('Nueva partida'), findsNothing);
    });

    testWidgets('should_close_without_choosing_when_tapping_outside', (
      tester,
    ) async {
      // Arrange
      var chosen = 0;
      await pumpThemed(
        tester,
        HexaMenu(
          label: 'Más opciones',
          items: [
            HexaMenuItem(label: 'Nueva partida', onSelected: () => chosen++),
          ],
        ),
      );
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Act
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      // Assert
      expect(chosen, 0);
      expect(find.text('Nueva partida'), findsNothing);
    });

    testWidgets('should_stay_on_screen_when_it_opens_from_the_right_edge', (
      tester,
    ) async {
      // Arrange
      await tester.binding.setSurfaceSize(const Size(360, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpThemed(
        tester,
        Align(
          alignment: Alignment.topRight,
          child: HexaMenu(
            label: 'More options',
            items: [HexaMenuItem(label: 'New game', onSelected: () {})],
          ),
        ),
      );

      // Act
      await tester.tap(find.bySemanticsLabel('More options'));
      await tester.pumpAndSettle();

      // Assert
      final item = tester.getRect(find.text('New game'));
      expect(item.left, greaterThanOrEqualTo(0));
      expect(item.right, lessThanOrEqualTo(360));
    });
    testWidgets('should_open_towards_the_start_when_aligned_to_the_end', (
      tester,
    ) async {
      // Arrange
      await pumpThemed(
        tester,
        HexaMenu(
          label: 'Más opciones',
          items: [HexaMenuItem(label: 'Nueva partida', onSelected: () {})],
        ),
      );
      final button = tester.getRect(find.bySemanticsLabel('Más opciones'));

      // Act
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Assert
      final menu = tester.getRect(find.byType(MenuItemButton));
      expect(menu.right, lessThanOrEqualTo(button.right));
    });

    testWidgets('should_open_towards_the_end_when_aligned_to_the_start', (
      tester,
    ) async {
      // Arrange
      await pumpThemed(
        tester,
        HexaMenu(
          label: 'Más opciones',
          align: HexaMenuAlign.start,
          items: [HexaMenuItem(label: 'Nueva partida', onSelected: () {})],
        ),
      );
      final button = tester.getRect(find.bySemanticsLabel('Más opciones'));

      // Act
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Assert
      final menu = tester.getRect(find.byType(MenuItemButton));
      expect(menu.left, greaterThanOrEqualTo(button.left));
    });

    testWidgets('should_show_an_item_in_ink_soft_when_it_is_disabled', (
      tester,
    ) async {
      // Arrange
      await pumpThemed(
        tester,
        const HexaMenu(
          label: 'Más opciones',
          items: [HexaMenuItem(label: 'Nueva partida', onSelected: null)],
        ),
      );

      // Act
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Assert
      final text = tester.widget<RichText>(
        find.descendant(
          of: find.byType(MenuItemButton),
          matching: find.byType(RichText),
        ),
      );
      expect(text.text.style?.color, HexaColors.crema.inkSoft);
    });
  });

  group('HexaVariantCard', () {
    HexaVariantCard card({
      HexaVariantCardFooter? footer,
      HexaMenu? menu,
      VoidCallback? onTap,
      String description = 'Completa líneas en 3 direcciones',
    }) => HexaVariantCard(
      title: 'Hexa Lines',
      description: description,
      artwork: 'assets/games/hexa-lines.svg',
      onTap: onTap ?? () {},
      footer: footer,
      menu: menu,
    );

    testWidgets('should_show_its_title_description_and_footer_when_shown', (
      tester,
    ) async {
      // Arrange
      final widget = card(footer: const HexaCardMeta('Récord 12 850'));

      // Act
      await pumpThemed(
        tester,
        SizedBox(width: 163, child: IntrinsicHeight(child: widget)),
      );

      // Assert
      expect(find.text('Hexa Lines'), findsOneWidget);
      expect(find.text('Completa líneas en 3 direcciones'), findsOneWidget);
      expect(find.text('Récord 12 850'), findsOneWidget);
    });

    testWidgets('should_show_the_new_badge_when_the_game_was_never_played', (
      tester,
    ) async {
      // Arrange
      final widget = card(footer: const HexaCardNew('Nuevo'));

      // Act
      await pumpThemed(
        tester,
        SizedBox(width: 163, child: IntrinsicHeight(child: widget)),
      );

      // Assert
      expect(find.text('Nuevo'), findsOneWidget);
    });

    testWidgets('should_call_its_action_when_tapped', (tester) async {
      // Arrange
      var taps = 0;
      await pumpThemed(
        tester,
        SizedBox(width: 163, child: card(onTap: () => taps++)),
      );

      // Act
      await tester.tap(find.text('Hexa Lines'));

      // Assert
      expect(taps, 1);
    });

    testWidgets('should_measure_at_least_212_high_when_its_texts_are_short', (
      tester,
    ) async {
      // Arrange
      final widget = card();

      // Act
      await pumpThemed(
        tester,
        SizedBox(width: 163, child: IntrinsicHeight(child: widget)),
      );

      // Assert
      expect(
        tester.getSize(find.byType(HexaVariantCard)).height,
        greaterThanOrEqualTo(HexaVariantCard.minHeight),
      );
    });

    testWidgets('should_grow_instead_of_cutting_when_the_text_is_30_percent_'
        'longer', (tester) async {
      // Arrange
      final widget = card(
        description: 'Complete lines in three directions across the board',
        footer: const HexaCardMeta('Best 12,850 points so far'),
      );

      // Act
      await pumpThemed(
        tester,
        SizedBox(width: 148, child: IntrinsicHeight(child: widget)),
      );

      // Assert
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(HexaVariantCard)).height,
        greaterThan(HexaVariantCard.minHeight),
      );
    });

    HexaMenu savedMenu(List<String> actions) => HexaMenu(
      label: 'Más opciones',
      elevated: false,
      align: HexaMenuAlign.start,
      items: [
        HexaMenuItem(
          label: 'Nueva partida',
          icon: HexaIconName.retry,
          onSelected: () => actions.add('new'),
        ),
      ],
    );

    testWidgets('should_continue_the_game_when_a_saved_card_is_tapped', (
      tester,
    ) async {
      // Arrange
      final actions = <String>[];
      await pumpThemed(
        tester,
        SizedBox(
          width: 163,
          child: card(
            onTap: () => actions.add('continue'),
            footer: const HexaCardMeta('Continuar', icon: HexaIconName.play),
            menu: savedMenu(actions),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Continuar'));

      // Assert
      expect(actions, ['continue']);
    });

    testWidgets('should_offer_a_new_game_in_its_menu_when_the_card_is_saved', (
      tester,
    ) async {
      // Arrange
      final actions = <String>[];
      await pumpThemed(
        tester,
        SizedBox(
          width: 163,
          child: card(
            onTap: () => actions.add('continue'),
            footer: const HexaCardMeta('Continuar', icon: HexaIconName.play),
            menu: savedMenu(actions),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Más opciones'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Nueva partida'));
      await tester.pumpAndSettle();

      // Assert
      expect(actions, ['new']);
    });

    testWidgets('should_be_one_button_that_says_its_texts_when_read_aloud', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        SizedBox(
          width: 163,
          child: card(footer: const HexaCardMeta('Récord 12 850')),
        ),
      );

      // Assert
      final node = tester.getSemantics(find.text('Hexa Lines'));
      expect(node.label, contains('Hexa Lines'));
      expect(node.label, contains('Récord 12 850'));
      expect(node.flagsCollection.isButton, isTrue);
      handle.dispose();
    });

    testWidgets('should_grow_instead_of_cutting_when_the_text_is_enlarged', (
      tester,
    ) async {
      // Arrange
      final widget = MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 163,
            child: card(footer: const HexaCardMeta('Récord 12 850')),
          ),
        ),
      );

      // Act
      await pumpThemed(tester, widget);

      // Assert
      expect(tester.takeException(), isNull);
      expect(find.text('Récord 12 850'), findsOneWidget);
    });
  });
}
