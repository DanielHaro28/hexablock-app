import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';

void main() {
  group('HexaBlockApp', () {
    testWidgets('should_show_a_screen_when_the_app_starts', (tester) async {
      // Arrange
      const app = HexaBlockApp();

      // Act
      await tester.pumpWidget(app);

      // Assert
      expect(find.byType(WidgetsApp), findsOneWidget);
    });
  });
}
