import 'package:flutter/material.dart';

/// Root widget of the app.
///
/// Theme, navigation and localized texts (es and en) come with the interface
/// stories; until then it shows an empty screen with no fixed texts.
class HexaBlockApp extends StatelessWidget {
  /// Creates the root widget.
  const HexaBlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold());
  }
}
