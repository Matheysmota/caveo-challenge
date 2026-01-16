/// SharedPreferences implementation of [LocalCacheSource].
///
/// This file is PRIVATE and should not be exported directly.
/// Use dependency injection to provide this implementation.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
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
      if (jsonString == null) return null; // Cache miss

      final envelope = jsonDecode(jsonString) as Map<String, dynamic>;

      final storedAtMs = envelope[_MetadataKeys.storedAt] as int?;
      if (storedAtMs == null) {
        await delete(key); // Corrupted: missing timestamp
        return null;
      }

      final storedAt = DateTime.fromMillisecondsSinceEpoch(storedAtMs);
      final ttlMs = envelope[_MetadataKeys.ttlMilliseconds] as int?;

      if (_isExpired(storedAt: storedAt, ttlMs: ttlMs)) {
        await delete(key); // Data expired
        return null;
      }

      final data = envelope[_MetadataKeys.data] as Map<String, dynamic>?;
      if (data == null) {
        await delete(key); // Corrupted: missing data
        return null;
      }

      return LocalStorageDataResponse<T>(
        data: fromMap(data),
        storedAt: storedAt,
      );
    } on FormatException {
      debugPrint(
        'Cache corrupted for ${key.value} (FormatException), cleaning up',
      );
      await delete(key);
      return null;
    } on TypeError {
      debugPrint('Cache corrupted for ${key.value} (TypeError), cleaning up');
      await delete(key);
      return null;
    } catch (e) {
      throw LocalCacheException(
        'Failed to retrieve model for key: ${key.value}',
        e,
      );
    }
  }

  /// Returns true if data has expired based on TTL.
  bool _isExpired({required DateTime storedAt, int? ttlMs}) {
    if (ttlMs == null) return false;

    final expiresAt = storedAt.add(Duration(milliseconds: ttlMs));
    return DateTime.now().isAfter(expiresAt);
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
