import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'config/dependencies.dart';
import 'config/hexa_lines_module.dart';
import 'frameworks/platform/error_handlers.dart';
import 'frameworks/platform/platform_logger.dart';
import 'frameworks/ui/hexablock_app.dart';

/// Composition root (layer 4, ARQ-03 §6).
///
/// It sends the errors outside the use cases to the log first (D-163), so
/// a failure while starting is logged too. Then it registers the topologies
/// and the variant modules and opens Hexa Lines directly (D-136). NAV-01
/// replaces that `home` with the home screen.
Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  final logger = PlatformLogger(verbose: kDebugMode);
  installErrorHandlers(logger, binding.platformDispatcher, verbose: kDebugMode);
  final getIt = GetIt.instance;
  await registerDependencies(getIt, rootBundle, logger: logger);
  runApp(HexaBlockApp(home: openGame(getIt, HexaLinesModule.id)));
}
