import 'package:flutter/material.dart';

import '../../tokens/dori_spacing.dart';
import 'dori_icon_data.dart';

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

/// An icon widget that uses Dori design system tokens.
///
/// Restricts available icons to [DoriIconData] enum to ensure
/// only approved icons are used throughout the app.
///
/// ## Example
///
/// ```dart
/// // Basic usage with default size (md = 24dp)
/// DoriIcon(icon: DoriIconData.search)
///
/// // With custom size
/// DoriIcon(
///   icon: DoriIconData.close,
///   size: DoriIconSize.sm,
/// )
///
/// // With custom color
/// DoriIcon(
///   icon: DoriIconData.lightMode,
///   color: context.dori.colors.brand.pure,
/// )
///
/// // With custom semantic label (overrides default)
/// DoriIcon(
///   icon: DoriIconData.arrowBack,
///   semanticLabel: 'Return to previous screen',
/// )
/// ```
///
/// ## Accessibility
///
/// Each [DoriIconData] has a default semantic label that is used
/// by screen readers. You can override it with [semanticLabel] parameter.
///
/// {@category Atoms}
class DoriIcon extends StatelessWidget {
  /// Creates a Dori icon widget.
  const DoriIcon({
    required this.icon,
    this.size = DoriIconSize.md,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// The icon to display from the allowed set.
  final DoriIconData icon;

  /// Size of the icon.
  ///
  /// Defaults to [DoriIconSize.md] (24dp).
  final DoriIconSize size;

  /// Color of the icon.
  ///
  /// If null, uses the ambient [IconTheme] color.
  /// Typically use `context.dori.colors.content.one` or similar.
  final Color? color;

  /// Semantic label for accessibility.
  ///
  /// If null, uses the default semantic label from [DoriIconData].
  /// Screen readers will announce this label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? icon.semanticLabel,
      child: ExcludeSemantics(
        child: Icon(icon.icon, size: size.value, color: color),
      ),
    );
  }
}
