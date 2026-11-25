import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_typography.dart';
import 'hexa_icon.dart';
import 'hexa_round_icon_button.dart';

/// One button of a [HexaTopBar].
final class HexaTopBarAction {
  /// A 48 dp round button showing [icon], announced as [label].
  const HexaTopBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// The icon.
  final HexaIconName icon;

  /// The spoken name.
  final String label;

  /// What a tap does.
  final VoidCallback onPressed;
}

/// The bar on top of a screen (component TopBar): a button on each side, an
/// optional «?» and a centred title.
///
/// 72 high, transparent over `bg`, padding 0 16, gap 8, 48 dp buttons, title
/// in `subtitle`. A long title takes two lines and the bar grows: it is
/// never cut. A button that does not apply is absent, never disabled.
class HexaTopBar extends StatelessWidget {
  /// A bar with the given buttons and [title].
  const HexaTopBar({
    this.title,
    this.leading,
    this.help,
    this.trailing,
    super.key,
  });

  /// The title, or `null` for none.
  final String? title;

  /// The left button, usually back.
  final HexaTopBarAction? leading;

  /// The «?» button that opens «How to play», beside [trailing].
  final HexaTopBarAction? help;

  /// The right button, usually settings.
  final HexaTopBarAction? trailing;

  @override
  Widget build(BuildContext context) {
    Widget button(HexaTopBarAction? action) => switch (action) {
      null => const SizedBox.square(dimension: HexaSizes.touch),
      final action => HexaRoundIconButton(
        icon: action.icon,
        label: action.label,
        onPressed: action.onPressed,
        size: HexaRoundIconButton.compactSize,
      ),
    };
    final right = [
      if (help != null) ...[
        button(help),
        const SizedBox(width: HexaSpacing.s8),
      ],
      button(trailing),
    ];
    // The title stays centred: the left side reserves as much room as the
    // right one takes.
    final leftWidth = help == null
        ? HexaSizes.touch
        : 2 * HexaSizes.touch + HexaSpacing.s8;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: HexaSizes.topBar),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HexaSpacing.s16),
        child: Row(
          children: [
            SizedBox(
              width: leftWidth,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                heightFactor: 1,
                child: button(leading),
              ),
            ),
            const SizedBox(width: HexaSpacing.s8),
            Expanded(
              child: switch (title) {
                null => const SizedBox.shrink(),
                final title => Semantics(
                  header: true,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: HexaTypography.subtitle,
                  ),
                ),
              },
            ),
            const SizedBox(width: HexaSpacing.s8),
            Row(mainAxisSize: MainAxisSize.min, children: right),
          ],
        ),
      ),
    );
  }
}
