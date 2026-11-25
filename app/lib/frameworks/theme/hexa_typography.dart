import 'package:material_ui/material_ui.dart';

/// The type scale of the design system (`tokens.json`, D-152): Fredoka 600
/// for what is read at a glance and Nunito 500/700 for reading.
///
/// The fonts are bundled TTF files (D-146). They are variable fonts, so each
/// style also sets the `wght` axis: the weight alone does not select it. The
/// styles carry no color: the text takes it from the theme (`ink`).
abstract final class HexaTypography {
  /// The family of [display] to [badge].
  static const displayFamily = 'Fredoka';

  /// The family of [bodyStrong] to [note].
  static const textFamily = 'Nunito';

  /// The suite name on home and loading. One per screen.
  static const display = TextStyle(
    fontFamily: displayFamily,
    fontSize: 40,
    height: 48 / 40,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
  );

  /// Dialog and error titles; ScoreCard values.
  static const title = TextStyle(
    fontFamily: displayFamily,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
  );

  /// 56 dp buttons, top bar, VariantCard, cell numbers, ComboToast.
  static const subtitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
  );

  /// Four-digit cell numbers, compact 48 dp buttons.
  static const numberSm = TextStyle(
    fontFamily: displayFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
  );

  /// Badges and the «New» tag.
  static const badge = TextStyle(
    fontFamily: displayFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
  );

  /// Strong body text and StatChip.
  static const bodyStrong = TextStyle(
    fontFamily: textFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation.weight(700)],
  );

  /// Body text of dialogs and messages.
  static const body = TextStyle(
    fontFamily: textFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation.weight(500)],
  );

  /// Upper-case labels of ScoreCard and section headings (0.08 em).
  static const label = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    height: 18 / 13,
    letterSpacing: 13 * 0.08,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation.weight(700)],
  );

  /// Tray notes, loading state, VariantCard footer.
  static const noteStrong = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation.weight(700)],
  );

  /// Notes and VariantCard descriptions.
  static const note = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation.weight(500)],
  );
}
