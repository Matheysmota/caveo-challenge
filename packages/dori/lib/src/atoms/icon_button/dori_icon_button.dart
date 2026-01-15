import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_colors.dart';
import '../icon/dori_icon.dart';
import 'dori_icon_button_size.dart';

export 'dori_icon_button_size.dart';

/// A circular icon button with Dori styling.
///
/// Small, circular button that contains an icon. Commonly used for
/// actions in AppBar, close buttons, or inline actions.
///
/// ## Example
///
/// ```dart
/// // Basic usage
/// DoriIconButton(
///   icon: DoriIconData.close,
///   onPressed: () => Navigator.pop(context),
/// )
///
/// // With custom size
/// DoriIconButton(
///   icon: DoriIconData.search,
///   size: DoriIconButtonSize.sm,
///   onPressed: () => openSearch(),
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
  /// Defaults to [DoriIconButtonSize.md] (40dp total).
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
    final disabledOpacity = isDisabled ? 0.5 : 1.0;

    // Background color
    final defaultColor = colors.content.two;
    final defaultBg = defaultColor.withValues(
      alpha: (defaultColor.a * 0.12 * disabledOpacity).clamp(0.0, 1.0),
    );
    final effectiveBg = backgroundColor != null
        ? backgroundColor!.withValues(
            alpha: (backgroundColor!.a * disabledOpacity).clamp(0.0, 1.0),
          )
        : defaultBg;

    // Icon color
    final effectiveIcon = iconColor?.withValues(
      alpha: (iconColor!.a * disabledOpacity).clamp(0.0, 1.0),
    );

    return (effectiveBg, effectiveIcon);
  }
}
