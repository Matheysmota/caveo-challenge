/// Predefined sizes for the Fish logo.
///
/// All sizes are **square** (width equals height).
///
/// | Size | Dimensions | Context |
/// |------|------------|---------|
/// | [sm] | 32x32 | AppBar |
/// | [md] | 40x40 | Compact spaces |
/// | [lg] | 64x64 | Splash screen, hero sections |
enum DoriLogoSize {
  /// Small logo for AppBar.
  sm(32),

  /// Medium logo for compact spaces.
  md(40),

  /// Large logo for splash screen and hero sections.
  lg(64);

  const DoriLogoSize(this.dimension);

  final double dimension;
}
