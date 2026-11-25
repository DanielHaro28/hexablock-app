import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/theme/hexa_colors.dart';
import 'package:hexablock_app/frameworks/theme/hexa_metrics.dart';
import 'package:hexablock_app/frameworks/theme/hexa_radii.dart';
import 'package:hexablock_app/frameworks/theme/hexa_shadows.dart';
import 'package:hexablock_app/frameworks/theme/hexa_typography.dart';
import 'package:material_ui/material_ui.dart';

/// The tokens are copied by hand from the design system (D-152): these tests
/// fail as soon as the Dart values and `tokens.json` drift apart, or a token
/// is added or removed on either side.
void main() {
  final tokens = jsonDecode(
    File('../docs/design/sistema/tokens.json').readAsStringSync(),
  ) as Map<String, Object?>;

  List<Map<String, Object?>> listOf(String group) => [
    for (final token
        in (tokens[group]! as Map<String, Object?>)['tokens']! as List<Object?>)
      token! as Map<String, Object?>,
  ];

  Map<String, String> valuesOf(String group) => {
    for (final token in listOf(group))
      token['name']! as String: token['value']! as String,
  };

  double px(String value) => double.parse(value.replaceAll('px', ''));

  group('D-152', () {
    test('should_match_every_color_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('color');
      Color resolve(String value) => switch (value) {
        _ when value.startsWith('{') => resolve(
          json[value.substring(1, value.length - 1)]!,
        ),
        _ when value.startsWith('#') => Color(
          int.parse('FF${value.substring(1)}', radix: 16),
        ),
        _ => switch (RegExp(r'[\d.]+').allMatches(value).toList()) {
          [final r, final g, final b, final a] => Color.fromRGBO(
            int.parse(r[0]!),
            int.parse(g[0]!),
            int.parse(b[0]!),
            double.parse(a[0]!),
          ),
          _ => throw FormatException('unknown color', value),
        },
      };
      const c = HexaColors.crema;

      // Act
      final dart = <String, Color>{
        'bg': c.bg,
        'surface': c.surface,
        'ink': c.ink,
        'ink-soft': c.inkSoft,
        'rose': c.rose,
        'sky': c.sky,
        'butter': c.butter,
        'peach': c.peach,
        'mint': c.mint,
        'lilac': c.lilac,
        'sage': c.sage,
        'coral': c.coral,
        'primary': c.primary,
        'secondary': c.secondary,
        'badge': c.badge,
        'success': c.success,
        'star': c.star,
        'game-lines': c.gameLines,
        'game-fit': c.gameFit,
        'game-sort': c.gameSort,
        'game-merge': c.gameMerge,
        'merge-2': c.merge2,
        'merge-4': c.merge4,
        'merge-8': c.merge8,
        'merge-16': c.merge16,
        'merge-32': c.merge32,
        'merge-64': c.merge64,
        'merge-128': c.merge128,
        'merge-256': c.merge256,
        'cell-empty': c.cellEmpty,
        'cell-locked': c.cellLocked,
        'scrim': c.scrim,
        'track': c.track,
        'handle': c.handle,
        'tile-stroke': c.tileStroke,
        'stack-stroke': c.stackStroke,
        'tile-highlight': c.tileHighlight,
        'hint': c.hint,
        'blob': c.blob,
      };

      // Assert
      expect(dart.keys.toSet(), json.keys.toSet());
      for (final MapEntry(:key, :value) in json.entries) {
        expect(dart[key], resolve(value), reason: key);
      }
    });

    test('should_match_every_spacing_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('spacing');

      // Act
      final dart = {
        'space-4': HexaSpacing.s4,
        'space-8': HexaSpacing.s8,
        'space-12': HexaSpacing.s12,
        'space-16': HexaSpacing.s16,
        'space-24': HexaSpacing.s24,
        'space-32': HexaSpacing.s32,
        'space-48': HexaSpacing.s48,
        'space-64': HexaSpacing.s64,
      };

      // Assert
      expect(dart, {for (final e in json.entries) e.key: px(e.value)});
    });

    test('should_match_every_radius_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('radius');
      const r = HexaRadii.standard;

      // Act
      final dart = {
        'radius-cell': r.cell,
        'radius-chip': r.chip,
        'radius-card': r.card,
        'radius-board': r.board,
        'radius-pill': r.pill,
      };

      // Assert
      expect(dart, {for (final e in json.entries) e.key: px(e.value)});
    });

    test('should_match_every_border_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('borderWidth');

      // Act
      final dart = {
        'border-board': HexaBorders.board,
        'border-chip': HexaBorders.chip,
        'border-progress': HexaBorders.progress,
        'stroke-icon': HexaBorders.icon,
        'stroke-illustration': HexaBorders.illustration,
      };

      // Assert
      expect(dart, {for (final e in json.entries) e.key: px(e.value)});
    });

    test('should_match_every_size_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('size');

      // Act
      final dart = {
        'size-touch': HexaSizes.touch,
        'size-button': HexaSizes.button,
        'size-chip': HexaSizes.chip,
        'size-topbar': HexaSizes.topBar,
        'size-icon': HexaSizes.icon,
        'size-badge': HexaSizes.badge,
      };

      // Assert
      expect(dart, {for (final e in json.entries) e.key: px(e.value)});
    });

    test('should_match_every_shadow_token_when_compared_with_tokens_json', () {
      // Arrange
      final json = valuesOf('shadow');
      BoxShadow parse(String value) {
        final numbers = RegExp(r'[\d.]+')
            .allMatches(value)
            .map((m) => double.parse(m[0]!))
            .toList();
        return switch (numbers) {
          [final x, final y, final blur, final r, final g, final b, final a] =>
            BoxShadow(
              offset: Offset(x, y),
              blurRadius: blur,
              color: Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), a),
            ),
          _ => throw FormatException('unknown shadow', value),
        };
      }

      const s = HexaShadows.standard;

      // Act
      final dart = {
        'shadow-soft': s.soft.single,
        'shadow-pressed': s.pressed.single,
        'shadow-lifted': s.lifted.single,
      };

      // Assert
      expect(dart, {for (final e in json.entries) e.key: parse(e.value)});
    });

    test('should_match_every_text_style_when_compared_with_tokens_json', () {
      // Arrange
      final groups =
          (tokens['type']! as Map<String, Object?>)['groups']! as List<Object?>;
      final json = <String, ({Object? family, Map<String, Object?> style})>{};
      for (final group in groups.cast<Map<String, Object?>>()) {
        final styles = (group['styles']! as List<Object?>)
            .cast<Map<String, Object?>>();
        for (final style in styles) {
          json[style['name']! as String] = (
            family: group['name'],
            style: style,
          );
        }
      }

      // Act
      const dart = {
        'display': HexaTypography.display,
        'title': HexaTypography.title,
        'subtitle': HexaTypography.subtitle,
        'number-sm': HexaTypography.numberSm,
        'badge': HexaTypography.badge,
        'body-strong': HexaTypography.bodyStrong,
        'body': HexaTypography.body,
        'label': HexaTypography.label,
        'note-strong': HexaTypography.noteStrong,
        'note': HexaTypography.note,
      };

      // Assert
      expect(dart.keys.toSet(), json.keys.toSet());
      for (final MapEntry(:key, value: (:family, :style)) in json.entries) {
        final text = dart[key]!;
        final size = px(style['fontSize']! as String);
        final weight = style['fontWeight']! as int;
        expect(text.fontFamily, family, reason: key);
        expect(text.fontSize, size, reason: key);
        expect(
          text.height! * size,
          px(style['lineHeight']! as String),
          reason: key,
        );
        expect(text.fontWeight!.value, weight, reason: key);
        expect(text.fontVariations, [
          FontVariation.weight(weight.toDouble()),
        ], reason: key);
        final spacing = switch (style['letterSpacing']) {
          final String em => size * double.parse(em.replaceAll('em', '')),
          _ => null,
        };
        expect(text.letterSpacing, spacing, reason: key);
      }
    });
  });
}
