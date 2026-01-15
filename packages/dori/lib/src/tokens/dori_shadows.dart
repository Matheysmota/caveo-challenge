import 'package:flutter/material.dart';

/// 🌑 Dori Design System shadow tokens
///
/// Shadows provide depth and visual hierarchy to UI elements.
/// Each shadow level is designed for specific use cases:
///
/// - **xs**: Subtle depth for small elements (badges, chips)
/// - **sm**: Light elevation for cards and containers
/// - **md**: Medium elevation for floating elements
/// - **lg**: High elevation for modals and overlays
///
/// ## Usage
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: DoriShadows.of(context).xs,
///   ),
/// )
/// ```
///
/// {@category Tokens}
class DoriShadows {
  const DoriShadows._();

  /// Returns shadow tokens for the current theme brightness.
  ///
  /// Shadows are automatically adjusted for light/dark mode
  /// to maintain proper visual hierarchy.
  static DoriShadowTokens of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Shadow tokens for light mode.
  ///
  /// Uses darker shadows with higher opacity for better visibility
  /// against light backgrounds.
  static const light = DoriShadowTokens(
    xs: [
      BoxShadow(
        color: Color(0x14020617), // Slate 950 at 8%
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
    sm: [
      BoxShadow(
        color: Color(0x1A020617), // Slate 950 at 10%
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
    md: [
      BoxShadow(
        color: Color(0x1F020617), // Slate 950 at 12%
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
    lg: [
      BoxShadow(
        color: Color(0x29020617), // Slate 950 at 16%
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );

  /// Shadow tokens for dark mode.
  ///
  /// Uses darker, more subtle shadows as dark mode relies less
  /// on shadows for depth and more on surface color differences.
  static const dark = DoriShadowTokens(
    xs: [
      BoxShadow(
        color: Color(0x33000000), // Black at 20%
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
    sm: [
      BoxShadow(
        color: Color(0x40000000), // Black at 25%
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
    md: [
      BoxShadow(
        color: Color(0x4D000000), // Black at 30%
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
    lg: [
      BoxShadow(
        color: Color(0x59000000), // Black at 35%
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );
}

/// Shadow token values for a specific theme.
///
/// Contains all shadow levels from extra-small to large.
@immutable
class DoriShadowTokens {
  /// Extra-small shadow for subtle depth (badges, chips).
  final List<BoxShadow> xs;

  /// Small shadow for light elevation (cards).
  final List<BoxShadow> sm;

  /// Medium shadow for floating elements.
  final List<BoxShadow> md;

  /// Large shadow for modals and overlays.
  final List<BoxShadow> lg;

  const DoriShadowTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });
}
