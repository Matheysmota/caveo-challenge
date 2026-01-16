/// Core infrastructure providers.
///
/// This module contains providers for fundamental app infrastructure
/// including network, cache, environment, and connectivity.
///
/// These providers are app-wide singletons that should be initialized early
/// in the app lifecycle.
///
/// ## Initialization
///
/// Some providers require async initialization. Use [createAsyncDependencies]
/// in `main()` to pre-initialize critical dependencies:
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final asyncDeps = await createAsyncDependencies();
///   runApp(
///     ProviderScope(
///       overrides: asyncDeps.overrides,
///       child: const AppWidget(),
///     ),
///   );
/// }
/// ```
library;

import 'package:shared/shared.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Environment
// ─────────────────────────────────────────────────────────────────────────────

/// Provides the environment reader for accessing configuration values.
///
/// Uses compile-time environment variables by default.
/// Override in tests to provide mock values.
final envReaderProvider = Provider<EnvironmentReader>((ref) {
  return const CompileTimeEnvReader();
});

// ─────────────────────────────────────────────────────────────────────────────
// Network
// ─────────────────────────────────────────────────────────────────────────────

/// Provides network configuration based on environment variables.
final networkConfigProvider = Provider<NetworkConfigProvider>((ref) {
  final env = ref.watch(envReaderProvider);
  return EnvironmentNetworkConfig(env);
});

/// Provides the HTTP client for network requests.
final networkClientProvider = Provider<NetworkClient>((ref) {
  final config = ref.watch(networkConfigProvider);
  return DioNetworkClient(config);
});

/// Provides the API data source delegate for making API calls.
///
/// Repositories should depend on this provider to make HTTP requests.
final apiDataSourceDelegateProvider = Provider<ApiDataSourceDelegate>((ref) {
  final client = ref.watch(networkClientProvider);
  final config = ref.watch(networkConfigProvider);
  return ApiDataSourceDelegateImpl(client: client, config: config);
});

// ─────────────────────────────────────────────────────────────────────────────
// Local Cache
// ─────────────────────────────────────────────────────────────────────────────

/// Provides the local cache source for persistent storage.
///
/// **Important:** This provider must be overridden with a pre-initialized
/// instance in the ProviderScope. Use [createAsyncDependencies] to create
/// the override.
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     localCacheSourceProvider.overrideWithValue(preInitializedCache),
///   ],
///   child: const AppWidget(),
/// )
/// ```
final localCacheSourceProvider = Provider<LocalCacheSource>((ref) {
  throw UnimplementedError(
    'localCacheSourceProvider must be overridden with a pre-initialized '
    'instance. Use createAsyncDependencies() in main().',
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Connectivity (for Products screen only)
// ─────────────────────────────────────────────────────────────────────────────

/// Provides the connectivity observer for monitoring network status.
///
/// **Note:** This should only be used in the Products screen for showing
/// the offline banner. The Splash screen does NOT use connectivity checks.
///
/// The observer automatically emits the current status on subscription
/// (BehaviorSubject-like pattern).
final connectivityObserverProvider = Provider<ConnectivityObserver>((ref) {
  final observer = ConnectivityPlusObserver();
  ref.onDispose(observer.dispose);
  return observer;
});

/// Stream provider for reactive connectivity status.
///
/// Use this in the Products screen to reactively show/hide the offline banner.
///
/// ```dart
/// final connectivity = ref.watch(connectivityStreamProvider);
/// connectivity.when(
///   data: (status) => status == ConnectivityStatus.offline
///       ? DoriBanner.offline()
///       : const SizedBox.shrink(),
///   loading: () => const SizedBox.shrink(),
///   error: (_, __) => const SizedBox.shrink(),
/// );
/// ```
final connectivityStreamProvider = StreamProvider<ConnectivityStatus>((ref) {
  final observer = ref.watch(connectivityObserverProvider);
  return observer.observe();
});
