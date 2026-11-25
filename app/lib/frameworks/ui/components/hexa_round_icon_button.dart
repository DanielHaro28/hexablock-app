import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_typography.dart';
import 'hexa_icon.dart';
import 'hexa_tappable.dart';

/// A circular icon action with an optional count badge (component
/// RoundIconButton).
///
/// A `surface` circle with `shadow-soft` and a 24 `ink` icon; disabled, `bg`
/// with a dashed `ink-soft` border and an `ink-soft` icon. The badge is 22
/// high, `badge` (coral) with `ink` text and a 2 dp `surface` ring, at
/// (−4, −4).
class HexaRoundIconButton extends StatelessWidget {
  /// A button showing [icon], announced as [label].
  const HexaRoundIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.badge,
    this.badgeLabel,
    this.size = HexaSizes.button,
    this.elevated = true,
    super.key,
  }) : assert(size >= HexaSizes.touch, 'smaller than the 48 dp touch area');

  /// The size in a top bar or tray.
  static const double compactSize = HexaSizes.touch;

  /// The icon.
  final HexaIconName icon;

  /// The spoken name: the icon has no text.
  final String label;

  /// What a tap does; `null` disables the button.
  final VoidCallback? onPressed;

  /// A count shown on the badge, or `null` for none.
  final int? badge;

  /// What a screen reader says for the badge, such as «5 pasos para
  /// deshacer», translated by the caller. Without it the count is only seen.
  final String? badgeLabel;

  /// 56 by default, [compactSize] in a top bar or tray.
  final double size;

  /// Whether it is a raised circle or a flat icon, such as the «more»
  /// button inside a card.
  final bool elevated;

  /// The badge's distance outside the button's corner.
  static const double _badgeOffset = -4;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    final enabled = onPressed != null;
    final button = SizedBox.square(
      dimension: size,
      child: HexaTappable(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        elevated: elevated,
        label: label,
        value: badge == null ? null : badgeLabel,
        child: Center(
          child: HexaIcon(icon, color: enabled ? colors.ink : colors.inkSoft),
        ),
      ),
    );
    return switch (badge) {
      null => button,
      final count => Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: _badgeOffset,
            right: _badgeOffset,
            child: _Badge(count),
          ),
        ],
      ),
    };
  }
}

final class _Badge extends StatelessWidget {
  const _Badge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    return ExcludeSemantics(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: HexaSizes.badge,
          minHeight: HexaSizes.badge,
        ),
        padding: const EdgeInsets.symmetric(horizontal: HexaSpacing.s4),
        decoration: BoxDecoration(
          color: colors.badge,
          borderRadius: BorderRadius.circular(HexaSizes.badge / 2),
          border: Border.all(
            color: colors.surface,
            width: HexaBorders.chip,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$count',
          style: HexaTypography.badge.copyWith(color: colors.ink),
        ),
      ),
    );
  }
}
