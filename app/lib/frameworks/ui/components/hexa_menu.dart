import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_radii.dart';
import '../../theme/hexa_shadows.dart';
import '../../theme/hexa_typography.dart';
import 'hexa_icon.dart';
import 'hexa_round_icon_button.dart';

/// One action of a [HexaMenu].
final class HexaMenuItem {
  /// An item that shows [label] and runs [onSelected].
  const HexaMenuItem({
    required this.label,
    required this.onSelected,
    this.icon,
  });

  /// The text of the item.
  final String label;

  /// What choosing it does; `null` disables it.
  final VoidCallback? onSelected;

  /// An optional 24 icon before the text.
  final HexaIconName? icon;
}

/// Which way a [HexaMenu] opens from its button.
enum HexaMenuAlign {
  /// Towards the end (right in a left-to-right layout): for buttons on the
  /// start side of the screen, such as the left column of the home grid.
  start,

  /// Towards the start: for buttons on the end side of the screen.
  end,
}

/// A short list of secondary actions that opens from a «more» button
/// (component Menu).
///
/// `surface`, `radius-card`, `shadow-soft`, padding 8 0; each item 48 high,
/// padding 0 16, `body-strong` in `ink`, with an optional 24 icon. It opens
/// below its button towards the side with room, and closes on a choice, on
/// tapping outside or with Back. It uses Material's [MenuAnchor] for focus,
/// keyboard and dismissal (D-148). Keep it to 1 to 3 items: the main action
/// never hides in a menu.
class HexaMenu extends StatelessWidget {
  /// A «more» button announced as [label] that opens [items].
  const HexaMenu({
    required this.label,
    required this.items,
    this.align = HexaMenuAlign.end,
    this.elevated = true,
    super.key,
  });

  /// The spoken name of the button, such as «More options».
  final String label;

  /// The actions.
  final List<HexaMenuItem> items;

  /// Which way the menu opens.
  final HexaMenuAlign align;

  /// Whether the button is a raised circle or a flat icon (inside a card).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    final direction = Directionality.of(context);
    final reversed = switch (direction) {
      TextDirection.ltr => TextDirection.rtl,
      TextDirection.rtl => TextDirection.ltr,
    };
    const transparent = WidgetStatePropertyAll(Color(0x00000000));
    // A menu starts at its anchor point and grows towards the end. To open
    // towards the start, the anchor is laid out in the reverse direction,
    // and the button and the items keep the screen's own.
    return Directionality(
      textDirection: align == HexaMenuAlign.end ? reversed : direction,
      child: MenuAnchor(
        style: const MenuStyle(
          backgroundColor: transparent,
          shadowColor: transparent,
          surfaceTintColor: transparent,
          elevation: WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          alignment: AlignmentDirectional.bottomStart,
        ),
        menuChildren: [
          Directionality(
            textDirection: direction,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(HexaRadii.of(context).card),
                boxShadow: HexaShadows.of(context).soft,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: HexaSpacing.s8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final item in items) _item(item, colors)],
                ),
              ),
            ),
          ),
        ],
        builder: (context, controller, _) => Directionality(
          textDirection: direction,
          child: HexaRoundIconButton(
            icon: HexaIconName.more,
            label: label,
            size: HexaRoundIconButton.compactSize,
            elevated: elevated,
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
      ),
    );
  }

  Widget _item(HexaMenuItem item, HexaColors colors) => MenuItemButton(
    onPressed: item.onSelected,
    leadingIcon: switch (item.icon) {
      null => null,
      final icon => HexaIcon(
        icon,
        color: item.onSelected == null ? colors.inkSoft : colors.ink,
      ),
    },
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, HexaSizes.touch)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: HexaSpacing.s16),
      ),
      textStyle: const WidgetStatePropertyAll(HexaTypography.bodyStrong),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? colors.inkSoft : colors.ink,
      ),
      overlayColor: WidgetStatePropertyAll(colors.cellEmpty),
    ),
    child: Text(item.label),
  );
}
