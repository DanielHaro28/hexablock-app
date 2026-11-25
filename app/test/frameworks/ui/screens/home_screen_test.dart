import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/adapters/presentation/home/home_state.dart';
import 'package:hexablock_app/config/dependencies.dart';
import 'package:hexablock_app/config/game_catalog.dart';
import 'package:hexablock_app/frameworks/theme/hexa_theme.dart';
import 'package:hexablock_app/frameworks/ui/board/board_view.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_variant_card.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';
import 'package:hexablock_app/frameworks/ui/navigation/app_navigator.dart';
import 'package:hexablock_app/frameworks/ui/screens/home/home_game.dart';
import 'package:hexablock_app/frameworks/ui/screens/home/home_screen.dart';
import 'package:hexablock_app/frameworks/ui/screens/placeholder/placeholder_screen.dart';
import 'package:material_ui/material_ui.dart';

/// The base size of the design system, and the narrowest one it supports.
const _base = Size(390, 844);
const _narrow = Size(360, 640);

void main() {
  late GetIt getIt;

  setUp(() async {
    getIt = GetIt.asNewInstance();
    await registerDependencies(getIt, rootBundle, newSeed: () => 1);
  });

  tearDown(() => getIt.reset());

  /// Opens the app the way `main` does, in [locale] on a screen of [size].
  Future<void> openApp(
    WidgetTester tester, {
    Locale locale = const Locale('es'),
    Size size = _base,
  }) async {
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(HexaBlockApp(home: getIt<AppNavigator>().home));
    await tester.pumpAndSettle();
  }

  /// Taps the card titled [title], scrolling to it first.
  Future<void> tapCard(WidgetTester tester, String title) async {
    final card = find.widgetWithText(HexaVariantCard, title);
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
  }

  group('NAV-01', () {
    testWidgets('should_show_the_suite_settings_and_four_cards_when_it_loads', (
      tester,
    ) async {
      // Arrange
      const titles = ['Hexa Lines', 'Hexa Fit', 'Hexa Sort', 'Hexa Merge'];

      // Act
      await openApp(tester);

      // Assert
      expect(find.text('HexaBlock Suite'), findsOneWidget);
      expect(find.bySemanticsLabel('Ajustes'), findsOneWidget);
      expect(find.byType(HexaVariantCard), findsNWidgets(4));
      for (final title in titles) {
        expect(find.text(title), findsOneWidget);
      }
    });

    testWidgets('should_start_a_new_game_when_hexa_lines_is_tapped', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);

      // Act
      await tapCard(tester, 'Hexa Lines');

      // Assert
      expect(find.byType(BoardView<HexCoord, PieceColor>), findsOneWidget);
    });

    testWidgets('should_open_a_temporary_game_when_hexa_merge_is_tapped', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);

      // Act
      await tapCard(tester, 'Hexa Merge');

      // Assert
      final screen = tester.widget<PlaceholderScreen>(
        find.byType(PlaceholderScreen),
      );
      expect(screen.title, 'Hexa Merge');
    });

    testWidgets('should_open_the_level_selection_when_hexa_fit_is_tapped', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);

      // Act
      await tapCard(tester, 'Hexa Fit');

      // Assert
      final screen = tester.widget<PlaceholderScreen>(
        find.byType(PlaceholderScreen),
      );
      expect(screen.title, 'Hexa Fit');
    });

    testWidgets('should_open_the_level_selection_when_hexa_sort_is_tapped', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);

      // Act
      await tapCard(tester, 'Hexa Sort');

      // Assert
      final screen = tester.widget<PlaceholderScreen>(
        find.byType(PlaceholderScreen),
      );
      expect(screen.title, 'Hexa Sort');
    });

    testWidgets('should_open_the_settings_when_its_button_is_tapped', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);

      // Act
      await tester.tap(find.bySemanticsLabel('Ajustes'));
      await tester.pumpAndSettle();

      // Assert
      final screen = tester.widget<PlaceholderScreen>(
        find.byType(PlaceholderScreen),
      );
      expect(screen.title, 'Ajustes');
    });

    testWidgets('should_come_back_home_when_back_is_tapped_on_a_placeholder', (
      tester,
    ) async {
      // Arrange
      await openApp(tester);
      await tapCard(tester, 'Hexa Fit');

      // Act
      await tester.tap(find.bySemanticsLabel('Volver'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PlaceholderScreen), findsNothing);
      expect(find.byType(HexaVariantCard), findsNWidgets(4));
    });

    testWidgets('should_say_new_on_every_card_when_nothing_was_played', (
      tester,
    ) async {
      // Arrange
      const newBadge = 'Nuevo';

      // Act
      await openApp(tester);

      // Assert
      expect(find.text(newBadge), findsNWidgets(4));
    });

    testWidgets('should_show_the_record_grouped_when_hexa_lines_has_one', (
      tester,
    ) async {
      // Arrange
      await getIt<IProgressRepository>().save(
        ProfileId.guest,
        const GameKey('hexa-lines', defaultTopology),
        HighScoreProgress(12850, DateTime.utc(2026, 11, 24)),
      );

      // Act
      await openApp(tester);

      // Assert
      expect(find.text('Récord 12 850'), findsOneWidget);
      expect(find.text('Nuevo'), findsNWidgets(3));
    });

    testWidgets(
      'should_show_the_texts_in_english_when_the_device_is_in_english',
      (tester) async {
        // Arrange
        await getIt<IProgressRepository>().save(
          ProfileId.guest,
          const GameKey('hexa-lines', defaultTopology),
          HighScoreProgress(12850, DateTime.utc(2026, 11, 24)),
        );

        // Act
        await openApp(tester, locale: const Locale('en'));

        // Assert
        expect(find.text('Puzzles for a quiet afternoon'), findsOneWidget);
        expect(find.text('CHOOSE A GAME'), findsOneWidget);
        expect(find.text('Best 12,850'), findsOneWidget);
        expect(find.bySemanticsLabel('Settings'), findsOneWidget);
      },
    );
  });

  group('NAV-01 · 360 dp', () {
    for (final locale in const [Locale('es'), Locale('en')]) {
      testWidgets(
        'should_fit_without_overflow_when_the_screen_is_360_wide_in_$locale',
        (tester) async {
          // Arrange
          const size = _narrow;

          // Act
          await openApp(tester, locale: locale, size: size);
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -2000),
          );
          await tester.pumpAndSettle();

          // Assert
          expect(tester.takeException(), isNull);
          final cards = find.byType(HexaVariantCard);
          for (final element in cards.evaluate()) {
            final rect = tester.getRect(find.byWidget(element.widget));
            expect(rect.left, greaterThanOrEqualTo(0));
            expect(rect.right, lessThanOrEqualTo(size.width));
          }
        },
      );
    }

    testWidgets('should_give_both_cards_of_a_row_the_same_height_when_shown', (
      tester,
    ) async {
      // Arrange
      const size = _narrow;

      // Act
      await openApp(tester, locale: const Locale('en'), size: size);

      // Assert
      final lines = tester.getSize(
        find.widgetWithText(HexaVariantCard, 'Hexa Lines'),
      );
      final fit = tester.getSize(
        find.widgetWithText(HexaVariantCard, 'Hexa Fit'),
      );
      expect(lines.height, fit.height);
      expect(lines.height, greaterThanOrEqualTo(HexaVariantCard.minHeight));
    });
  });

  group('DIS-11', () {
    /// The home view with Hexa Lines saved, as NAV-04 will show it.
    Future<List<String>> openSaved(WidgetTester tester) async {
      final actions = <String>[];
      tester.view
        ..physicalSize = _base
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: HexaTheme.crema(),
          locale: const Locale('es'),
          localizationsDelegates: HexaBlockApp.localizationsDelegates,
          supportedLocales: const [Locale('es'), Locale('en')],
          home: HomeView(
            games: gameCatalog,
            state: const HomeReady({'hexa-lines': HomeSavedGame()}),
            onSettings: () {},
            onPlay: (HomeGame game) => actions.add('new ${game.gameId}'),
            onContinue: (HomeGame game) =>
                actions.add('continue ${game.gameId}'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return actions;
    }

    testWidgets('should_say_continue_when_the_game_is_saved', (tester) async {
      // Arrange
      final actions = await openSaved(tester);

      // Act
      await tester.tap(find.text('Continuar'));

      // Assert
      expect(actions, ['continue hexa-lines']);
    });

    testWidgets('should_offer_a_new_game_in_the_menu_when_the_game_is_saved', (
      tester,
    ) async {
      // Arrange
      final actions = await openSaved(tester);
      await tester.tap(find.bySemanticsLabel('Más opciones de Hexa Lines'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Nueva partida'));
      await tester.pumpAndSettle();

      // Assert
      expect(actions, ['new hexa-lines']);
    });
  });
}
