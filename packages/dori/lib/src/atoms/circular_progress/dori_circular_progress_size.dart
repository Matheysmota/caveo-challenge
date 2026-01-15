/// Size variants for DoriCircularProgress.
///
/// {@category Atoms}
enum DoriCircularProgressSize {
  /// Small: 20dp - Ideal for buttons and inline elements.
  sm(20),

  /// Medium: 36dp (default) - Versatile standard size.
  md(36),

  /// Large: 48dp - For prominent areas and page loading.
  lg(48);

  /// Creates a DoriCircularProgressSize with associated dimension.
  const DoriCircularProgressSize(this.size);

  /// The size in logical pixels.
  final double size;
}
