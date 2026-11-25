import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_colors.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_abi.dart';
import 'package:hexablock_app/frameworks/ui/components/hexa_icon.dart';
import 'package:material_ui/material_ui.dart';

import 'themed.dart';

void main() {
  group('HexaIcon', () {
    test('should_have_a_bundled_svg_when_any_icon_is_named', () {
      // Arrange
      const names = HexaIconName.values;

      // Act
      final missing = [
        for (final name in names)
          if (!File(name.asset).existsSync()) name.asset,
      ];

      // Assert
      expect(missing, isEmpty);
    });

    test('should_point_to_the_kebab_case_file_when_the_name_has_two_words', () {
      // Arrange
      const name = HexaIconName.starFilled;

      // Act
      final asset = name.asset;

      // Assert
      expect(asset, 'assets/icons/star-filled.svg');
    });

    testWidgets('should_be_skipped_by_screen_readers_when_it_has_no_label', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(tester, const HexaIcon(HexaIconName.play));

      // Assert
      expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
      handle.dispose();
    });

    testWidgets('should_be_announced_when_it_stands_alone_with_a_label', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        const HexaIcon(HexaIconName.alert, label: 'Error'),
      );

      // Assert
      expect(find.bySemanticsLabel('Error'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('should_tint_the_strokes_when_a_disabled_color_is_given', (
      tester,
    ) async {
      // Arrange
      final inkSoft = HexaColors.crema.inkSoft;

      // Act
      await pumpThemed(tester, HexaIcon(HexaIconName.lock, color: inkSoft));

      // Assert
      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(picture.colorFilter, ColorFilter.mode(inkSoft, BlendMode.srcIn));
    });
  });

  group('HexaAbi', () {
    test('should_have_a_bundled_svg_when_any_pose_is_used', () {
      // Arrange
      const poses = AbiPose.values;

      // Act
      final missing = [
        for (final pose in poses)
          if (!File(pose.asset).existsSync()) pose.asset,
      ];

      // Assert
      expect(missing, isEmpty);
    });

    testWidgets('should_draw_the_waving_pose_with_its_label_when_on_home', (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();

      // Act
      await pumpThemed(
        tester,
        const HexaAbi(pose: AbiPose.wave, label: 'Abi saludando'),
      );

      // Assert
      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(picture.width, HexaAbi.defaultSize);
      expect(find.bySemanticsLabel('Abi saludando'), findsOneWidget);
      handle.dispose();
    });
  });
}
