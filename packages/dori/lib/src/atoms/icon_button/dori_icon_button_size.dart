import '../icon/dori_icon.dart';

/// Size variants for DoriIconButton.
///
/// Each size follows the formula: icon size + (2 × padding).
/// The padding is calculated to provide appropriate touch targets.
///
/// | Size | Total | Icon | Padding | Use Case |
/// |------|-------|------|---------|----------|
/// | xs   | 16dp  | 12dp | 2dp     | Clear buttons in inputs, very compact |
/// | sm   | 24dp  | 16dp | 4dp     | Compact UI elements |
/// | md   | 32dp  | 16dp | 8dp     | Standard inline actions |
/// | lg   | 40dp  | 24dp | 8dp     | Primary actions, navigation |
/// | xlg  | 48dp  | 32dp | 8dp     | Touch-friendly, accessibility |
///
/// {@category Atoms}
enum DoriIconButtonSize {
  /// Extra Small: 12dp icon + 2dp padding on each side = 16dp total
  /// Use for clear buttons in text inputs where space is limited.
  xs(DoriIconSize.xxs, 16),

  /// Small: 16dp icon + 4dp padding on each side = 24dp total
  /// Use for compact UI elements.
  sm(DoriIconSize.xs, 24),

  /// Medium: 16dp icon + 8dp padding on each side = 32dp total
  /// Use for standard inline actions.
  md(DoriIconSize.sm, 32),

  /// Large: 24dp icon + 8dp padding on each side = 40dp total
  /// Use for primary actions and navigation.
  lg(DoriIconSize.md, 40),

  /// Extra Large: 32dp icon + 8dp padding on each side = 48dp total
  /// Use for touch-friendly targets that meet accessibility guidelines.
  xlg(DoriIconSize.lg, 48);

  /// Creates a DoriIconButtonSize with associated icon size and total dimension.
  const DoriIconButtonSize(this.iconSize, this.totalSize);

  /// The icon size to use inside the button.
  final DoriIconSize iconSize;

  /// The total button size (icon + padding).
  final double totalSize;

  /// The padding around the icon.
  ///
  /// Calculated as (totalSize - iconSize.value) / 2.
  double get padding => (totalSize - iconSize.value) / 2;
}
