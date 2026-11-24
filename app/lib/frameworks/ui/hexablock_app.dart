import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Root widget of the app.
///
/// It sets the localized texts (es and en, RNF-50) and the base text style,
/// and shows [home] as the first route. It only uses `package:flutter/widgets.dart`: since
/// Flutter 3.47 Material lives in its own package, and adding it is a
/// decision for the interface stories. Navigation comes with NAV-01.
class HexaBlockApp extends StatelessWidget {
  /// The app showing [home].
  const HexaBlockApp({required this.home, super.key});

  /// The first screen.
  final Widget home;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: AppColors.background,
    onGenerateTitle: (context) =>
        AppLocalizations.of(context).gameTitleHexaLines,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    textStyle: AppTextStyles.body,
    // A route, not a builder: the Navigator brings the Overlay that a
    // dragged piece floats on (HL-02).
    home: home,
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
  );
}
