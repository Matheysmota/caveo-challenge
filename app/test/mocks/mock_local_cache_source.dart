import 'package:shared/shared.dart';

/// Mock implementation of [LocalCacheSource] for testing.
///
/// This mock provides a simple in-memory implementation that
/// can be used in widget tests without requiring actual storage.
class MockLocalCacheSource implements LocalCacheSource {
  final Map<String, Map<String, dynamic>> _storage = {};

  @override
  Future<void> setModel<T extends Serializable>(
    LocalStorageKey key,
    T model, {
    LocalStorageTTL ttl = const LocalStorageTTL.withoutExpiration(),
  }) async {
    _storage[key.value] = {
      'data': model.toMap(),
      'storedAt': DateTime.now().toIso8601String(),
      'ttlMs': ttl.duration?.inMilliseconds,
    };
  }

  @override
  Future<LocalStorageDataResponse<T>?> getModel<T>(
    LocalStorageKey key,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final stored = _storage[key.value];
    if (stored == null) return null;

    final data = fromMap(stored['data'] as Map<String, dynamic>);
    return LocalStorageDataResponse(
      data: data,
      storedAt: DateTime.parse(stored['storedAt'] as String),
    );
  }

  @override
  Future<void> delete(LocalStorageKey key) async {
    _storage.remove(key.value);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}
