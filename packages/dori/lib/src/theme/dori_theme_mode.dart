/// Theme modes supported by Dori
///
/// - **light**: Light theme
/// - **dark**: Dark theme
/// - **system**: Follows system configuration
enum DoriThemeMode {
  /// Light theme
  light,

  /// Dark theme
  dark,

  /// Follows operating system configuration
  system,
}

/// Extension for common operations on [DoriThemeMode]
extension DoriThemeModeX on DoriThemeMode {
  /// Returns the inverse mode (light ↔ dark)
  ///
  /// If the current mode is [DoriThemeMode.system], returns [DoriThemeMode.light].
  ///
  /// ```dart
  /// DoriThemeMode.light.inverse // → DoriThemeMode.dark
  /// DoriThemeMode.dark.inverse  // → DoriThemeMode.light
  /// DoriThemeMode.system.inverse // → DoriThemeMode.light
  /// ```
  DoriThemeMode get inverse {
    switch (this) {
      case DoriThemeMode.light:
        return DoriThemeMode.dark;
      case DoriThemeMode.dark:
        return DoriThemeMode.light;
      case DoriThemeMode.system:
        return DoriThemeMode.light;
    }
  }

  /// Checks if it is dark theme
  bool get isDark => this == DoriThemeMode.dark;

  /// Checks if it is light theme
  bool get isLight => this == DoriThemeMode.light;

  /// Checks if it follows the system
  bool get isSystem => this == DoriThemeMode.system;
}
