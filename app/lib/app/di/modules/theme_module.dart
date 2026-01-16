/// Theme management providers.
///
/// This module provides state management for the app's theme (light/dark mode)
/// with persistence to local cache.
///
/// ## Initialization
///
/// The theme should be pre-loaded in `main()` to avoid visual flash:
///
/// ```dart
/// void main() async {
///   final localCache = await SharedPreferencesLocalCacheSource.create();
///   final savedTheme = await loadSavedTheme(localCache);
///
///   runApp(
///     ProviderScope(
///       overrides: [
///         localCacheSourceProvider.overrideWithValue(localCache),
///         themeModeProvider.overrideWith(
///           () => ThemeModeNotifier(initialTheme: savedTheme),
///         ),
///       ],
///       child: const AppWidget(),
///     ),
///   );
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
/// ## Pre-initialization
///
/// To avoid theme flash, create with initial theme from cache:
///
/// ```dart
/// final savedTheme = await loadSavedTheme(localCache);
/// themeModeProvider.overrideWith(() => ThemeModeNotifier(initialTheme: savedTheme));
/// ```
class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// Creates a notifier with an optional initial theme.
  ///
  /// If [initialTheme] is provided, it will be used as the starting value
  /// instead of loading from cache (which would cause a flash).
  ThemeModeNotifier({this.initialTheme});

  /// The pre-loaded initial theme (if any).
  final ThemeMode? initialTheme;

  @override
  ThemeMode build() {
    // Use pre-loaded theme if available, otherwise default to system
    return initialTheme ?? ThemeMode.system;
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
// Pre-initialization Helper
// ─────────────────────────────────────────────────────────────────────────────

/// Loads the saved theme from cache.
///
/// Call this in `main()` before `runApp()` to avoid theme flash:
///
/// ```dart
/// final savedTheme = await loadSavedTheme(localCache);
/// ```
///
/// Returns [ThemeMode.system] if no theme is saved or if reading fails.
Future<ThemeMode> loadSavedTheme(LocalCacheSource cache) async {
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
    // If cache read fails, return default
  }
  return ThemeMode.system;
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
