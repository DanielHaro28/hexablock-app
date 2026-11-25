import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/hexa_colors.dart';
import '../../../theme/hexa_metrics.dart';
import '../../../theme/hexa_typography.dart';
import '../../components/hexa_icon.dart';
import '../../components/hexa_top_bar.dart';

/// A temporary screen for a route whose story has not arrived yet (NAV-01):
/// the level selection of Hexa Fit and Hexa Sort (HF-01, HS-01), the Hexa
/// Merge game (HM-01) and the settings (NAV-02). It only says so and goes
/// back. Each story replaces it in the composition root.
class PlaceholderScreen extends StatelessWidget {
  /// A temporary screen titled [title].
  const PlaceholderScreen({
    required this.title,
    required this.onBack,
    super.key,
  });

  /// The title of the screen that will be here.
  final String title;

  /// Goes back to the previous screen.
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ColoredBox(
      color: HexaColors.of(context).bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HexaTopBar(
              title: title,
              leading: HexaTopBarAction(
                icon: HexaIconName.back,
                label: texts.navigationBack,
                onPressed: onBack,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(HexaSpacing.s24),
                  child: Text(
                    texts.placeholderComingSoon,
                    textAlign: TextAlign.center,
                    style: HexaTypography.body,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
