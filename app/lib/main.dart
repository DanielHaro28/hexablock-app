import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'config/dependencies.dart';
import 'config/hexa_lines_module.dart';
import 'frameworks/ui/hexablock_app.dart';

/// Composition root (layer 4, ARQ-03 §6).
///
/// It registers the topologies and the variant modules and opens Hexa Lines
/// directly (D-136). NAV-01 replaces that `home` with the home screen.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;
  await registerDependencies(getIt, rootBundle);
  runApp(HexaBlockApp(home: openGame(getIt, HexaLinesModule.id)));
}
