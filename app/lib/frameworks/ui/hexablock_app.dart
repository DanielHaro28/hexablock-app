import 'package:flutter/widgets.dart';

/// Root widget of the app.
///
/// Theme, navigation and localized texts (es and en) come with the interface
/// stories; until then it shows an empty screen with no fixed texts. It only
/// uses `package:flutter/widgets.dart`: since Flutter 3.47 Material lives in
/// its own package, and adding it is a decision for the interface stories.
class HexaBlockApp extends StatelessWidget {
  /// Creates the root widget.
  const HexaBlockApp({super.key});

  static const Color _background = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: _background,
      builder: (_, _) => const ColoredBox(color: _background),
    );
  }
}
