/// Size variants for DoriProductCard.
///
/// Defines the image aspect ratio and text sizing for different contexts.
///
/// {@category Organisms}
enum DoriProductCardSize {
  /// Small card — ideal for grids with many items.
  ///
  /// Image aspect ratio: 3:4 (portrait)
  sm,

  /// Medium card — default size, balanced layout.
  ///
  /// Image aspect ratio: 4:5 (slightly taller)
  md,

  /// Large card — for featured products or detail views.
  ///
  /// Image aspect ratio: 1:1 (square)
  lg,
}

/// Extension providing size values for DoriProductCardSize.
extension DoriProductCardSizeExtension on DoriProductCardSize {
  /// Returns the aspect ratio for the image (width / height).
  double get imageAspectRatio {
    switch (this) {
      case DoriProductCardSize.sm:
        return 3 / 4; // Portrait
      case DoriProductCardSize.md:
        return 4 / 5; // Slightly taller
      case DoriProductCardSize.lg:
        return 1 / 1; // Square
    }
  }
}
