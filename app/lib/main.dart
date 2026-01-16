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
/// 3. Start app with ProviderScope and overrides
///
/// ## Performance Considerations
///
/// - Native splash shows during this initialization (~50-100ms)
/// - All async work happens before `runApp` to avoid janks
/// - Theme is loaded from cache in the first frame
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize async dependencies
  final localCache = await SharedPreferencesLocalCacheSource.create();

  runApp(
    ProviderScope(
      overrides: [localCacheSourceProvider.overrideWithValue(localCache)],
      child: const AppWidget(),
    ),
  );
}
