/// The spacing tokens of the design system (`tokens.json`, D-152). They do
/// not change with the theme, so they are constants.
abstract final class HexaSpacing {
  /// The only exception to the rhythm of 8: between board cells.
  static const double s4 = 4;

  /// Icon to text, inside chips and game cards.
  static const double s8 = 8;

  /// Tray and ScoreCard padding, sheet handle.
  static const double s12 = 12;

  /// Inside cards, board padding, side margin of a screen.
  static const double s16 = 16;

  /// Between blocks; horizontal padding of buttons and sheets.
  static const double s24 = 24;

  /// Between sections; bottom padding of sheets.
  static const double s32 = 32;

  /// Minimum touch area.
  static const double s48 = 48;

  /// Margins of a large sheet.
  static const double s64 = 64;
}

/// The border width tokens of the design system (`tokens.json`, D-152).
abstract final class HexaBorders {
  /// The ink outline of the board, an available level bubble and the 512+
  /// ring.
  static const double board = 3;

  /// The colored border of chips and toast, and the dashed border of a
  /// disabled control.
  static const double chip = 2;

  /// The ink border of the progress bar.
  static const double progress = 1.5;

  /// The stroke of a 24 icon.
  static const double icon = 2.2;

  /// The line of Abi and the illustrations.
  static const double illustration = 4;
}

/// The size tokens of the design system (`tokens.json`, D-152).
abstract final class HexaSizes {
  /// Minimum touch target, and buttons in a top bar.
  static const double touch = 48;

  /// Pill buttons and round buttons.
  static const double button = 56;

  /// A chip.
  static const double chip = 40;

  /// The top bar.
  static const double topBar = 72;

  /// An icon in a button.
  static const double icon = 24;

  /// A count badge.
  static const double badge = 22;
}
