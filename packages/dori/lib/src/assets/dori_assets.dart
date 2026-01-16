/// Provides access to Dori Design System assets.
///
/// All asset paths are relative to the Dori package and should be used
/// with the appropriate widget (e.g., [DoriSvg]).
///
/// ## Usage
///
/// ```dart
/// // Using the DoriSvg widget
/// DoriSvg.fishLogo(width: 120)
///
/// // Or with SvgPicture directly
/// SvgPicture.asset(DoriAssets.fishLogo, package: 'dori')
/// ```
abstract final class DoriAssets {
  DoriAssets._();

  /// Base path for SVG assets.
  static const String _svgBasePath = 'assets/svg';

  /// Fish logo SVG asset path.
  ///
  /// This is the main brand logo used in splash screens and headers.
  /// The logo is colorful and designed for maximum contrast on both
  /// light and dark backgrounds.
  static const String fishLogo = '$_svgBasePath/fish_logo.svg';
}
