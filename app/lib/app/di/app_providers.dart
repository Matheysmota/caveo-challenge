/// App Dependency Injection Providers.
///
/// This barrel exports all providers for the application.
/// Import this file to access any provider in the app.
///
/// ```dart
/// import 'package:caveo_challenge/app/di/app_providers.dart';
/// ```
///
/// ## Module Organization
///
/// - **Core Module**: Infrastructure providers (network, cache, connectivity)
/// - **Theme Module**: Theme state management with persistence
///
/// ## Setup
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Pre-initialize async dependencies
///   final localCache = await SharedPreferencesLocalCacheSource.create();
///
///   runApp(
///     ProviderScope(
///       overrides: [localCacheSourceProvider.overrideWithValue(localCache)],
///       child: const AppWidget(),
///     ),
///   );
/// }
/// ```
library;

export 'modules/core_module.dart';
export 'modules/products_module.dart';
export 'modules/theme_module.dart';
