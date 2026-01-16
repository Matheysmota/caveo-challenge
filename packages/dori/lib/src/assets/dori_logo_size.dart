/// Predefined sizes for the Fish logo.
///
/// These sizes are designed to maintain visual consistency across the app
/// while ensuring proper legibility in different contexts.
///
/// All sizes are **square** (width equals height).
///
/// ## Usage Contexts
///
/// | Size | Context | Dimensions (WxH) |
/// |------|---------|------------------|
/// | [sm] | AppBar (leading/trailing) | 32x32 |
/// | [md] | Splash Screen | 120x120 |
/// | [lg] | Hero sections, onboarding | 180x180 |
///
/// ## Example
///
/// ```dart
/// // In AppBar
/// DoriSvg.fishLogo(size: DoriLogoSize.sm)
///
/// // In Splash Screen
/// DoriSvg.fishLogo(size: DoriLogoSize.md)
/// ```
enum DoriLogoSize {
  /// Small logo for AppBar and compact spaces.
  ///
  /// Dimensions: 32x32 (square)
  /// Use case: AppBar leading, alongside theme toggle button.
  sm(32),

  /// Medium logo for splash screen.
  ///
  /// Dimensions: 120x120 (square)
  /// Use case: Splash screen, centered with loading indicator below.
  md(120),

  /// Large logo for hero sections.
  ///
  /// Dimensions: 180x180 (square)
  /// Use case: Onboarding screens, empty states, promotional sections.
  lg(180);

  const DoriLogoSize(this.dimension);

  /// The width and height of the logo in logical pixels.
  ///
  /// Since the logo is square, this value is used for both dimensions.
  final double dimension;
}
