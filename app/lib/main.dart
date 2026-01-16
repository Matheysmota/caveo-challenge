import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'app/app_widget.dart';
import 'app/di/app_providers.dart';

/// Application entry point.
///
/// Initializes async dependencies before starting the app to ensure
/// all critical services are ready before the first frame renders.
///
/// ## Initialization Flow
///
/// 1. Ensure Flutter bindings are initialized
/// 2. Create async dependencies (LocalCacheSource)
/// 3. Pre-load theme from cache to avoid visual flash
/// 4. Start app with ProviderScope and overrides
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localCache = await SharedPreferencesLocalCacheSource.create();
  final savedTheme = await loadSavedTheme(localCache);

  runApp(
    ProviderScope(
      overrides: [
        localCacheSourceProvider.overrideWithValue(localCache),
        themeModeProvider.overrideWith(
          () => ThemeModeNotifier(initialTheme: savedTheme),
        ),
      ],
      child: const AppWidget(),
    ),
  );
}
