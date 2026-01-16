import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'app/app_widget.dart';
import 'app/di/app_providers.dart';

/// Application entry point.
///
/// Uses compile-time environment variables for fast startup in production.
/// Falls back to `.devEnv` file only in debug mode for development convenience.
///
/// ## Performance Strategy
///
/// - **Release/Profile**: Uses [CompileTimeEnvReader] (sync, zero I/O)
/// - **Debug**: Uses [DotEnvReader] from `.devEnv` file (async, but only in dev)
///
/// This ensures the fastest possible startup in production while maintaining
/// developer ergonomics during development.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final envReader = await _createEnvReader();
  final syncStore = SyncStoreImpl();

  runApp(
    ProviderScope(
      overrides: [
        envReaderProvider.overrideWithValue(envReader),
        syncStoreProvider.overrideWithValue(syncStore),
      ],
      child: const AppWidget(),
    ),
  );
}

/// Creates the appropriate environment reader based on build mode.
///
/// In release builds, uses compile-time constants for zero I/O startup.
/// In debug builds, loads from `.devEnv` for easier development iteration.
Future<EnvironmentReader> _createEnvReader() async {
  if (kReleaseMode) {
    // Production: instant startup with compile-time constants
    return const CompileTimeEnvReader();
  }

  // Development: load from .devEnv file for convenience
  return DotEnvReader.load();
}

/// Provider for the global SyncStore instance.
final syncStoreProvider = Provider<SyncStore>((ref) {
  throw UnimplementedError(
    'syncStoreProvider must be overridden in ProviderScope',
  );
});
