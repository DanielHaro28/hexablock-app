import 'dart:ui';

/// The color tokens of the design (D-66, REVISION-DISENO: the colors live in
/// the theme, not in the screens).
///
/// They follow the proposal of the design PDF: a warm light background,
/// white cards, a dark ink and one accent per game. The interface stories
/// (T-05) adjust them here.
abstract final class AppColors {
  /// The background of every screen.
  static const background = Color(0xFFF8F3EC);

  /// Cards and panels on the background.
  static const surface = Color(0xFFFFFCF8);

  /// Text and strong lines.
  static const ink = Color(0xFF3A3340);

  /// Secondary text, such as the label of a marker.
  static const inkMuted = Color(0xFF8C8490);

  /// An empty cell of the board.
  static const emptyCell = Color(0xFFEDE7E0);

  /// The accent of Hexa Lines (blue, REVISION-DISENO).
  static const hexaLines = Color(0xFF9CC3EA);

  /// The cells of a piece over a position where it does not fit (HL-02).
  /// The design does not draw it yet: @dicpc confirms it (D-66, D-138).
  static const invalidPreview = Color(0xB3E5675C);

  /// How opaque the cells of a piece over a valid position are (HL-02): the
  /// piece's own color, lighter, so the board shows through.
  static const double previewOpacity = 0.55;

  /// The outline of an empty tray slot while its piece is being dragged.
  static const draggedSlot = inkMuted;

  /// A piece color whose name the palette does not know.
  static const unknownPiece = Color(0xFFB8B2AC);

  /// The piece palette, by the color names of the configuration (D-131).
  static const Map<String, Color> pieces = {
    'red': Color(0xFFEE8A78),
    'orange': Color(0xFFF4B88E),
    'yellow': Color(0xFFF6D77F),
    'green': Color(0xFFB4DBB0),
    'teal': Color(0xFF9ED6CB),
    'blue': Color(0xFF9CC3EA),
    'purple': Color(0xFFC8B8EC),
    'pink': Color(0xFFF2A8B8),
  };

  /// The color of a piece named [name] in the configuration.
  static Color piece(String name) => pieces[name] ?? unknownPiece;
}
