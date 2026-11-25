import 'package:material_ui/material_ui.dart';

import '../../theme/hexa_colors.dart';
import '../../theme/hexa_metrics.dart';
import '../../theme/hexa_shadows.dart';

/// The touch behavior shared by the tappable components of the design
/// system (README: «Espaciado, radios, sombra» and «Interacción»).
///
/// At rest it draws [color] with `shadow-soft`. Pressed, it drops the
/// shadow, draws `shadow-pressed` inside its shape and moves down 2 dp.
/// Disabled ([onTap] `null`), it draws `bg` with a dashed 2 dp `ink-soft`
/// border, never a global opacity. Focused, a 3 dp `ink` ring with 3 dp of
/// separation. It uses Material's [InkWell] for focus, keyboard and
/// semantics (D-148), without its ripple.
class HexaTappable extends StatefulWidget {
  /// A tappable [child] shaped by [borderRadius].
  const HexaTappable({
    required this.child,
    required this.onTap,
    required this.borderRadius,
    this.color,
    this.elevated = true,
    this.label,
    this.value,
    super.key,
  });

  /// What is drawn inside.
  final Widget child;

  /// What a tap does; `null` disables it.
  final VoidCallback? onTap;

  /// The shape: a pill or a circle uses half its height.
  final BorderRadius borderRadius;

  /// The fill at rest, `surface` by default.
  final Color? color;

  /// Whether it is a raised object (fill and shadow) or a flat one, such as
  /// the «more» button inside a card.
  final bool elevated;

  /// What a screen reader says, if [child] does not say it.
  final String? label;

  /// A value a screen reader says after [label], such as a badge count.
  final String? value;

  @override
  State<HexaTappable> createState() => _HexaTappableState();
}

class _HexaTappableState extends State<HexaTappable> {
  bool _pressed = false;
  bool _focused = false;

  /// How far a pressed control moves down.
  static const double _pressDepth = 2;

  @override
  Widget build(BuildContext context) {
    final colors = HexaColors.of(context);
    final shadows = HexaShadows.of(context);
    final enabled = widget.onTap != null;
    final pressed = enabled && _pressed;
    final fill = switch ((enabled, widget.elevated)) {
      (false, _) => colors.bg,
      (true, true) => widget.color ?? colors.surface,
      (true, false) => widget.color ?? const Color(0x00000000),
    };
    final shape = RoundedRectangleBorder(borderRadius: widget.borderRadius);
    Widget body = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: widget.borderRadius,
        boxShadow: enabled && widget.elevated && !pressed ? shadows.soft : null,
      ),
      child: CustomPaint(
        foregroundPainter: switch ((enabled, pressed)) {
          (false, _) => _DashedBorder(
            color: colors.inkSoft,
            borderRadius: widget.borderRadius,
          ),
          (true, true) when widget.elevated => _InsetShadow(
            shadow: shadows.pressed.first,
            borderRadius: widget.borderRadius,
          ),
          _ => null,
        },
        child: widget.child,
      ),
    );
    body = Material(
      type: MaterialType.transparency,
      shape: shape,
      child: InkWell(
        onTap: widget.onTap,
        customBorder: shape,
        splashFactory: NoSplash.splashFactory,
        highlightColor: const Color(0x00000000),
        hoverColor: const Color(0x00000000),
        focusColor: const Color(0x00000000),
        onHighlightChanged: (value) => setState(() => _pressed = value),
        onFocusChange: (value) => setState(() => _focused = value),
        child: body,
      ),
    );
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: widget.label,
      value: widget.value,
      child: Transform.translate(
        offset: Offset(0, pressed ? _pressDepth : 0),
        child: CustomPaint(
          foregroundPainter: _focused
              ? _FocusRing(color: colors.ink, borderRadius: widget.borderRadius)
              : null,
          child: body,
        ),
      ),
    );
  }
}

/// The focus ring: 3 dp of `ink`, 3 dp away from the shape (9,72:1 on
/// `bg`).
final class _FocusRing extends CustomPainter {
  const _FocusRing({required this.color, required this.borderRadius});

  final Color color;
  final BorderRadius borderRadius;

  /// The width of the ring and its gap to the shape.
  static const double _width = 3;

  @override
  void paint(Canvas canvas, Size size) {
    const grow = _width + _width / 2;
    final ring = (borderRadius + BorderRadius.circular(grow)).toRRect(
      (Offset.zero & size).inflate(grow),
    );
    canvas.drawRRect(
      ring,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _width,
    );
  }

  @override
  bool shouldRepaint(_FocusRing oldDelegate) =>
      oldDelegate.color != color || oldDelegate.borderRadius != borderRadius;
}

/// `shadow-pressed`: an inset band along the top inner edge of the shape.
final class _InsetShadow extends CustomPainter {
  const _InsetShadow({required this.shadow, required this.borderRadius});

  final BoxShadow shadow;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = Path()..addRRect(borderRadius.toRRect(Offset.zero & size));
    final band = Path.combine(
      PathOperation.difference,
      shape,
      shape.shift(shadow.offset),
    );
    canvas.drawPath(band, Paint()..color = shadow.color);
  }

  @override
  bool shouldRepaint(_InsetShadow oldDelegate) =>
      oldDelegate.shadow != shadow || oldDelegate.borderRadius != borderRadius;
}

/// The dashed 2 dp border of a disabled control.
final class _DashedBorder extends CustomPainter {
  const _DashedBorder({required this.color, required this.borderRadius});

  final Color color;
  final BorderRadius borderRadius;

  /// The dashes and gaps of the border.
  static const double _dash = 6;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = HexaBorders.chip / 2;
    final outline = Path()
      ..addRRect(borderRadius.toRRect((Offset.zero & size).deflate(inset)));
    final dashes = Path();
    for (final metric in outline.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += _dash + _gap) {
        dashes.addPath(metric.extractPath(start, start + _dash), Offset.zero);
      }
    }
    canvas.drawPath(
      dashes,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = HexaBorders.chip,
    );
  }

  @override
  bool shouldRepaint(_DashedBorder oldDelegate) =>
      oldDelegate.color != color || oldDelegate.borderRadius != borderRadius;
}
