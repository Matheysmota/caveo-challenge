/// Implementation exports for dependency injection.
///
/// This file exports concrete implementations that should only
/// be imported in DI configuration files, not in regular code.
///
/// Regular code should depend on interfaces from the main barrel exports.
///
/// ## Usage (in DI setup only)
///
/// ```dart
/// import 'package:shared/implementations.dart';
///
/// final localCacheProvider = FutureProvider<LocalCacheSource>((ref) async {
///   return SharedPreferencesLocalCacheSource.create();
/// });
/// ```
library;

// Local cache implementation
export 'src/drivers/local_cache/shared_preferences_local_cache_source.dart';
