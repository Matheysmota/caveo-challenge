/// Centralized store for managing initial data synchronization.
///
/// The SyncStore provides a generic mechanism for:
/// - Registering data syncers on app startup
/// - Triggering sync operations
/// - Observing sync state via streams
/// - Caching synced data for offline access
///
/// This abstraction enables features like Splash to observe sync state
/// without coupling to specific domain features (like Products).
///
/// See ADR 011 (documents/adrs/011-sync-store.md) for architecture decisions.
///
/// ## Architecture Overview
///
/// ```
/// ┌─────────────┐     registers    ┌─────────────┐
/// │   main.dart │ ───────────────► │  SyncStore  │
/// │ (bootstrap) │                  │  (shared)   │
/// └─────────────┘                  └──────┬──────┘
///                                         │
///         ┌──────────────────────────────┼──────────────────────────────┐
///         │                              │                              │
///         ▼                              ▼                              ▼
/// ┌───────────────┐             ┌───────────────┐             ┌───────────────┐
/// │ Splash Screen │             │    Product    │             │  Other Data   │
/// │   watch()     │             │   Feature     │             │   Features    │
/// │  (navigate)   │             │ get() + sync()│             │               │
/// └───────────────┘             └───────────────┘             └───────────────┘
/// ```
///
/// ## Usage Example
///
/// ```dart
/// // 1. In main.dart - Register syncers at app startup
/// final syncStore = SyncStore();
/// syncStore.registerSyncer<List<Product>>(
///   SyncStoreKey.products,
///   fetcher: () => productRepository.getProducts(),
/// );
/// await syncStore.sync(SyncStoreKey.products);
///
/// // 2. In SplashViewModel - Watch state and navigate
/// syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
///   if (state.isSuccess) navigateToHome();
///   if (state.isError) showRetry();
/// });
///
/// // 3. In ProductsFeature - Get initial data, refresh manually
/// final products = syncStore.get<List<Product>>(SyncStoreKey.products);
/// await syncStore.sync(SyncStoreKey.products); // Refresh
/// ```
library;

import '../../libraries/result_export/result_export.dart';
import '../network/network_failure.dart';
import 'sync_state.dart';
import 'sync_store_key.dart';

/// Type alias for a function that fetches data for synchronization.
///
/// The fetcher is provided during syncer registration and called
/// when [SyncStore.sync] is invoked.
typedef SyncFetcher<T> = Future<Result<T, NetworkFailure>> Function();

/// Abstract interface for centralized data synchronization.
///
/// Implementations should:
/// - Maintain in-memory state for fast access
/// - Optionally persist data to local cache for offline access
/// - Emit state changes via [watch] stream
/// - Support concurrent watchers for the same key
///
/// Thread Safety:
/// - [registerSyncer] should be called only during app initialization
/// - [sync] operations are queued internally to prevent race conditions
/// - [watch] and [get] are safe to call from any isolate
abstract interface class SyncStore {
  /// Registers a data syncer for a specific key.
  ///
  /// Must be called before [sync], [watch], or [get] for this key.
  /// Typically called in `main.dart` during app bootstrap.
  ///
  /// [key] - Unique identifier for this data type
  /// [fetcher] - Function that fetches data from remote source
  ///
  /// Throws [StateError] if a syncer is already registered for this key.
  void registerSyncer<T>(SyncStoreKey key, {required SyncFetcher<T> fetcher});

  /// Triggers a sync operation for the given key.
  ///
  /// Emits state changes via [watch]:
  /// 1. [SyncStateLoading] - When sync starts
  /// 2. [SyncStateSuccess] - On success with data
  /// 3. [SyncStateError] - On failure with error
  ///
  /// If sync fails but previous data exists, the error state
  /// includes [SyncStateError.previousData] for graceful degradation.
  ///
  /// Returns the final [SyncState] after sync completes.
  ///
  /// Throws [StateError] if no syncer is registered for this key.
  Future<SyncState<T>> sync<T>(SyncStoreKey key);

  /// Returns a stream of state changes for the given key.
  ///
  /// The stream:
  /// - Immediately emits the current state on subscription
  /// - Emits new states when [sync] is called
  /// - Never completes (use [StreamSubscription.cancel] to stop)
  ///
  /// Multiple watchers can subscribe to the same key.
  ///
  /// Throws [StateError] if no syncer is registered for this key.
  Stream<SyncState<T>> watch<T>(SyncStoreKey key);

  /// Returns the current state for the given key.
  ///
  /// Use this for synchronous access to the latest state.
  /// For reactive updates, prefer [watch].
  ///
  /// Throws [StateError] if no syncer is registered for this key.
  SyncState<T> get<T>(SyncStoreKey key);

  /// Returns the synced data if available, null otherwise.
  ///
  /// Convenience method equivalent to `get<T>(key).dataOrNull`.
  T? getDataOrNull<T>(SyncStoreKey key);

  /// Clears all registered syncers and cached data.
  ///
  /// Typically used in testing or app logout scenarios.
  Future<void> clear();

  /// Returns true if a syncer is registered for the given key.
  bool hasKey(SyncStoreKey key);
}
