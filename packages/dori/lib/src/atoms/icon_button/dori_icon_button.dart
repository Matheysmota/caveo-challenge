import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_colors.dart';
import '../icon/dori_icon.dart';
import 'dori_icon_button_size.dart';

export 'dori_icon_button_size.dart';

/// A circular icon button with Dori styling.
///
/// Small, circular button that contains an icon. Commonly used for
/// actions in AppBar, close buttons, clear buttons in inputs, or inline actions.
///
/// ## Size Reference
///
/// | Size | Total | Icon | Use Case |
/// |------|-------|------|----------|
/// | xs   | 16dp  | 12dp | Clear buttons in inputs, very compact |
/// | sm   | 24dp  | 16dp | Compact UI elements |
/// | md   | 32dp  | 16dp | Standard inline actions |
/// | lg   | 40dp  | 24dp | Primary actions, navigation |
/// | xlg  | 48dp  | 32dp | Touch-friendly, meets accessibility |
///
/// ## Example
///
/// ```dart
/// // Basic usage (defaults to md = 32dp)
/// DoriIconButton(
///   icon: DoriIconData.close,
///   onPressed: () => Navigator.pop(context),
/// )
///
/// // Extra small for clear buttons in inputs (16dp)
/// DoriIconButton(
///   icon: DoriIconData.close,
///   size: DoriIconButtonSize.xs,
///   onPressed: () => clearInput(),
/// )
///
/// // Small size for compact UI (24dp)
/// DoriIconButton(
///   icon: DoriIconData.close,
///   size: DoriIconButtonSize.sm,
///   onPressed: () => clearInput(),
/// )
///
/// // Large size for prominent actions (40dp)
/// DoriIconButton(
///   icon: DoriIconData.search,
///   size: DoriIconButtonSize.lg,
///   onPressed: () => openSearch(),
/// )
///
/// // Extra large for accessibility (48dp)
/// DoriIconButton(
///   icon: DoriIconData.arrowBack,
///   size: DoriIconButtonSize.xlg,
///   onPressed: () => goBack(),
/// )
///
/// // With custom color
/// DoriIconButton(
///   icon: DoriIconData.lightMode,
///   iconColor: context.dori.colors.brand.pure,
///   onPressed: () => toggleTheme(),
/// )
///
/// // Disabled state
/// DoriIconButton(
///   icon: DoriIconData.refresh,
///   onPressed: null, // disabled
/// )
/// ```
///
/// ## Accessibility
///
/// The button uses the icon's semantic label by default.
/// You can override it with [semanticLabel] parameter.
///
/// {@category Atoms}
class DoriIconButton extends StatelessWidget {
  /// Creates a circular icon button.
  const DoriIconButton({
    required this.icon,
    required this.onPressed,
    this.size = DoriIconButtonSize.md,
    this.iconColor,
    this.backgroundColor,
    this.semanticLabel,
    super.key,
  });

  /// The icon to display.
  final DoriIconData icon;

  /// Callback when button is pressed.
  ///
  /// If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Size of the button.
  ///
  /// Defaults to [DoriIconButtonSize.md] (32dp total with 16dp icon).
  final DoriIconButtonSize size;

  /// Color of the icon.
  ///
  /// If null, uses theme's icon color.
  final Color? iconColor;

  /// Background color of the button.
  ///
  /// If null, uses a subtle surface color with transparency
  /// that adapts to the current theme for proper contrast.
  final Color? backgroundColor;

  /// Semantic label for accessibility.
  ///
  /// If null, uses the icon's default semantic label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;
    final effectiveSemanticLabel = semanticLabel ?? icon.semanticLabel;
    final isDisabled = onPressed == null;

    final (effectiveBackgroundColor, effectiveIconColor) = _getColors(
      dori.colors,
      isDisabled,
    );

    return Semantics(
      label: effectiveSemanticLabel,
      button: true,
      enabled: !isDisabled,
      excludeSemantics: true,
      child: Material(
        color: effectiveBackgroundColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size.totalSize,
            height: size.totalSize,
            child: Center(
              child: DoriIcon(
                icon: icon,
                size: size.iconSize,
                color: effectiveIconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns effective background and icon colors.
  (Color backgroundColor, Color? iconColor) _getColors(
    DoriColorScheme colors,
    bool isDisabled,
  ) {
    // Background color - use surface.three for visible contrast on any surface
    // Apply opacity only when disabled to avoid redundant operations
    final defaultBg = isDisabled
        ? colors.surface.three.withValues(alpha: 0.5)
        : colors.surface.three;
    final effectiveBg = backgroundColor != null
        ? (isDisabled
              ? backgroundColor!.withValues(
                  alpha: (backgroundColor!.a * 0.5).clamp(0.0, 1.0),
                )
              : backgroundColor!)
        : defaultBg;

    // Icon color - apply opacity only when disabled
    final effectiveIcon = iconColor != null && isDisabled
        ? iconColor!.withValues(alpha: (iconColor!.a * 0.5).clamp(0.0, 1.0))
        : iconColor;

    return (effectiveBg, effectiveIcon);
  }
}
