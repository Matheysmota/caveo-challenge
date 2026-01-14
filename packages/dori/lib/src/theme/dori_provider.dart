import 'package:flutter/material.dart';

import '../tokens/dori_colors.dart';
import '../tokens/dori_radius.dart';
import '../tokens/dori_spacing.dart';
import '../tokens/dori_typography.dart';
import 'dori_theme.dart';
import 'dori_theme_mode.dart';

/// 🐠 Centralized access to the Dori Design System
///
/// Provides access to all tokens and theme control via BuildContext.
///
/// ## Usage
/// ```dart
/// // Via extension
/// final dori = context.dori;
///
/// // Tokens
/// dori.colors.brand.pure
/// dori.spacing.sm
/// dori.radius.lg
/// dori.typography.title5
///
/// // Theme
/// dori.setTheme(DoriThemeMode.dark);
/// dori.setTheme(dori.themeMode.inverse);
/// ```
class Dori {
  final BuildContext _context;
  final void Function(DoriThemeMode mode)? _onThemeChanged;
  final DoriThemeMode Function()? _themeModeGetter;

  Dori._({
    required BuildContext context,
    void Function(DoriThemeMode mode)? onThemeChanged,
    DoriThemeMode Function()? themeModeGetter,
  }) : _context = context,
       _onThemeChanged = onThemeChanged,
       _themeModeGetter = themeModeGetter;

  /// Gets Dori instance via context
  ///
  /// If [onThemeChanged] is provided, enables theme control via [setTheme].
  static Dori of(
    BuildContext context, {
    void Function(DoriThemeMode mode)? onThemeChanged,
    DoriThemeMode Function()? themeModeGetter,
  }) {
    return Dori._(
      context: context,
      onThemeChanged: onThemeChanged,
      themeModeGetter: themeModeGetter,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Tokens
  // ─────────────────────────────────────────────────────────────────────────

  /// Current color scheme (reactive to theme)
  DoriColorScheme get colors {
    final extension = Theme.of(_context).extension<DoriThemeExtension>();
    return extension?.colors ?? DoriColors.light;
  }

  /// Spacing tokens
  DoriSpacingAccessor get spacing => const DoriSpacingAccessor();

  /// Border radius tokens
  DoriRadiusAccessor get radius => const DoriRadiusAccessor();

  /// Typography tokens
  DoriTypographyAccessor get typography => const DoriTypographyAccessor();

  // ─────────────────────────────────────────────────────────────────────────
  // Theme
  // ─────────────────────────────────────────────────────────────────────────

  /// Current brightness (dark or light)
  Brightness get brightness => Theme.of(_context).brightness;

  /// Checks if in dark mode
  bool get isDark => brightness == Brightness.dark;

  /// Checks if in light mode
  bool get isLight => brightness == Brightness.light;

  /// Current theme mode
  ///
  /// Requires [themeModeGetter] to be provided in [Dori.of].
  DoriThemeMode get themeMode {
    return _themeModeGetter?.call() ?? DoriThemeMode.system;
  }

  /// Sets the theme mode
  ///
  /// Requires [onThemeChanged] to be provided in [Dori.of].
  ///
  /// ```dart
  /// // Set specific mode
  /// context.dori.setTheme(DoriThemeMode.dark);
  ///
  /// // Toggle to inverse
  /// context.dori.setTheme(context.dori.themeMode.inverse);
  /// ```
  void setTheme(DoriThemeMode mode) {
    _onThemeChanged?.call(mode);
  }
}

/// Accessor for spacing tokens
class DoriSpacingAccessor {
  /// Creates a spacing accessor
  const DoriSpacingAccessor();

  /// 4dp — Micro spacing
  double get xxxs => DoriSpacing.xxxs;

  /// 8dp — Between very close items
  double get xxs => DoriSpacing.xxs;

  /// 16dp — Between list items
  double get xs => DoriSpacing.xs;

  /// 24dp — Card padding
  double get sm => DoriSpacing.sm;

  /// 32dp — Between sections
  double get md => DoriSpacing.md;

  /// 48dp — Page margins
  double get lg => DoriSpacing.lg;

  /// 64dp — Large spaces, hero sections
  double get xl => DoriSpacing.xl;
}

/// Accessor for border radius tokens
class DoriRadiusAccessor {
  /// Creates a radius accessor
  const DoriRadiusAccessor();

  /// 8dp — Buttons, inputs, badges
  BorderRadius get sm => DoriRadius.sm;

  /// 12dp — Small cards, chips
  BorderRadius get md => DoriRadius.md;

  /// 16dp — Main cards, modals
  BorderRadius get lg => DoriRadius.lg;

  /// Raw value of 8dp
  double get smValue => DoriRadius.smValue;

  /// Raw value of 12dp
  double get mdValue => DoriRadius.mdValue;

  /// Raw value of 16dp
  double get lgValue => DoriRadius.lgValue;
}

/// Accessor for typography tokens
class DoriTypographyAccessor {
  /// Creates a typography accessor
  const DoriTypographyAccessor();

  /// 24px ExtraBold — Main titles
  TextStyle get title5 => DoriTypography.title5;

  /// 14px Medium — Default text
  TextStyle get description => DoriTypography.description;

  /// 14px Bold — Default text with emphasis
  TextStyle get descriptionBold => DoriTypography.descriptionBold;

  /// 12px Medium — Small text, labels
  TextStyle get caption => DoriTypography.caption;

  /// 12px Bold — Small text with emphasis
  TextStyle get captionBold => DoriTypography.captionBold;
}

/// Extension for Dori access via BuildContext
///
/// ## Basic Usage (read-only)
/// ```dart
/// final dori = context.dori;
/// final color = dori.colors.brand.pure;
/// ```
///
/// ## Usage with Theme Control
/// To enable [setTheme], use [DoriProvider] or configure manually:
/// ```dart
/// final dori = Dori.of(
///   context,
///   onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).state = mode,
///   themeModeGetter: () => ref.read(themeModeProvider),
/// );
/// ```
extension DoriContextExtension on BuildContext {
  /// Access to the Dori Design System (read-only)
  ///
  /// For theme control, use [DoriProvider] or [Dori.of] directly.
  Dori get dori => Dori.of(this);
}
