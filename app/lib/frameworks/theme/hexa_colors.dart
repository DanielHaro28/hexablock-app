import 'package:material_ui/material_ui.dart';

/// The color tokens of the design system (`docs/design/sistema/tokens.json`,
/// D-152), read with `HexaColors.of(context)`.
///
/// Every field is one token; the role and game tokens are aliases of a
/// pastel, so they are getters. A test checks that the values match the
/// tokens file.
@immutable
final class HexaColors extends ThemeExtension<HexaColors> {
  /// A palette with every token.
  const HexaColors({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.inkSoft,
    required this.rose,
    required this.sky,
    required this.butter,
    required this.peach,
    required this.mint,
    required this.lilac,
    required this.sage,
    required this.coral,
    required this.cellEmpty,
    required this.cellLocked,
    required this.scrim,
    required this.track,
    required this.handle,
    required this.tileStroke,
    required this.stackStroke,
    required this.tileHighlight,
    required this.hint,
    required this.blob,
  });

  /// The only theme of the design system, «Crema».
  static const crema = HexaColors(
    bg: Color(0xFFFBF6EE),
    surface: Color(0xFFFFFDF9),
    ink: Color(0xFF4A3B47),
    inkSoft: Color(0xFF7A6772),
    rose: Color(0xFFF4B6C2),
    sky: Color(0xFFA9CDEB),
    butter: Color(0xFFF7D774),
    peach: Color(0xFFF2C29B),
    mint: Color(0xFFB8E0C8),
    lilac: Color(0xFFD5C8F0),
    sage: Color(0xFFB5C39B),
    coral: Color(0xFFEE9B8F),
    cellEmpty: Color.fromRGBO(74, 59, 71, 0.07),
    cellLocked: Color.fromRGBO(74, 59, 71, 0.14),
    scrim: Color.fromRGBO(74, 59, 71, 0.28),
    track: Color.fromRGBO(74, 59, 71, 0.10),
    handle: Color.fromRGBO(74, 59, 71, 0.20),
    tileStroke: Color.fromRGBO(74, 59, 71, 0.18),
    stackStroke: Color.fromRGBO(74, 59, 71, 0.22),
    tileHighlight: Color.fromRGBO(255, 253, 249, 0.28),
    hint: Color.fromRGBO(247, 215, 116, 0.55),
    blob: Color.fromRGBO(74, 59, 71, 0.06),
  );

  /// The palette of the nearest theme.
  static HexaColors of(BuildContext context) =>
      Theme.of(context).extension<HexaColors>() ?? crema;

  /// The screen background (cream).
  final Color bg;

  /// Cards, tray, sheets, chips and board.
  final Color surface;

  /// Text, icons and the board outline.
  final Color ink;

  /// Secondary text, only on [bg] or [surface].
  final Color inkSoft;

  /// A tile pastel.
  final Color rose;

  /// A tile pastel.
  final Color sky;

  /// A tile pastel.
  final Color butter;

  /// A tile pastel.
  final Color peach;

  /// A tile pastel.
  final Color mint;

  /// A tile pastel.
  final Color lilac;

  /// A tile pastel.
  final Color sage;

  /// A tile pastel.
  final Color coral;

  /// An empty board cell.
  final Color cellEmpty;

  /// A locked cell or option.
  final Color cellLocked;

  /// The veil behind a sheet.
  final Color scrim;

  /// The track of a progress bar.
  final Color track;

  /// The handle of a sheet.
  final Color handle;

  /// The outline of a tile.
  final Color tileStroke;

  /// The outline of a stack.
  final Color stackStroke;

  /// The glint on a tile.
  final Color tileHighlight;

  /// A hint on the board.
  final Color hint;

  /// The soft hexagonal blob behind an illustration.
  final Color blob;

  /// Primary actions.
  Color get primary => lilac;

  /// Secondary actions.
  Color get secondary => peach;

  /// Count badges.
  Color get badge => coral;

  /// Success.
  Color get success => mint;

  /// Stars.
  Color get star => butter;

  /// The color of Hexa Lines.
  Color get gameLines => sky;

  /// The color of Hexa Fit.
  Color get gameFit => mint;

  /// The color of Hexa Sort.
  Color get gameSort => peach;

  /// The color of Hexa Merge.
  Color get gameMerge => lilac;

  /// The tile of value 2 in Hexa Merge.
  Color get merge2 => butter;

  /// The tile of value 4 in Hexa Merge.
  Color get merge4 => peach;

  /// The tile of value 8 in Hexa Merge.
  Color get merge8 => rose;

  /// The tile of value 16 in Hexa Merge.
  Color get merge16 => coral;

  /// The tile of value 32 in Hexa Merge.
  Color get merge32 => lilac;

  /// The tile of value 64 in Hexa Merge.
  Color get merge64 => sky;

  /// The tile of value 128 in Hexa Merge.
  Color get merge128 => mint;

  /// The tile of value 256 in Hexa Merge.
  Color get merge256 => sage;

  @override
  HexaColors copyWith({
    Color? bg,
    Color? surface,
    Color? ink,
    Color? inkSoft,
    Color? rose,
    Color? sky,
    Color? butter,
    Color? peach,
    Color? mint,
    Color? lilac,
    Color? sage,
    Color? coral,
    Color? cellEmpty,
    Color? cellLocked,
    Color? scrim,
    Color? track,
    Color? handle,
    Color? tileStroke,
    Color? stackStroke,
    Color? tileHighlight,
    Color? hint,
    Color? blob,
  }) => HexaColors(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    ink: ink ?? this.ink,
    inkSoft: inkSoft ?? this.inkSoft,
    rose: rose ?? this.rose,
    sky: sky ?? this.sky,
    butter: butter ?? this.butter,
    peach: peach ?? this.peach,
    mint: mint ?? this.mint,
    lilac: lilac ?? this.lilac,
    sage: sage ?? this.sage,
    coral: coral ?? this.coral,
    cellEmpty: cellEmpty ?? this.cellEmpty,
    cellLocked: cellLocked ?? this.cellLocked,
    scrim: scrim ?? this.scrim,
    track: track ?? this.track,
    handle: handle ?? this.handle,
    tileStroke: tileStroke ?? this.tileStroke,
    stackStroke: stackStroke ?? this.stackStroke,
    tileHighlight: tileHighlight ?? this.tileHighlight,
    hint: hint ?? this.hint,
    blob: blob ?? this.blob,
  );

  @override
  HexaColors lerp(HexaColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return HexaColors(
      bg: mix(bg, other.bg),
      surface: mix(surface, other.surface),
      ink: mix(ink, other.ink),
      inkSoft: mix(inkSoft, other.inkSoft),
      rose: mix(rose, other.rose),
      sky: mix(sky, other.sky),
      butter: mix(butter, other.butter),
      peach: mix(peach, other.peach),
      mint: mix(mint, other.mint),
      lilac: mix(lilac, other.lilac),
      sage: mix(sage, other.sage),
      coral: mix(coral, other.coral),
      cellEmpty: mix(cellEmpty, other.cellEmpty),
      cellLocked: mix(cellLocked, other.cellLocked),
      scrim: mix(scrim, other.scrim),
      track: mix(track, other.track),
      handle: mix(handle, other.handle),
      tileStroke: mix(tileStroke, other.tileStroke),
      stackStroke: mix(stackStroke, other.stackStroke),
      tileHighlight: mix(tileHighlight, other.tileHighlight),
      hint: mix(hint, other.hint),
      blob: mix(blob, other.blob),
    );
  }
}
