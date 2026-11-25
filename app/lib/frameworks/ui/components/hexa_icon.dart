import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';

/// The line icons of the design system (component Icon): a 24 grid with
/// 2.2 px round strokes in `ink`.
enum HexaIconName {
  play,
  retry,
  undo,
  rotate,
  sound,
  hint,
  shuffle,
  music,
  stats,
  pause,
  home,
  back,
  settings,
  goal,
  check,
  moves,
  time,
  star,
  lock,
  help,
  more,
  alert,
  starFilled;

  /// The SVG of this icon, copied from the design system.
  String get asset => switch (this) {
    starFilled => 'assets/icons/star-filled.svg',
    _ => 'assets/icons/$name.svg',
  };
}

/// One icon of the design system (component Icon).
///
/// The SVGs are drawn in `ink`. Another [color] (`ink-soft` when disabled)
/// tints the strokes; `star-filled` keeps its butter fill unless a color is
/// given. With a [label] the icon is announced on its own; without one it is
/// decorative and screen readers skip it.
class HexaIcon extends StatelessWidget {
  /// The icon [name] at [size].
  const HexaIcon(
    this.name, {
    this.size = HexaSizes.icon,
    this.color,
    this.label,
    super.key,
  });

  /// Which icon.
  final HexaIconName name;

  /// 24 in buttons, 18 in chips, 16 in cards.
  final double size;

  /// A token color to tint the icon, or `null` for its own colors.
  final Color? color;

  /// What a screen reader says, only when the icon stands alone.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final tint = color;
    final picture = SvgPicture.asset(
      name.asset,
      width: size,
      height: size,
      colorFilter: switch (tint) {
        null => null,
        _ when tint == HexaColors.of(context).ink => null,
        _ => ColorFilter.mode(tint, BlendMode.srcIn),
      },
      excludeFromSemantics: true,
    );
    return switch (label) {
      null => ExcludeSemantics(child: picture),
      final label => Semantics(label: label, image: true, child: picture),
    };
  }
}
