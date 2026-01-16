/// Core infrastructure providers (network, cache, env, connectivity).
library;

import 'package:shared/shared.dart';

final envReaderProvider = Provider<EnvironmentReader>((ref) {
  return const CompileTimeEnvReader();
});

final networkConfigProvider = Provider<NetworkConfigProvider>((ref) {
  final env = ref.watch(envReaderProvider);
  return EnvironmentNetworkConfig(env);
});

final networkClientProvider = Provider<NetworkClient>((ref) {
  final config = ref.watch(networkConfigProvider);
  return DioNetworkClient(config);
});

final apiDataSourceDelegateProvider = Provider<ApiDataSourceDelegate>((ref) {
  final client = ref.watch(networkClientProvider);
  final config = ref.watch(networkConfigProvider);
  return ApiDataSourceDelegateImpl(client: client, config: config);
});

/// Lazy-initialized local cache (FutureProvider to avoid blocking first frame).
final localCacheSourceProvider = FutureProvider<LocalCacheSource>((ref) async {
  return SharedPreferencesLocalCacheSource.create();
});

final connectivityObserverProvider = Provider<ConnectivityObserver>((ref) {
  final observer = ConnectivityPlusObserver();
  ref.onDispose(observer.dispose);
  return observer;
});

final connectivityStreamProvider = StreamProvider<ConnectivityStatus>((ref) {
  final observer = ref.watch(connectivityObserverProvider);
  return observer.observe();
});
