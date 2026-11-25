import 'package:material_ui/material_ui.dart';

import 'hexa_colors.dart';
import 'hexa_metrics.dart';
import 'hexa_radii.dart';
import 'hexa_shadows.dart';
import 'hexa_typography.dart';

/// The Material theme of the app, built from the design system tokens
/// (D-148, D-152). The components read the tokens from its extensions.
abstract final class HexaTheme {
  /// The «Crema» theme, the only one: the design has no dark mode.
  static ThemeData crema() {
    const colors = HexaColors.crema;
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      fontFamily: HexaTypography.textFamily,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.ink,
        secondary: colors.secondary,
        onSecondary: colors.ink,
        surface: colors.surface,
        onSurface: colors.ink,
        error: colors.coral,
        onError: colors.ink,
      ),
      textTheme: const TextTheme(
        displayLarge: HexaTypography.display,
        titleLarge: HexaTypography.title,
        titleMedium: HexaTypography.subtitle,
        bodyLarge: HexaTypography.bodyStrong,
        bodyMedium: HexaTypography.body,
        bodySmall: HexaTypography.note,
        labelSmall: HexaTypography.label,
      ).apply(bodyColor: colors.ink, displayColor: colors.ink),
      iconTheme: IconThemeData(color: colors.ink, size: HexaSizes.icon),
      extensions: const [
        HexaColors.crema,
        HexaRadii.standard,
        HexaShadows.standard,
      ],
    );
  }
}
