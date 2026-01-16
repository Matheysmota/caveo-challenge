/// Theme management providers.
///
/// This module provides state management for the app's theme (light/dark mode)
/// with persistence to local cache.
///
/// ## Initialization
///
/// The theme starts with [ThemeMode.system] and automatically loads the saved
/// preference once the cache is ready. This enables **non-blocking startup**
/// while still respecting user preference with minimal visual flash.
///
/// ```dart
/// void main() {
///   runApp(const ProviderScope(child: AppWidget()));
///   // Theme loads automatically when cache is ready
/// }
/// ```
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
///
/// ## Auto-Loading from Cache
///
/// The notifier automatically loads the saved theme once the cache is ready.
/// It starts with [ThemeMode.system] for instant startup and updates once
/// the persisted preference is loaded.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Start with system theme for instant startup
    // Then load saved preference when cache is ready
    _loadSavedTheme();
    return ThemeMode.system;
  }

  /// Loads the saved theme from cache when available.
  Future<void> _loadSavedTheme() async {
    final cacheAsync = ref.watch(localCacheSourceProvider);
    cacheAsync.whenData((cache) async {
      final savedTheme = await _readThemeFromCache(cache);
      if (savedTheme != null && savedTheme != state) {
        state = savedTheme;
      }
    });
  }

  /// Reads theme preference from cache.
  Future<ThemeMode?> _readThemeFromCache(LocalCacheSource cache) async {
    try {
      final response = await cache.getModel(
        LocalStorageKey.themeMode,
        _ThemePreference.fromMap,
      );
      if (response != null) {
        return switch (response.data.mode) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
      }
    } catch (_) {
      // Cache read failed, return null to use default
    }
    return null;
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

  /// Persists the theme to cache.
  Future<void> _persistTheme(ThemeMode mode) async {
    final cacheAsync = ref.read(localCacheSourceProvider);
    cacheAsync.whenData((cache) async {
      try {
        await cache.setModel(
          LocalStorageKey.themeMode,
          _ThemePreference(mode.name),
        );
      } catch (_) {
        // Ignore persistence errors
      }
    });
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
