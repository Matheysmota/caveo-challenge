/// Theme management providers.
///
/// This module provides state management for the app's theme (light/dark mode)
/// with persistence to local cache.
///
/// ## Usage
///
/// ```dart
/// // Read current theme
/// final themeMode = ref.watch(themeModeProvider);
///
/// // Change theme
/// ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark);
///
/// // Toggle theme
/// ref.read(themeModeProvider.notifier).toggle();
/// ```
library;

import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'core_module.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Theme Cache Model
// ─────────────────────────────────────────────────────────────────────────────

/// Serializable model for storing theme preference.
class _ThemePreference implements Serializable {
  final String mode;

  const _ThemePreference(this.mode);

  factory _ThemePreference.fromMap(Map<String, dynamic> map) {
    return _ThemePreference(map['mode'] as String? ?? 'system');
  }

  @override
  Map<String, dynamic> toMap() => {'mode': mode};
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme Mode Provider
// ─────────────────────────────────────────────────────────────────────────────

/// Provides the current theme mode with persistence.
///
/// The theme is automatically persisted to local cache and restored on app start.
///
/// ```dart
/// // In MaterialApp
/// MaterialApp(
///   themeMode: ref.watch(themeModeProvider),
///   theme: DoriTheme.light,
///   darkTheme: DoriTheme.dark,
/// );
///
/// // Change theme
/// ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark);
/// ```
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Notifier for managing theme mode state.
///
/// Handles persistence and provides methods for changing the theme.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Load saved theme from cache
    _loadSavedTheme();
    return ThemeMode.system;
  }

  /// Sets the theme mode and persists it to cache.
  void setTheme(ThemeMode mode) {
    state = mode;
    _persistTheme(mode);
  }

  /// Sets the theme from DoriThemeMode.
  void setDoriTheme(DoriThemeMode mode) {
    setTheme(_toFlutterThemeMode(mode));
  }

  /// Toggles between light and dark themes.
  ///
  /// If currently in system mode, switches to the opposite of the current
  /// system brightness.
  void toggle() {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    setTheme(newMode);
  }

  /// Loads the saved theme from cache asynchronously.
  Future<void> _loadSavedTheme() async {
    try {
      final cache = ref.read(localCacheSourceProvider);
      final response = await cache.getModel(
        LocalStorageKey.themeMode,
        _ThemePreference.fromMap,
      );
      if (response != null) {
        state = _parseThemeMode(response.data.mode);
      }
    } catch (_) {
      // If cache read fails, keep default (system)
    }
  }

  /// Persists the theme to cache.
  Future<void> _persistTheme(ThemeMode mode) async {
    try {
      final cache = ref.read(localCacheSourceProvider);
      await cache.setModel(
        LocalStorageKey.themeMode,
        _ThemePreference(mode.name),
      );
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Parses a string to ThemeMode.
  ThemeMode _parseThemeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Converts DoriThemeMode to Flutter's ThemeMode.
  ThemeMode _toFlutterThemeMode(DoriThemeMode mode) {
    return switch (mode) {
      DoriThemeMode.light => ThemeMode.light,
      DoriThemeMode.dark => ThemeMode.dark,
      DoriThemeMode.system => ThemeMode.system,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper Extensions
// ─────────────────────────────────────────────────────────────────────────────

/// Extension to convert Flutter's ThemeMode to DoriThemeMode.
extension ThemeModeX on ThemeMode {
  /// Converts to DoriThemeMode.
  DoriThemeMode toDoriThemeMode() {
    return switch (this) {
      ThemeMode.light => DoriThemeMode.light,
      ThemeMode.dark => DoriThemeMode.dark,
      ThemeMode.system => DoriThemeMode.system,
    };
  }
}
