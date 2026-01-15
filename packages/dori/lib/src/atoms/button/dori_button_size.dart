import '../../tokens/dori_typography.dart';
import '../circular_progress/dori_circular_progress.dart';

/// Size variants for DoriButton.
///
/// {@category Atoms}
enum DoriButtonSize {
  /// Small: 32dp height, caption text
  sm(32, DoriTypographyVariant.captionBold, DoriCircularProgressSize.sm),

  /// Medium: 44dp height, description text (default)
  md(44, DoriTypographyVariant.descriptionBold, DoriCircularProgressSize.md),

  /// Large: 52dp height, description text
  lg(52, DoriTypographyVariant.descriptionBold, DoriCircularProgressSize.md);

  /// Creates a DoriButtonSize with associated dimensions.
  const DoriButtonSize(this.height, this.typography, this.loaderSize);

  /// Button height in logical pixels.
  final double height;

  /// Typography variant for the button label.
  final DoriTypographyVariant typography;

  /// Size of the loading indicator.
  final DoriCircularProgressSize loaderSize;

  /// Returns the collapsed height for this size.
  ///
  /// Collapsed reduces height by ~25% for a more compact appearance.
  double get collapsedHeight {
    switch (this) {
      case DoriButtonSize.sm:
        return 28;
      case DoriButtonSize.md:
        return 36;
      case DoriButtonSize.lg:
        return 44;
    }
  }
}
