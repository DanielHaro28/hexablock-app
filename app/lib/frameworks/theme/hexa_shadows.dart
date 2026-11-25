import 'package:material_ui/material_ui.dart';

/// The shadow tokens of the design system (`tokens.json`, D-152), read with
/// `HexaShadows.of(context)`.
@immutable
final class HexaShadows extends ThemeExtension<HexaShadows> {
  /// Shadows with every token.
  const HexaShadows({
    required this.soft,
    required this.pressed,
    required this.lifted,
  });

  /// The shadows of the design system.
  static const standard = HexaShadows(
    soft: [
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 16,
        color: Color.fromRGBO(74, 59, 71, 0.10),
      ),
    ],
    pressed: [
      BoxShadow(offset: Offset(0, 3), color: Color.fromRGBO(74, 59, 71, 0.12)),
    ],
    lifted: [
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 8,
        color: Color.fromRGBO(74, 59, 71, 0.18),
      ),
    ],
  );

  /// The shadows of the nearest theme.
  static HexaShadows of(BuildContext context) =>
      Theme.of(context).extension<HexaShadows>() ?? standard;

  /// The only resting shadow: cards, tray, buttons, board.
  final List<BoxShadow> soft;

  /// A pressed button. The token is an inset shadow, which a [BoxShadow]
  /// cannot draw: a pressed component draws it inside its own shape and
  /// moves down 2 dp.
  final List<BoxShadow> pressed;

  /// A piece while it is dragged.
  final List<BoxShadow> lifted;

  @override
  HexaShadows copyWith({
    List<BoxShadow>? soft,
    List<BoxShadow>? pressed,
    List<BoxShadow>? lifted,
  }) => HexaShadows(
    soft: soft ?? this.soft,
    pressed: pressed ?? this.pressed,
    lifted: lifted ?? this.lifted,
  );

  @override
  HexaShadows lerp(HexaShadows? other, double t) {
    if (other == null) return this;
    return HexaShadows(
      soft: BoxShadow.lerpList(soft, other.soft, t)!,
      pressed: BoxShadow.lerpList(pressed, other.pressed, t)!,
      lifted: BoxShadow.lerpList(lifted, other.lifted, t)!,
    );
  }
}
