/// SharedPreferences implementation of [LocalCacheSource].
///
/// This file is PRIVATE and should not be exported directly.
/// Use dependency injection to provide this implementation.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../drivers/local_cache/local_cache_source.dart';
import '../../../drivers/local_cache/local_storage_data_response.dart';
import '../../../drivers/local_cache/local_storage_key.dart';
import '../../../drivers/local_cache/local_storage_ttl.dart';
import '../../../drivers/local_cache/serializable.dart';

/// Metadata keys used for storing TTL information alongside cached data.
class _MetadataKeys {
  static const String data = 'data';
  static const String storedAt = 'storedAt';
  static const String ttlMilliseconds = 'ttlMs';
}

/// Implementation of [LocalCacheSource] using SharedPreferences.
///
/// Stores data as JSON strings with metadata for TTL management.
/// Automatically handles expired data cleanup on retrieval.
///
/// This class should be instantiated via [SharedPreferencesLocalCacheSource.create]
/// and injected via DI (Riverpod).
class SharedPreferencesLocalCacheSource implements LocalCacheSource {
  final SharedPreferences _prefs;

  /// Creates an instance with an existing SharedPreferences instance.
  ///
  /// Prefer using [create] factory for async initialization.
  SharedPreferencesLocalCacheSource(this._prefs);

  /// Async factory to create an instance.
  ///
  /// Use this in your DI setup:
  /// ```dart
  /// final localCacheProvider = FutureProvider<LocalCacheSource>((ref) async {
  ///   return SharedPreferencesLocalCacheSource.create();
  /// });
  /// ```
  static Future<SharedPreferencesLocalCacheSource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesLocalCacheSource(prefs);
  }

  @override
  Future<void> setModel<T extends Serializable>(
    LocalStorageKey key,
    T model, {
    LocalStorageTTL ttl = const LocalStorageTTL.withoutExpiration(),
  }) async {
    try {
      final envelope = <String, dynamic>{
        _MetadataKeys.data: model.toMap(),
        _MetadataKeys.storedAt: DateTime.now().millisecondsSinceEpoch,
        if (ttl.expires)
          _MetadataKeys.ttlMilliseconds: ttl.duration!.inMilliseconds,
      };

      final jsonString = jsonEncode(envelope);
      await _prefs.setString(key.value, jsonString);
    } catch (e) {
      throw LocalCacheException(
        'Failed to store model for key: ${key.value}',
        e,
      );
    }
  }

  @override
  Future<LocalStorageDataResponse<T>?> getModel<T>(
    LocalStorageKey key,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final jsonString = _prefs.getString(key.value);

      if (jsonString == null) {
        return null; // Cache miss: key not found
      }

      final envelope = jsonDecode(jsonString) as Map<String, dynamic>;

      final storedAtMs = envelope[_MetadataKeys.storedAt] as int?;
      if (storedAtMs == null) {
        // Corrupted data: missing timestamp
        await delete(key);
        return null;
      }

      final storedAt = DateTime.fromMillisecondsSinceEpoch(storedAtMs);
      final ttlMs = envelope[_MetadataKeys.ttlMilliseconds] as int?;

      // Check TTL expiration
      if (ttlMs != null) {
        final expiresAt = storedAt.add(Duration(milliseconds: ttlMs));
        if (DateTime.now().isAfter(expiresAt)) {
          // Data expired: clean up and return null
          await delete(key);
          return null;
        }
      }

      final data = envelope[_MetadataKeys.data] as Map<String, dynamic>?;
      if (data == null) {
        // Corrupted data: missing data field
        await delete(key);
        return null;
      }

      final model = fromMap(data);
      return LocalStorageDataResponse<T>(data: model, storedAt: storedAt);
    } on FormatException {
      // JSON parsing failed: corrupted data
      await delete(key);
      return null;
    } on TypeError {
      // Type casting failed: corrupted or incompatible data
      await delete(key);
      return null;
    } catch (e) {
      // Other errors (e.g., fromMap threw)
      // Don't delete data, let caller handle
      throw LocalCacheException(
        'Failed to retrieve model for key: ${key.value}',
        e,
      );
    }
  }

  @override
  Future<void> delete(LocalStorageKey key) async {
    await _prefs.remove(key.value);
  }

  @override
  Future<void> clear() async {
    final keys = _prefs.getKeys().where(
      (key) => key.startsWith('local_storage_'),
    );

    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
