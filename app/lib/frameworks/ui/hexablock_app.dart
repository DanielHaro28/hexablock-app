import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../theme/hexa_colors.dart';
import '../theme/hexa_theme.dart';

/// Root widget of the app.
///
/// It sets the localized texts (es and en, RNF-50) and the theme built from
/// the design system tokens (D-148, D-152), and shows [home] as the first
/// route. Material comes from `material_ui` (D-148); the screens only use the
/// components of the design system, never Material widgets directly.
class HexaBlockApp extends StatelessWidget {
  /// The app showing [home].
  const HexaBlockApp({required this.home, super.key});

  /// The first screen.
  final Widget home;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    // The Material delegates of `material_ui`, not the legacy ones that the
    // generated `AppLocalizations.localizationsDelegates` lists: those only
    // serve `package:flutter/material.dart` (D-148).
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: HexaTheme.crema(),
    debugShowCheckedModeBanner: false,
    // The Material of every screen, above the Navigator: without it Flutter
    // draws texts in its red, yellow underlined warning style. It gives the
    // theme's text style (`ink`) to the routes and what floats over them.
    builder: (context, navigator) =>
        Material(color: HexaColors.of(context).bg, child: navigator),
    // A route as home: the Navigator brings the Overlay that a
    // dragged piece floats on (HL-02).
    home: home,
  );
}
