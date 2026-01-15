import '../icon/dori_icon.dart';

/// Size variants for DoriIconButton.
///
/// {@category Atoms}
enum DoriIconButtonSize {
  /// Small: 16dp icon + 8dp padding on each side = 32dp total
  sm(DoriIconSize.sm, 32),

  /// Medium: 24dp icon + 8dp padding on each side = 40dp total
  md(DoriIconSize.md, 40);

  /// Creates a DoriIconButtonSize with associated icon size and total dimension.
  const DoriIconButtonSize(this.iconSize, this.totalSize);

  /// The icon size to use inside the button.
  final DoriIconSize iconSize;

  /// The total button size (icon + padding).
  final double totalSize;
}
