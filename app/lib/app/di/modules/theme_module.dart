library;

import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'core_module.dart';

class _ThemePreference implements Serializable {
  final String mode;

  const _ThemePreference(this.mode);

  factory _ThemePreference.fromMap(Map<String, dynamic> map) {
    return _ThemePreference(map['mode'] as String? ?? 'system');
  }

  @override
  Map<String, dynamic> toMap() => {'mode': mode};
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final cacheAsync = ref.watch(localCacheSourceProvider);
    cacheAsync.whenData((cache) async {
      final savedTheme = await _readThemeFromCache(cache);
      if (savedTheme != null && savedTheme != state) {
        state = savedTheme;
      }
    });
  }

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
    } catch (_) {}
    return null;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _persistTheme(mode);
  }

  void setDoriTheme(DoriThemeMode mode) {
    setTheme(_toFlutterThemeMode(mode));
  }

  void toggle() {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    setTheme(newMode);
  }

  Future<void> _persistTheme(ThemeMode mode) async {
    final cacheAsync = ref.read(localCacheSourceProvider);
    cacheAsync.whenData((cache) async {
      try {
        await cache.setModel(
          LocalStorageKey.themeMode,
          _ThemePreference(mode.name),
        );
      } catch (_) {}
    });
  }

  ThemeMode _toFlutterThemeMode(DoriThemeMode mode) {
    return switch (mode) {
      DoriThemeMode.light => ThemeMode.light,
      DoriThemeMode.dark => ThemeMode.dark,
      DoriThemeMode.system => ThemeMode.system,
    };
  }
}

extension ThemeModeX on ThemeMode {
  DoriThemeMode toDoriThemeMode() {
    return switch (this) {
      ThemeMode.light => DoriThemeMode.light,
      ThemeMode.dark => DoriThemeMode.dark,
      ThemeMode.system => DoriThemeMode.system,
    };
  }
}
