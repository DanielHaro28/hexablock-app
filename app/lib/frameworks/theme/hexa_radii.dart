import 'package:material_ui/material_ui.dart';

/// The corner radius tokens of the design system (`tokens.json`, D-152),
/// read with `HexaRadii.of(context)`.
@immutable
final class HexaRadii extends ThemeExtension<HexaRadii> {
  /// Radii with every token.
  const HexaRadii({
    required this.cell,
    required this.chip,
    required this.card,
    required this.board,
    required this.pill,
  });

  /// The radii of the design system.
  static const standard = HexaRadii(
    cell: 6,
    chip: 16,
    card: 24,
    board: 28,
    pill: 999,
  );

  /// The radii of the nearest theme.
  static HexaRadii of(BuildContext context) =>
      Theme.of(context).extension<HexaRadii>() ?? standard;

  /// The rounded corners of a hexagon (cell, level bubble, game icon).
  final double cell;

  /// Chips and tray slots.
  final double chip;

  /// Cards, tray, ScoreCard, VariantCard and the top of a sheet.
  final double card;

  /// The board.
  final double board;

  /// Everything tappable: buttons, badges, toast.
  final double pill;

  @override
  HexaRadii copyWith({
    double? cell,
    double? chip,
    double? card,
    double? board,
    double? pill,
  }) => HexaRadii(
    cell: cell ?? this.cell,
    chip: chip ?? this.chip,
    card: card ?? this.card,
    board: board ?? this.board,
    pill: pill ?? this.pill,
  );

  @override
  HexaRadii lerp(HexaRadii? other, double t) {
    if (other == null) return this;
    double mix(double a, double b) => a + (b - a) * t;
    return HexaRadii(
      cell: mix(cell, other.cell),
      chip: mix(chip, other.chip),
      card: mix(card, other.card),
      board: mix(board, other.board),
      pill: mix(pill, other.pill),
    );
  }
}
