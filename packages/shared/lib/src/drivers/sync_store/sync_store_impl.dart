/// In-memory implementation of [SyncStore].
///
/// Manages synchronization state in memory with reactive streams.
/// Data is stored in memory for fast access during app lifecycle.
///
/// ## Features
///
/// - Registers syncers with custom fetcher functions
/// - Maintains state per key with type safety
/// - Emits state changes via broadcast streams
/// - Handles errors gracefully with previous data fallback
///
/// ## Thread Safety
///
/// - [registerSyncer] should be called only during app initialization
/// - [sync] operations are atomic per key
/// - [watch] and [get] are safe for concurrent access
library;

import 'dart:async';

import '../../../drivers/sync_store/sync_state.dart';
import '../../../drivers/sync_store/sync_store.dart';
import '../../../drivers/sync_store/sync_store_key.dart';

/// Internal holder for syncer configuration and state.
class _SyncerEntry<T> {
  final SyncFetcher<T> fetcher;
  final StreamController<SyncState<T>> controller;
  SyncState<T> state;

  _SyncerEntry({
    required this.fetcher,
    required this.controller,
    this.state = const SyncStateIdle(),
  });
}

/// In-memory implementation of [SyncStore].
///
/// Example usage:
/// ```dart
/// final syncStore = SyncStoreImpl();
///
/// // Register syncer
/// syncStore.registerSyncer<List<Product>>(
///   SyncStoreKey.products,
///   fetcher: () => productRepository.getProducts(),
/// );
///
/// // Trigger sync
/// await syncStore.sync(SyncStoreKey.products);
///
/// // Watch state
/// syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
///   // Handle state changes
/// });
/// ```
class SyncStoreImpl implements SyncStore {
  final Map<SyncStoreKey, _SyncerEntry<dynamic>> _entries = {};

  @override
  void registerSyncer<T>(SyncStoreKey key, {required SyncFetcher<T> fetcher}) {
    if (_entries.containsKey(key)) {
      throw StateError(
        'Syncer already registered for key: $key. '
        'Call clear() first if you need to re-register.',
      );
    }

    _entries[key] = _SyncerEntry<T>(
      fetcher: fetcher,
      controller: StreamController<SyncState<T>>.broadcast(),
    );
  }

  @override
  Future<SyncState<T>> sync<T>(SyncStoreKey key) async {
    final entry = _getEntry<T>(key);

    // Get previous data for error fallback
    final previousData = entry.state.dataOrNull;

    // Emit loading state
    _updateState<T>(key, const SyncStateLoading());

    // Execute fetcher
    final result = await entry.fetcher();

    // Handle result
    final newState = result.fold(
      (data) => SyncStateSuccess<T>(data),
      (failure) => SyncStateError<T>(failure, previousData: previousData),
    );

    _updateState<T>(key, newState);
    return newState;
  }

  @override
  Stream<SyncState<T>> watch<T>(SyncStoreKey key) {
    final entry = _getEntry<T>(key);

    // Create a stream that emits current state immediately,
    // then continues with future updates
    return Stream.value(entry.state).concatWith([entry.controller.stream]);
  }

  @override
  SyncState<T> get<T>(SyncStoreKey key) {
    return _getEntry<T>(key).state;
  }

  @override
  T? getDataOrNull<T>(SyncStoreKey key) {
    if (!_entries.containsKey(key)) return null;
    return _entries[key]!.state.dataOrNull as T?;
  }

  @override
  Future<void> clear() async {
    for (final entry in _entries.values) {
      await entry.controller.close();
    }
    _entries.clear();
  }

  @override
  bool hasKey(SyncStoreKey key) => _entries.containsKey(key);

  /// Gets the entry for a key with type checking.
  _SyncerEntry<T> _getEntry<T>(SyncStoreKey key) {
    final entry = _entries[key];
    if (entry == null) {
      throw StateError(
        'No syncer registered for key: $key. '
        'Call registerSyncer() first.',
      );
    }
    return entry as _SyncerEntry<T>;
  }

  /// Updates state and emits to stream.
  void _updateState<T>(SyncStoreKey key, SyncState<T> newState) {
    final entry = _getEntry<T>(key);
    entry.state = newState;
    entry.controller.add(newState);
  }
}

/// Extension to concatenate streams.
extension _StreamConcat<T> on Stream<T> {
  /// Concatenates this stream with [other] streams.
  Stream<T> concatWith(Iterable<Stream<T>> others) async* {
    yield* this;
    for (final stream in others) {
      yield* stream;
    }
  }
}
