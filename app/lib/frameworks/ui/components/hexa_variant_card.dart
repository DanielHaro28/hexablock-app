import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_radii.dart';
import '../../theme/hexa_typography.dart';
import 'hexa_icon.dart';
import 'hexa_menu.dart';
import 'hexa_tappable.dart';

/// What the footer of a [HexaVariantCard] says.
sealed class HexaVariantCardFooter {
  const HexaVariantCardFooter();
}

/// A line of `note-strong` text, such as «Récord 12 850» or «Continuar»,
/// with an optional 16 icon before it.
final class HexaCardMeta extends HexaVariantCardFooter {
  /// The footer [text], with [icon] before it if given.
  const HexaCardMeta(this.text, {this.icon});

  /// The text.
  final String text;

  /// An optional icon, such as `play` for «Continue».
  final HexaIconName? icon;
}

/// The «Nuevo» / «New» badge of a game never played.
final class HexaCardNew extends HexaVariantCardFooter {
  /// The badge with its localized [label].
  const HexaCardNew(this.label);

  /// «Nuevo» or «New».
  final String label;
}

/// The game picker tile of the home screen (component VariantCard).
///
/// 163×212 at the base width, `surface`, `radius-card`, `shadow-soft`,
/// padding 16, gap 8. The 72 dp [artwork] is the game's own SVG, its
/// colored blob included. Title in `subtitle`, description in `note`
/// `ink-soft`, footer at the bottom. With a [menu], a 48 dp «more» button
/// sits in the top-right corner. The card grows taller when its texts need
/// more lines (up to 30 % longer in English): it never cuts them.
///
/// It knows no game: the screen passes the texts, the artwork and what a
/// tap does.
class HexaVariantCard extends StatelessWidget {
  /// A card for one game.
  const HexaVariantCard({
    required this.title,
    required this.description,
    required this.artwork,
    required this.onTap,
    this.footer,
    this.menu,
    super.key,
  });

  /// The minimum height of a card.
  static const double minHeight = 212;

  /// The size of the artwork.
  static const double artworkSize = 72;

  /// The size of the footer icon.
  static const double _footerIconSize = 16;

  /// The game's name.
  final String title;

  /// One short sentence about the game.
  final String description;

  /// The asset of the game's SVG.
  final String artwork;

  /// What a tap on the card does.
  final VoidCallback onTap;

  /// What the footer says, or `null` for nothing.
  final HexaVariantCardFooter? footer;

  /// The «more» menu, only when the card has secondary actions.
  final HexaMenu? menu;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    final top = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          artwork,
          width: artworkSize,
          height: artworkSize,
          excludeFromSemantics: true,
        ),
        const SizedBox(height: HexaSpacing.s8),
        Text(title, style: HexaTypography.subtitle),
        const SizedBox(height: HexaSpacing.s8),
        Text(
          description,
          style: HexaTypography.note.copyWith(color: colors.inkSoft),
        ),
      ],
    );
    final bottom = switch (footer) {
      null => null,
      final HexaCardMeta meta => Row(
        children: [
          if (meta.icon case final icon?) ...[
            HexaIcon(icon, size: _footerIconSize, color: colors.ink),
            const SizedBox(width: HexaSpacing.s8),
          ],
          Flexible(child: Text(meta.text, style: HexaTypography.noteStrong)),
        ],
      ),
      final HexaCardNew badge => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          constraints: const BoxConstraints(minHeight: HexaSizes.badge),
          padding: const EdgeInsets.symmetric(horizontal: HexaSpacing.s8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.badge,
            borderRadius: BorderRadius.circular(HexaRadii.of(context).pill),
          ),
          child: Text(
            badge.label,
            style: HexaTypography.badge.copyWith(color: colors.ink),
          ),
        ),
      ),
    };
    final card = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: minHeight),
      child: HexaTappable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HexaRadii.of(context).card),
        child: Padding(
          padding: const EdgeInsets.all(HexaSpacing.s16),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: constraints.hasBoundedHeight
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                top,
                if (bottom != null) ...[
                  const SizedBox(height: HexaSpacing.s8),
                  bottom,
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return switch (menu) {
      null => card,
      final menu => Stack(
        fit: StackFit.passthrough,
        children: [
          card,
          PositionedDirectional(
            top: HexaSpacing.s8,
            end: HexaSpacing.s8,
            child: menu,
          ),
        ],
      ),
    };
  }
}
