/// Keys for identifying different sync operations.
///
/// Each key represents a unique data type that can be synced
/// through the [SyncStore]. Keys are used to register syncers
/// and retrieve synced data.
///
/// Example:
/// ```dart
/// syncStore.registerSyncer<List<Product>>(
///   SyncStoreKey.products,
///   fetcher: () => repository.getProducts(),
/// );
/// ```
library;

/// Enumeration of available sync store keys.
///
/// Add new keys here when introducing new data types
/// that need initial synchronization.
enum SyncStoreKey {
  /// Products catalog data.
  ///
  /// Used for initial product list synchronization
  /// on app startup via splash screen.
  products,
}
