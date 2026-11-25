/// Sizes of the game screens that the design system does not define yet.
///
/// Spacing, radii and borders are tokens in `HexaSpacing`, `HexaRadii` and
/// `HexaBorders` (D-152). These stay here until the game screens follow the
/// design system: the TopBar has no accent dot, and the system lifts a
/// dragged piece 48 dp and grows it 15 % (HL-02 uses cells).
abstract final class AppSizes {
  /// The colored dot next to a game's name.
  static const double accentDot = 12;

  /// How far above the finger a dragged piece goes, in cells, so the finger
  /// does not hide it (HL-02, page 24 of the design).
  static const double dragLiftCells = 1.5;

  /// The size of a cell of a piece, as the distance from its center to its
  /// corners, before the board is laid out (HL-02).
  static const double fallbackCellScale = 16;

  /// The dashes of the outline of an empty tray slot while its piece is
  /// dragged (page 24 of the design).
  static const double dashLength = 6;

  /// The gaps between those dashes.
  static const double dashGap = 4;
}
