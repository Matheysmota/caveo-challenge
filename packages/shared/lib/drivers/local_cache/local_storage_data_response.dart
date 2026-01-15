/// Response wrapper for cached data with metadata.
///
/// Contains the deserialized data along with storage timestamp
/// for debugging and freshness verification.
library;

/// Wrapper for cached data returned by [LocalCacheSource.getModel].
///
/// Only returned when data exists AND is not expired.
/// Contains the deserialized model and metadata about when it was stored.
///
/// Example:
/// ```dart
/// final response = await cache.getModel(
///   LocalStorageKey.products,
///   Product.fromMap,
/// );
///
/// if (response != null) {
///   print('Data: ${response.data}');
///   print('Stored at: ${response.storedAt}');
/// }
/// ```
class LocalStorageDataResponse<T> {
  /// The deserialized cached data.
  final T data;

  /// Timestamp when the data was originally stored.
  ///
  /// Useful for debugging and displaying data freshness to users.
  final DateTime storedAt;

  /// Creates a new response with cached data and metadata.
  const LocalStorageDataResponse({required this.data, required this.storedAt});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStorageDataResponse<T> &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          storedAt == other.storedAt;

  @override
  int get hashCode => data.hashCode ^ storedAt.hashCode;

  @override
  String toString() =>
      'LocalStorageDataResponse(data: $data, storedAt: $storedAt)';
}
