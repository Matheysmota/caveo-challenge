/// Centralized enum of all local storage cache keys.
///
/// Using an enum instead of raw strings provides:
/// - Type safety and autocompletion
/// - Refactoring safety
/// - Single source of truth for all cache keys
/// - Prevention of typos and magic strings
library;

/// Enum representing all valid keys for local storage operations.
///
/// Add new keys here as needed. Each key automatically generates
/// a prefixed storage key via [value] getter.
///
/// Example:
/// ```dart
/// final key = LocalStorageKey.products;
/// print(key.value); // 'local_storage_products'
/// ```
enum LocalStorageKey {
  /// Cache key for product list data.
  products,

  /// Cache key for user's theme preference.
  themeMode;

  /// Returns the actual string key used for storage.
  ///
  /// Prefixes all keys with 'local_storage_' to avoid conflicts
  /// with other storage mechanisms.
  String get value => 'local_storage_$name';
}
