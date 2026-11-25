import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'config/dependencies.dart';
import 'frameworks/ui/hexablock_app.dart';
import 'frameworks/ui/navigation/app_navigator.dart';

/// Composition root (layer 4, ARQ-03 §6).
///
/// It registers the topologies, the variant modules and the navigator, and
/// opens the home screen (NAV-01).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;
  await registerDependencies(getIt, rootBundle);
  runApp(HexaBlockApp(home: getIt<AppNavigator>().home));
}
