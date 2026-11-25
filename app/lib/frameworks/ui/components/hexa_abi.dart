import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// The poses of Abi, the mascot (component Abi).
enum AbiPose {
  /// Waving: home and tutorial, on a `sky` blob.
  wave('assets/mascot/abi-saludando.svg'),

  /// Celebrating: victory, big combos and records, on a `lilac` blob.
  celebrate('assets/mascot/abi-celebrando.svg'),

  /// Hugging a cup: defeat, pause and offline, on a `mint` blob.
  cup('assets/mascot/abi-taza.svg');

  const AbiPose(this.asset);

  /// The SVG of the pose, with its blob, copied from the design system.
  final String asset;
}

/// Abi, the little bee (component Abi). She is never redrawn: each pose is
/// the design system's SVG, blob included.
class HexaAbi extends StatelessWidget {
  /// Abi in [pose], [size] wide and high, described by [label].
  const HexaAbi({
    required this.pose,
    required this.label,
    this.size = defaultSize,
    super.key,
  });

  /// The size on dialogs.
  static const double dialogSize = 112;

  /// The size on home and loading (240 to 280 in the design system).
  static const double defaultSize = 240;

  /// Which pose.
  final AbiPose pose;

  /// What a screen reader says, such as «Abi, la abejita, saludando».
  final String label;

  /// Width and height.
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    image: true,
    child: SvgPicture.asset(
      pose.asset,
      width: size,
      height: size,
      excludeFromSemantics: true,
    ),
  );
}
