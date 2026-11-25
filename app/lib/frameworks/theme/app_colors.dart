import 'dart:ui';

/// Colors of the game screens that the design system does not define yet.
///
/// Every other color is a token in `HexaColors` (D-152). These stay here
/// until @dicpc defines them: the piece palette by the color names of the
/// configuration (D-131) and the invalid preview of HL-02 (D-138).
abstract final class AppColors {
  /// The cells of a piece over a position where it does not fit (HL-02).
  /// The design does not draw it yet: @dicpc confirms it (D-66, D-138).
  static const invalidPreview = Color(0xB3E5675C);

  /// How opaque the cells of a piece over a valid position are (HL-02): the
  /// piece's own color, lighter, so the board shows through.
  static const double previewOpacity = 0.55;

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
