import 'package:flutter/widgets.dart';

import 'frameworks/ui/hexablock_app.dart';

/// Composition root (layer 4).
///
/// The stories add the wiring of ARQ-01-APP §6.3 here: database and adapters,
/// the variant and topology registry, the aspects around the use cases and
/// the active profile.
void main() {
  runApp(const HexaBlockApp());
}
