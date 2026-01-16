/// Represents the state of a sync operation.
///
/// Uses a sealed class hierarchy for exhaustive pattern matching.
/// Each state contains relevant data for that phase of synchronization.
///
/// Example usage:
/// ```dart
/// syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
///   switch (state) {
///     case SyncStateIdle():
///       print('Not synced yet');
///     case SyncStateLoading():
///       print('Syncing...');
///     case SyncStateSuccess(:final data):
///       print('Got ${data.length} items');
///     case SyncStateError(:final failure):
///       print('Error: ${failure.message}');
///   }
/// });
/// ```
library;

import '../network/network_failure.dart';

/// Sealed class representing the state of a sync operation.
///
/// The type parameter [T] represents the data type being synced.
sealed class SyncState<T> {
  const SyncState();

  /// Returns true if sync completed successfully.
  bool get isSuccess => this is SyncStateSuccess<T>;

  /// Returns true if sync failed with an error.
  bool get isError => this is SyncStateError<T>;

  /// Returns true if sync is currently in progress.
  bool get isLoading => this is SyncStateLoading<T>;

  /// Returns true if sync hasn't started yet.
  bool get isIdle => this is SyncStateIdle<T>;

  /// Returns the data if in success state, null otherwise.
  T? get dataOrNull => switch (this) {
    SyncStateSuccess(:final data) => data,
    _ => null,
  };

  /// Returns the failure if in error state, null otherwise.
  NetworkFailure? get failureOrNull => switch (this) {
    SyncStateError(:final failure) => failure,
    _ => null,
  };
}

/// Initial state before any sync operation has been performed.
///
/// This is the default state when a syncer is first registered.
final class SyncStateIdle<T> extends SyncState<T> {
  const SyncStateIdle();

  @override
  String toString() => 'SyncStateIdle<$T>()';
}

/// Sync operation is currently in progress.
///
/// The UI should show a loading indicator in this state.
final class SyncStateLoading<T> extends SyncState<T> {
  const SyncStateLoading();

  @override
  String toString() => 'SyncStateLoading<$T>()';
}

/// Sync operation completed successfully with data.
///
/// Contains the synced data which is also cached for offline access.
final class SyncStateSuccess<T> extends SyncState<T> {
  /// The successfully synced data.
  final T data;

  const SyncStateSuccess(this.data);

  @override
  String toString() => 'SyncStateSuccess<$T>(data: $data)';
}

/// Sync operation failed with an error.
///
/// Contains the failure details. The [previousData] field may contain
/// stale data from a previous successful sync, useful for offline
/// scenarios where showing stale data is better than nothing.
final class SyncStateError<T> extends SyncState<T> {
  /// The network failure that caused the sync to fail.
  final NetworkFailure failure;

  /// Previously synced data, if available.
  ///
  /// This allows the UI to show stale data with an error banner
  /// instead of a completely empty state.
  final T? previousData;

  const SyncStateError(this.failure, {this.previousData});

  @override
  String toString() =>
      'SyncStateError<$T>(failure: $failure, previousData: $previousData)';
}
