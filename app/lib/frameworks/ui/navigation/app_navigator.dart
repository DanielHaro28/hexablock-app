import 'package:material_ui/material_ui.dart';

import 'app_route.dart';

/// Builds the screen of a route. The composition root gives it, so the
/// screens never build each other (D-149).
typedef AppPageBuilder = Widget Function(AppRoute route);

/// Moves between the screens of the app with Flutter's [Navigator] (D-149).
///
/// The screens ask it for an [AppRoute]; what each route shows is decided by
/// the [AppPageBuilder] of the composition root.
final class AppNavigator {
  /// A navigator that builds each screen with [_pageFor].
  AppNavigator(this._pageFor);

  final AppPageBuilder _pageFor;

  /// The first screen of the app.
  Widget get home => _pageFor(const HomeRoute());

  /// Opens [route] on top of the current screen and completes when the
  /// player comes back from it.
  Future<void> push(BuildContext context, AppRoute route) =>
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => _pageFor(route)));

  /// Goes back to the previous screen.
  void back(BuildContext context) => Navigator.of(context).maybePop();

  /// Goes back to the home screen and empties the stack, as «Volver al
  /// menú» does.
  void backToHome(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);
}
