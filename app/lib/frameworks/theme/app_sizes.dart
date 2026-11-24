/// The spacing, corner and line tokens of the design (D-66). Like the
/// colors, they live in the theme so the interface stories (T-05) adjust
/// them in one place.
abstract final class AppSizes {
  /// Between elements inside a panel, such as two tray slots.
  static const double gapSmall = 8;

  /// Inside a panel, between its edge and its content.
  static const double gapMedium = 12;

  /// Around a screen and between its slots.
  static const double gapLarge = 16;

  /// The corners of a tray slot.
  static const double radiusSmall = 16;

  /// The corners of a panel.
  static const double radiusLarge = 24;

  /// The border of the board panel.
  static const double borderWidth = 2;

  /// The colored dot next to a game's name.
  static const double accentDot = 12;
}
