import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// The text styles of the design (D-66), so no screen writes its own sizes.
abstract final class AppTextStyles {
  /// The base style of the app.
  static const body = TextStyle(color: AppColors.ink, fontSize: 16);

  /// The name of a game in the top bar.
  static const title = TextStyle(fontSize: 22, fontWeight: FontWeight.w800);

  /// The label of a marker, such as the score.
  static const markerLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.inkMuted,
  );

  /// The value of a marker.
  static const markerValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );
}
