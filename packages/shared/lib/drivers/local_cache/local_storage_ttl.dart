/// Time-To-Live (TTL) policy for cached data.
///
/// Defines when cached data should expire and be invalidated.
/// Use factory constructors to create instances.
library;

/// Represents the Time-To-Live policy for cached data.
///
/// Controls how long cached data remains valid before being
/// automatically invalidated on retrieval.
///
/// Example:
/// ```dart
/// // Data never expires
/// final permanent = LocalStorageTTL.withoutExpiration();
///
/// // Data expires after 1 hour
/// final temporary = LocalStorageTTL.withExpiration(Duration(hours: 1));
/// ```
class LocalStorageTTL {
  /// The duration after which data expires.
  ///
  /// Null means data never expires automatically.
  final Duration? duration;

  const LocalStorageTTL._(this.duration);

  /// Creates a TTL policy where data never expires.
  ///
  /// Data with this policy must be manually invalidated via
  /// [LocalCacheSource.delete] or [LocalCacheSource.clear].
  const LocalStorageTTL.withoutExpiration() : this._(null);

  /// Creates a TTL policy where data expires after [duration].
  ///
  /// When data is retrieved after [duration] has passed since storage,
  /// [LocalCacheSource.getModel] returns null (cache miss) and the
  /// expired data is automatically cleaned up.
  ///
  /// Example:
  /// ```dart
  /// // Expire after 24 hours
  /// LocalStorageTTL.withExpiration(Duration(hours: 24))
  ///
  /// // Expire after 5 minutes
  /// LocalStorageTTL.withExpiration(Duration(minutes: 5))
  /// ```
  const LocalStorageTTL.withExpiration(Duration duration) : this._(duration);

  /// Whether this TTL policy has an expiration.
  ///
  /// Returns `true` if data will expire after some duration,
  /// `false` if data never expires.
  bool get expires => duration != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStorageTTL &&
          runtimeType == other.runtimeType &&
          duration == other.duration;

  @override
  int get hashCode => duration.hashCode;

  @override
  String toString() => expires
      ? 'LocalStorageTTL.withExpiration($duration)'
      : 'LocalStorageTTL.withoutExpiration()';
}
