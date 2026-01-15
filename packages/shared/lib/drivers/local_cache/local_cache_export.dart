/// Local cache driver exports.
///
/// Provides an abstraction layer for local storage operations
/// with support for TTL (Time-To-Live) expiration policies.
///
/// See ADR 007 (documents/adrs/007-abstracao-cache-local.md)
/// for architecture decisions.
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/drivers/local_cache/local_cache_export.dart';
///
/// class ProductRepository {
///   final LocalCacheSource _cache;
///
///   Future<void> cacheProducts(ProductList products) async {
///     await _cache.setModel(
///       LocalStorageKey.products,
///       products,
///       ttl: LocalStorageTTL.withExpiration(Duration(hours: 1)),
///     );
///   }
/// }
/// ```
library;

// Interface and exception
export 'local_cache_source.dart';

// Supporting types
export 'local_storage_data_response.dart';
export 'local_storage_key.dart';
export 'local_storage_ttl.dart';
export 'serializable.dart';
