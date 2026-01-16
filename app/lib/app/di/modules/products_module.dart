/// Products feature dependency injection module.
///
/// Provides all products-related dependencies:
/// - Data sources (remote and local)
/// - Repository implementation
/// - SyncStore registration for initial data load
///
/// ## SyncStore Integration
///
/// This module registers a products syncer with the global SyncStore.
/// The splash screen watches this syncer to know when initial data is ready.
///
/// ## Async Cache Dependency
///
/// The local data source depends on [localCacheSourceProvider] which is
/// a FutureProvider. Providers that need the cache must wait for it to
/// be ready before accessing.
///
/// ## Usage
///
/// ```dart
/// final repository = ref.watch(productRepositoryProvider);
/// ```
library;

import 'package:shared/shared.dart';

import '../../../features/products/products.barrel.dart';
import '../../../main.dart';
import 'core_module.dart';

/// Provider for remote product data source.
///
/// Fetches products from the Fake Store API.
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final api = ref.watch(apiDataSourceDelegateProvider);
  return ProductRemoteDataSourceImpl(api: api);
});

/// Provider for local product data source.
///
/// Caches products locally using [LocalCacheSource].
/// Returns `null` if the cache is not yet initialized.
final productLocalDataSourceProvider = Provider<ProductLocalDataSource?>((ref) {
  final cacheAsync = ref.watch(localCacheSourceProvider);
  return cacheAsync.whenOrNull(
    data: (cache) => ProductLocalDataSourceImpl(cache: cache),
  );
});

/// Provider for product repository.
///
/// Combines remote and local data sources with fallback strategy:
/// 1. Try to fetch from API
/// 2. On success, cache locally
/// 3. On failure, return cached data if available
///
/// Returns `null` if the local cache is not yet initialized.
final productRepositoryProvider = Provider<ProductRepository?>((ref) {
  final remote = ref.watch(productRemoteDataSourceProvider);
  final local = ref.watch(productLocalDataSourceProvider);
  if (local == null) return null;
  return ProductRepositoryImpl(remote: remote, local: local);
});

/// Provider that registers product syncer and triggers initial sync.
///
/// This provider is marked as auto-dispose false to ensure the syncer
/// stays registered throughout the app lifecycle.
///
/// The splash screen should call `ref.read(productSyncRegistrarProvider)`
/// to ensure the syncer is registered before watching sync state.
///
/// Returns `true` if registration succeeded, `false` if dependencies
/// are not yet ready.
final productSyncRegistrarProvider = Provider<bool>((ref) {
  final syncStore = ref.watch(syncStoreProvider);
  final repository = ref.watch(productRepositoryProvider);

  // Wait for repository to be ready
  if (repository == null) return false;

  // Only register if not already registered
  if (!syncStore.hasKey(SyncStoreKey.products)) {
    syncStore.registerSyncer<List<Product>>(
      SyncStoreKey.products,
      fetcher: () => repository.getProducts(),
    );
  }

  return true;
});
