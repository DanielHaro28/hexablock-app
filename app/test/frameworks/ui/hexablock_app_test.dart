import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_colors.dart';
import 'package:hexablock_app/frameworks/theme/hexa_radii.dart';
import 'package:hexablock_app/frameworks/theme/hexa_shadows.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('HexaBlockApp', () {
    testWidgets('should_show_the_home_screen_when_the_app_starts', (
      tester,
    ) async {
      // Arrange
      const app = HexaBlockApp(home: SizedBox.expand());

      // Act
      await tester.pumpWidget(app);

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('D-152', () {
    testWidgets('should_give_the_screens_the_design_tokens_when_it_starts', (
      tester,
    ) async {
      // Arrange
      late BuildContext screen;
      final app = HexaBlockApp(
        home: Builder(
          builder: (context) {
            screen = context;
            return const SizedBox.expand();
          },
        ),
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      expect(HexaColors.of(screen), HexaColors.crema);
      expect(HexaRadii.of(screen), HexaRadii.standard);
      expect(HexaShadows.of(screen), HexaShadows.standard);
      expect(Theme.of(screen).scaffoldBackgroundColor, HexaColors.crema.bg);
    });

    testWidgets(
      'should_load_the_material_texts_in_spanish_when_the_device_is_in_spanish',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('es')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        late BuildContext screen;
        final app = HexaBlockApp(
          home: Builder(
            builder: (context) {
              screen = context;
              return const SizedBox.expand();
            },
          ),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        expect(tester.takeException(), isNull);
        expect(
          MaterialLocalizations.of(screen).backButtonTooltip,
          isNot(MaterialLocalizations.of(screen).closeButtonTooltip),
        );
        expect(Localizations.localeOf(screen), const Locale('es'));
      },
    );
  });
}
