import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Pumps [child] centred in a themed Material app, the way the screens use
/// the components.
Future<void> pumpThemed(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    theme: HexaTheme.crema(),
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: Scaffold(body: Center(child: child)),
  ),
);
