/// Products feature DI module.
library;

import 'package:shared/shared.dart';

import '../../../features/products/products.barrel.dart';
import '../../../main.dart';
import 'core_module.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final api = ref.watch(apiDataSourceDelegateProvider);
  return ProductRemoteDataSourceImpl(api: api);
});

final productLocalDataSourceProvider = Provider<ProductLocalDataSource?>((ref) {
  final cacheAsync = ref.watch(localCacheSourceProvider);
  return cacheAsync.whenOrNull(
    data: (cache) => ProductLocalDataSourceImpl(cache: cache),
  );
});

final productRepositoryProvider = Provider<ProductRepository?>((ref) {
  final remote = ref.watch(productRemoteDataSourceProvider);
  final local = ref.watch(productLocalDataSourceProvider);
  if (local == null) return null;
  return ProductRepositoryImpl(remote: remote, local: local);
});

/// Registers product syncer with SyncStore. Returns true when ready.
final productSyncRegistrarProvider = Provider<bool>((ref) {
  final syncStore = ref.watch(syncStoreProvider);
  final repository = ref.watch(productRepositoryProvider);

  if (repository == null) return false;

  if (!syncStore.hasKey(SyncStoreKey.products)) {
    syncStore.registerSyncer<List<Product>>(
      SyncStoreKey.products,
      fetcher: () => repository.getProducts(),
    );
  }

  return true;
});
