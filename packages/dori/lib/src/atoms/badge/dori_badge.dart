import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_colors.dart';
import '../../tokens/dori_radius.dart';
import '../../tokens/dori_spacing.dart';
import '../../tokens/dori_typography.dart';

/// Semantic variants for DoriBadge.
///
/// Each variant maps to specific feedback colors from the design system.
///
/// {@category Atoms}
enum DoriBadgeVariant {
  /// Neutral/default badge — uses surface colors
  neutral,

  /// Success badge — uses feedback.success color
  success,

  /// Error badge — uses feedback.error color
  error,

  /// Info badge — uses feedback.info color
  info,
}

/// Size variants for DoriBadge.
///
/// {@category Atoms}
enum DoriBadgeSize {
  /// Small: 12px caption text, minimal padding
  sm,

  /// Medium: 12px caption text, standard padding
  md,
}

/// A badge component for displaying status, labels, or counts.
///
/// Badges are small, non-interactive visual indicators used to highlight
/// status, categories, or numeric counts. They use semantic color variants
/// to communicate meaning.
///
/// ## Example
///
/// ```dart
/// // Basic neutral badge
/// DoriBadge(label: 'New')
///
/// // Success badge
/// DoriBadge(
///   label: 'Active',
///   variant: DoriBadgeVariant.success,
/// )
///
/// // Error badge with small size
/// DoriBadge(
///   label: '3',
///   variant: DoriBadgeVariant.error,
///   size: DoriBadgeSize.sm,
/// )
///
/// // Info badge with custom semantic label
/// DoriBadge(
///   label: 'Beta',
///   variant: DoriBadgeVariant.info,
///   semanticLabel: 'Beta version indicator',
/// )
/// ```
///
/// ## Accessibility
///
/// By default, the badge uses [label] as the semantic label.
/// You can override it with [semanticLabel] for more descriptive
/// screen reader announcements.
///
/// {@category Atoms}
class DoriBadge extends StatelessWidget {
  /// Creates a badge with the specified label and variant.
  const DoriBadge({
    required this.label,
    this.variant = DoriBadgeVariant.neutral,
    this.size = DoriBadgeSize.md,
    this.semanticLabel,
    super.key,
  });

  /// The text to display inside the badge.
  final String label;

  /// Semantic color variant.
  ///
  /// Defaults to [DoriBadgeVariant.neutral].
  final DoriBadgeVariant variant;

  /// Size of the badge.
  ///
  /// Defaults to [DoriBadgeSize.md].
  final DoriBadgeSize size;

  /// Semantic label for accessibility.
  ///
  /// If null, uses [label] as the semantic description.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final effectiveSemanticLabel = semanticLabel ?? label;

    final (backgroundColor, textColor) = _getColors(colors);
    final padding = _getPadding();

    return Semantics(
      label: effectiveSemanticLabel,
      excludeSemantics: true,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: DoriRadius.md,
        ),
        child: Text(
          label,
          style: DoriTypography.captionBold.copyWith(color: textColor),
        ),
      ),
    );
  }

  /// Returns background and text colors based on variant.
  (Color backgroundColor, Color textColor) _getColors(DoriColorScheme colors) {
    return switch (variant) {
      DoriBadgeVariant.neutral => (colors.surface.two, colors.content.one),
      DoriBadgeVariant.success => (
        colors.feedback.success.withValues(alpha: 0.25),
        colors.feedback.success,
      ),
      DoriBadgeVariant.error => (
        colors.feedback.error.withValues(alpha: 0.25),
        colors.feedback.error,
      ),
      DoriBadgeVariant.info => (
        colors.feedback.info.withValues(alpha: 0.25),
        colors.feedback.info,
      ),
    };
  }

  /// Returns padding based on size.
  EdgeInsets _getPadding() {
    return switch (size) {
      DoriBadgeSize.sm => const EdgeInsets.symmetric(
        horizontal: DoriSpacing.xxs,
        vertical: DoriSpacing.xxxs / 2,
      ),
      DoriBadgeSize.md => const EdgeInsets.symmetric(
        horizontal: DoriSpacing.xxs,
        vertical: DoriSpacing.xxxs,
      ),
    };
  }
}
