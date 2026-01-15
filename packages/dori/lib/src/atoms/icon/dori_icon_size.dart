import '../../tokens/dori_spacing.dart';

/// Icon sizes based on Dori spacing tokens.
///
/// Uses spacing tokens to maintain consistency with the design system.
///
/// | Size | Value | Use Case |
/// |------|-------|----------|
/// | sm   | 16dp  | Inline with text, small buttons |
/// | md   | 24dp  | Default size, most common |
/// | lg   | 32dp  | Prominent actions, headers |
///
/// {@category Atoms}
enum DoriIconSize {
  /// 16dp — Small icons, inline with text
  sm(DoriSpacing.xs),

  /// 24dp — Default size, most common use
  md(DoriSpacing.sm),

  /// 32dp — Large icons, prominent actions
  lg(DoriSpacing.md);

  /// Creates a DoriIconSize with the associated dimension value.
  const DoriIconSize(this.value);

  /// The size value in logical pixels.
  final double value;
}
