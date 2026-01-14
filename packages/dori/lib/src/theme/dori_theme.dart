import 'package:flutter/material.dart';

import '../tokens/dori_colors.dart';
import '../tokens/dori_typography.dart';

/// 🎭 Dori Design System themes
///
/// Provides [ThemeData] configured for light and dark modes.
///
/// ## Usage
/// ```dart
/// MaterialApp(
///   theme: DoriTheme.light,
///   darkTheme: DoriTheme.dark,
///   themeMode: themeMode,
/// );
/// ```
class DoriTheme {
  const DoriTheme._();

  /// ThemeData for light mode
  static ThemeData get light => _buildTheme(Brightness.light);

  /// ThemeData for dark mode
  static ThemeData get dark => _buildTheme(Brightness.dark);

  /// Builds the ThemeData based on brightness
  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark ? DoriColors.dark : DoriColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      // ─────────────────────────────────────────────────────────────────────
      // Color Scheme
      // ─────────────────────────────────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.brand.pure,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: colors.brand.one,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: colors.feedback.error,
        onError: Colors.white,
        surface: colors.surface.one,
        onSurface: colors.content.one,
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Scaffold
      // ─────────────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.surface.pure,

      // ─────────────────────────────────────────────────────────────────────
      // AppBar
      // ─────────────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface.pure,
        foregroundColor: colors.content.one,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: DoriTypography.title5.copyWith(
          color: colors.content.one,
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Card
      // ─────────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.surface.one,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Text
      // ─────────────────────────────────────────────────────────────────────
      textTheme: TextTheme(
        headlineSmall: DoriTypography.title5.copyWith(
          color: colors.content.one,
        ),
        bodyMedium: DoriTypography.description.copyWith(
          color: colors.content.one,
        ),
        bodySmall: DoriTypography.caption.copyWith(color: colors.content.two),
        labelMedium: DoriTypography.descriptionBold.copyWith(
          color: colors.content.one,
        ),
        labelSmall: DoriTypography.captionBold.copyWith(
          color: colors.content.one,
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Divider
      // ─────────────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.surface.two,
        thickness: 1,
        space: 1,
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Extensions
      // ─────────────────────────────────────────────────────────────────────
      extensions: [DoriThemeExtension(colors: colors)],
    );
  }
}

/// Theme extension for accessing Dori tokens via context
///
/// ## Usage
/// ```dart
/// final colors = Theme.of(context).extension<DoriThemeExtension>()!.colors;
/// ```
///
/// Or via `context.dori`:
/// ```dart
/// final colors = context.dori.colors;
/// ```
@immutable
class DoriThemeExtension extends ThemeExtension<DoriThemeExtension> {
  /// Current color scheme (light or dark)
  final DoriColorScheme colors;

  const DoriThemeExtension({required this.colors});

  @override
  DoriThemeExtension copyWith({DoriColorScheme? colors}) {
    return DoriThemeExtension(colors: colors ?? this.colors);
  }

  @override
  DoriThemeExtension lerp(covariant DoriThemeExtension? other, double t) {
    if (other == null) return this;
    return this; // Colors are not interpolated
  }
}
