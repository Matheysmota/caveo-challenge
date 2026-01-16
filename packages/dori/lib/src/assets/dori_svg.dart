import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dori_assets.dart';
import 'dori_logo_size.dart';

/// A wrapper widget for rendering SVG assets from the Dori Design System.
///
/// This widget provides a convenient way to display SVG assets with
/// consistent styling and optional color filtering.
///
/// ## Usage
///
/// ```dart
/// // Display the Fish logo with predefined size
/// DoriSvg.fishLogo(size: DoriLogoSize.md)
///
/// // Display any SVG asset with custom dimensions
/// DoriSvg(
///   assetPath: DoriAssets.fishLogo,
///   width: 100,
///   height: 100,
/// )
/// ```
///
/// ## Color Filtering
///
/// For monochromatic SVGs, you can apply a color filter:
///
/// ```dart
/// DoriSvg(
///   assetPath: 'assets/svg/icon.svg',
///   color: Colors.blue,
/// )
/// ```
///
/// Note: The Fish logo is colorful and should NOT use color filtering.
class DoriSvg extends StatelessWidget {
  /// Creates a DoriSvg widget.
  ///
  /// The [assetPath] should be a path relative to the Dori package's
  /// assets directory. Use [DoriAssets] constants for available assets.
  const DoriSvg({
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
    super.key,
  });

  /// Creates a DoriSvg widget displaying the Fish logo.
  ///
  /// The [size] parameter defines the predefined dimensions for the logo.
  /// Use [DoriLogoSize] to select the appropriate size for your context:
  ///
  /// - [DoriLogoSize.sm] (32x32): AppBar, compact spaces
  /// - [DoriLogoSize.md] (120x120): Splash screen
  /// - [DoriLogoSize.lg] (180x180): Hero sections, onboarding
  ///
  /// The Fish logo preserves its original colors and does not support
  /// color filtering.
  ///
  /// ```dart
  /// // In AppBar
  /// DoriSvg.fishLogo(size: DoriLogoSize.sm)
  ///
  /// // In Splash Screen
  /// DoriSvg.fishLogo(size: DoriLogoSize.md)
  /// ```
  DoriSvg.fishLogo({
    required DoriLogoSize size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel = 'Fish logo',
    super.key,
  }) : assetPath = DoriAssets.fishLogo,
       width = size.dimension,
       height = size.dimension,
       color = null; // Fish logo should preserve original colors

  /// The path to the SVG asset relative to the Dori package.
  ///
  /// Use [DoriAssets] constants for available paths.
  final String assetPath;

  /// The width of the SVG.
  ///
  /// If null, the SVG will size itself based on its intrinsic size
  /// or the available space.
  final double? width;

  /// The height of the SVG.
  ///
  /// If null, the SVG will size itself based on its intrinsic size
  /// or the available space.
  final double? height;

  /// Optional color to apply as a filter to the SVG.
  ///
  /// When set, all colors in the SVG will be replaced with this color.
  /// This is useful for monochromatic icons but should NOT be used
  /// for colorful assets like the Fish logo.
  final Color? color;

  /// How the SVG should be inscribed into the available space.
  ///
  /// Defaults to [BoxFit.contain].
  final BoxFit fit;

  /// How to align the SVG within its bounds.
  ///
  /// Defaults to [Alignment.center].
  final Alignment alignment;

  /// Semantic label for accessibility.
  ///
  /// This label will be announced by screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      package: 'dori',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticsLabel: semanticLabel,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
