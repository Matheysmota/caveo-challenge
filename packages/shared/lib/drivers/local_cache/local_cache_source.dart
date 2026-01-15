/// Abstract interface for local cache operations.
///
/// Provides a type-safe, TTL-aware abstraction for persisting and
/// retrieving serializable models from local storage.
///
/// Implementations should:
/// - Handle serialization/deserialization internally
/// - Respect TTL policies and return null for expired data
/// - Clean up expired data automatically on retrieval
///
/// See ADR 007 (documents/adrs/007-abstracao-cache-local.md)
/// for architecture decisions.
library;

import 'local_storage_data_response.dart';
import 'local_storage_key.dart';
import 'local_storage_ttl.dart';
import 'serializable.dart';

/// Abstract interface for local cache storage operations.
///
/// Provides methods for storing and retrieving serializable models
/// with support for TTL (Time-To-Live) expiration policies.
///
/// Example usage:
/// ```dart
/// class ProductRepository {
///   final LocalCacheSource _cache;
///
///   ProductRepository(this._cache);
///
///   Future<void> cacheProducts(List<Product> products) async {
///     await _cache.setModel(
///       LocalStorageKey.products,
///       ProductList(products),
///       ttl: LocalStorageTTL.withExpiration(Duration(hours: 1)),
///     );
///   }
///
///   Future<List<Product>?> getCachedProducts() async {
///     final response = await _cache.getModel(
///       LocalStorageKey.products,
///       ProductList.fromMap,
///     );
///     return response?.data.products;
///   }
/// }
/// ```
abstract class LocalCacheSource {
  /// Persists a model to local storage with optional TTL policy.
  ///
  /// [key] - Unique identifier from [LocalStorageKey] enum.
  /// [model] - Object implementing [Serializable] for serialization.
  /// [ttl] - Expiration policy. Defaults to [LocalStorageTTL.withoutExpiration].
  ///
  /// The model is serialized via [Serializable.toMap] and stored as JSON.
  /// Storage timestamp and TTL metadata are persisted alongside the data.
  ///
  /// Throws [LocalCacheException] if serialization or storage fails.
  Future<void> setModel<T extends Serializable>(
    LocalStorageKey key,
    T model, {
    LocalStorageTTL ttl = const LocalStorageTTL.withoutExpiration(),
  });

  /// Retrieves a cached model if it exists and is not expired.
  ///
  /// [key] - The key used when storing the data.
  /// [fromMap] - Factory function to deserialize the stored Map into [T].
  ///
  /// Returns [LocalStorageDataResponse<T>] containing the data and metadata
  /// if the cache hit is successful.
  ///
  /// Returns `null` (cache miss) when:
  /// - No data exists for the given key
  /// - Data exists but has expired (TTL exceeded)
  /// - Data is corrupted or cannot be deserialized
  ///
  /// When data is expired, it is automatically deleted from storage
  /// before returning null.
  Future<LocalStorageDataResponse<T>?> getModel<T>(
    LocalStorageKey key,
    T Function(Map<String, dynamic>) fromMap,
  );

  /// Removes a specific entry from cache.
  ///
  /// [key] - The key of the entry to remove.
  ///
  /// Does nothing if the key doesn't exist (idempotent operation).
  Future<void> delete(LocalStorageKey key);

  /// Clears all cached data managed by this source.
  ///
  /// Warning: This removes ALL data with the `local_storage_` prefix,
  /// not just data stored via this instance.
  Future<void> clear();
}

/// Exception thrown when a local cache operation fails.
///
/// Contains a message describing what went wrong and optionally
/// the underlying error that caused the failure.
class LocalCacheException implements Exception {
  /// Human-readable description of the error.
  final String message;

  /// The underlying error, if any.
  final Object? cause;

  /// Creates a new cache exception.
  const LocalCacheException(this.message, [this.cause]);

  @override
  String toString() => cause != null
      ? 'LocalCacheException: $message (caused by: $cause)'
      : 'LocalCacheException: $message';
}
