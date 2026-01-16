/// SyncStore driver exports.
///
/// Provides a centralized mechanism for initial data synchronization
/// with state management via streams.
///
/// See ADR 011 (documents/adrs/011-sync-store.md) for architecture decisions.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:shared/drivers/sync_store/sync_store_export.dart';
///
/// // Register syncer at app startup
/// syncStore.registerSyncer<List<Product>>(
///   SyncStoreKey.products,
///   fetcher: () => repository.getProducts(),
/// );
///
/// // Trigger sync
/// await syncStore.sync(SyncStoreKey.products);
///
/// // Watch state changes
/// syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
///   switch (state) {
///     case SyncStateSuccess(:final data): handleData(data);
///     case SyncStateError(:final failure): handleError(failure);
///     case SyncStateLoading(): showLoading();
///     case SyncStateIdle(): // Initial state
///   }
/// });
/// ```
library;

export 'sync_state.dart';
export 'sync_store.dart';
export 'sync_store_key.dart';
