import 'package:flutter/material.dart';

import '../../tokens/dori_colors.dart';
import '../../tokens/dori_spacing.dart';
import '../icon/dori_icon.dart';
import 'dori_button_size.dart';
import 'dori_button_variant.dart';

/// Style configuration for DoriButton.
///
/// Handles color computation, padding, and visual feedback states.
class DoriButtonStyle {
  const DoriButtonStyle._();

  /// Returns (backgroundColor, foregroundColor, borderColor) based on variant.
  ///
  /// - [isDisabled]: applies 0.5 opacity when true
  /// - [isPressed]: applies highlight overlay when true
  static (Color?, Color, Color?) getColors({
    required DoriColorScheme colors,
    required DoriButtonVariant variant,
    required bool isDisabled,
    required bool isPressed,
  }) {
    final disabledOpacity = isDisabled ? 0.5 : 1.0;

    // Base colors by variant
    final (baseBackground, baseForeground, baseBorder) = switch (variant) {
      DoriButtonVariant.primary => (
        colors.brand.pure,
        colors.surface.pure,
        null as Color?,
      ),
      DoriButtonVariant.secondary => (
        colors.brand.two,
        colors.brand.pure,
        null as Color?,
      ),
      DoriButtonVariant.tertiary => (
        null as Color?,
        colors.brand.pure,
        null as Color?,
      ),
    };

    // Apply disabled opacity
    final background = baseBackground?.withValues(alpha: disabledOpacity);
    final foreground = baseForeground.withValues(alpha: disabledOpacity);
    final border = baseBorder?.withValues(alpha: disabledOpacity);

    // Apply pressed highlight
    if (isPressed && background != null) {
      return (_applyHighlight(background, colors), foreground, border);
    }

    return (background, foreground, border);
  }

  /// Applies a highlight effect to the background color when pressed.
  static Color _applyHighlight(Color color, DoriColorScheme colors) {
    // Darken for light colors, lighten for dark colors
    final luminance = color.computeLuminance();
    if (luminance > 0.5) {
      // Light color: darken
      return Color.lerp(color, Colors.black, 0.1)!;
    } else {
      // Dark color: lighten
      return Color.lerp(color, Colors.white, 0.15)!;
    }
  }

  /// Returns horizontal padding based on size and collapsed state.
  static double getHorizontalPadding({
    required DoriButtonSize size,
    required bool isCollapsed,
  }) {
    if (isCollapsed) {
      return switch (size) {
        DoriButtonSize.sm => DoriSpacing.xxs,
        DoriButtonSize.md => DoriSpacing.xs,
        DoriButtonSize.lg => DoriSpacing.sm,
      };
    }

    return switch (size) {
      DoriButtonSize.sm => DoriSpacing.xs,
      DoriButtonSize.md => DoriSpacing.sm,
      DoriButtonSize.lg => DoriSpacing.md,
    };
  }

  /// Returns the effective height considering collapsed state.
  static double getEffectiveHeight({
    required DoriButtonSize size,
    required bool isCollapsed,
  }) {
    return isCollapsed ? size.collapsedHeight : size.height;
  }

  /// Returns the icon size based on button size.
  static DoriIconSize getIconSize(DoriButtonSize size) {
    return switch (size) {
      DoriButtonSize.sm => DoriIconSize.sm,
      DoriButtonSize.md || DoriButtonSize.lg => DoriIconSize.md,
    };
  }
}
