import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared/drivers/local_cache/local_cache_export.dart';
import 'package:shared/implementations.dart';

// Test model implementing Serializable
class TestProduct implements Serializable {
  final int id;
  final String name;
  final double price;

  const TestProduct({
    required this.id,
    required this.name,
    required this.price,
  });

  factory TestProduct.fromMap(Map<String, dynamic> map) {
    return TestProduct(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'price': price};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestProduct &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesLocalCacheSource cacheSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    cacheSource = await SharedPreferencesLocalCacheSource.create();
  });

  group('SharedPreferencesLocalCacheSource', () {
    group('setModel', () {
      test('should store model successfully', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);

        // Act
        await cacheSource.setModel(LocalStorageKey.products, product);

        // Assert
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );
        expect(response, isNotNull);
        expect(response!.data, equals(product));
      });

      test('should store model with TTL metadata', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        const ttl = LocalStorageTTL.withExpiration(Duration(hours: 1));

        // Act
        await cacheSource.setModel(LocalStorageKey.products, product, ttl: ttl);

        // Assert
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );
        expect(response, isNotNull);
        expect(response!.storedAt, isA<DateTime>());
      });

      test('should overwrite existing data with same key', () async {
        // Arrange
        const product1 = TestProduct(id: 1, name: 'First', price: 9.99);
        const product2 = TestProduct(id: 2, name: 'Second', price: 19.99);

        // Act
        await cacheSource.setModel(LocalStorageKey.products, product1);
        await cacheSource.setModel(LocalStorageKey.products, product2);

        // Assert
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );
        expect(response!.data, equals(product2));
      });
    });

    group('getModel', () {
      test('should return null when key does not exist', () async {
        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNull);
      });

      test('should return data when cache exists and is valid', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        await cacheSource.setModel(LocalStorageKey.products, product);

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNotNull);
        expect(response!.data.id, equals(1));
        expect(response.data.name, equals('Test'));
        expect(response.data.price, equals(9.99));
      });

      test('should return null when data is expired', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);

        // Store with expired TTL (negative duration trick via direct storage)
        final prefs = await SharedPreferences.getInstance();
        final envelope = {
          'data': product.toMap(),
          'storedAt': DateTime.now()
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          'ttlMs': const Duration(hours: 1).inMilliseconds,
        };
        await prefs.setString(
          LocalStorageKey.products.value,
          jsonEncode(envelope),
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNull);
      });

      test('should delete expired data from storage', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        final prefs = await SharedPreferences.getInstance();
        final envelope = {
          'data': product.toMap(),
          'storedAt': DateTime.now()
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          'ttlMs': const Duration(hours: 1).inMilliseconds,
        };
        await prefs.setString(
          LocalStorageKey.products.value,
          jsonEncode(envelope),
        );

        // Act
        await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        final rawData = prefs.getString(LocalStorageKey.products.value);
        expect(rawData, isNull);
      });

      test('should return null when stored JSON is malformed', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          LocalStorageKey.products.value,
          'not valid json {{{',
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNull);
      });

      test('should return null when data field is missing', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        final envelope = {
          'storedAt': DateTime.now().millisecondsSinceEpoch,
          // 'data' field intentionally missing
        };
        await prefs.setString(
          LocalStorageKey.products.value,
          jsonEncode(envelope),
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNull);
      });

      test('should return null when storedAt field is missing', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        final envelope = {
          'data': {'id': 1, 'name': 'Test', 'price': 9.99},
          // 'storedAt' field intentionally missing
        };
        await prefs.setString(
          LocalStorageKey.products.value,
          jsonEncode(envelope),
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNull);
      });

      test('should return null when data has incompatible types', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        final envelope = {
          'data': {
            'id': 'not an int', // Type mismatch
            'name': 'Test',
            'price': 9.99,
          },
          'storedAt': DateTime.now().millisecondsSinceEpoch,
        };
        await prefs.setString(
          LocalStorageKey.products.value,
          jsonEncode(envelope),
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert - gracefully handles type errors by returning null
        expect(response, isNull);
      });

      test(
        'should throw LocalCacheException when fromMap throws non-TypeError',
        () async {
          // Arrange
          final prefs = await SharedPreferences.getInstance();
          final envelope = {
            'data': {'id': 1, 'name': 'Test', 'price': 9.99},
            'storedAt': DateTime.now().millisecondsSinceEpoch,
          };
          await prefs.setString(
            LocalStorageKey.products.value,
            jsonEncode(envelope),
          );

          // Act & Assert
          await expectLater(
            () => cacheSource.getModel(
              LocalStorageKey.products,
              (_) => throw Exception('Custom deserialization error'),
            ),
            throwsA(isA<LocalCacheException>()),
          );
        },
      );

      test('should return data when TTL is not set (never expires)', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        await cacheSource.setModel(
          LocalStorageKey.products,
          product,
          ttl: const LocalStorageTTL.withoutExpiration(),
        );

        // Act
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );

        // Assert
        expect(response, isNotNull);
        expect(response!.data, equals(product));
      });
    });

    group('delete', () {
      test('should remove existing entry', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        await cacheSource.setModel(LocalStorageKey.products, product);

        // Act
        await cacheSource.delete(LocalStorageKey.products);

        // Assert
        final response = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );
        expect(response, isNull);
      });

      test('should not throw when key does not exist', () async {
        // Act & Assert
        expect(
          () => cacheSource.delete(LocalStorageKey.products),
          returnsNormally,
        );
      });
    });

    group('clear', () {
      test('should remove all local_storage_ prefixed entries', () async {
        // Arrange
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        await cacheSource.setModel(LocalStorageKey.products, product);
        await cacheSource.setModel(
          LocalStorageKey.themeMode,
          _TestThemeMode(isDark: true),
        );

        // Act
        await cacheSource.clear();

        // Assert
        final productsResponse = await cacheSource.getModel(
          LocalStorageKey.products,
          TestProduct.fromMap,
        );
        final themeResponse = await cacheSource.getModel(
          LocalStorageKey.themeMode,
          _TestThemeMode.fromMap,
        );
        expect(productsResponse, isNull);
        expect(themeResponse, isNull);
      });

      test('should not remove entries without local_storage_ prefix', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('other_key', 'other_value');
        const product = TestProduct(id: 1, name: 'Test', price: 9.99);
        await cacheSource.setModel(LocalStorageKey.products, product);

        // Act
        await cacheSource.clear();

        // Assert
        final otherValue = prefs.getString('other_key');
        expect(otherValue, equals('other_value'));
      });
    });
  });

  group('LocalStorageTTL', () {
    test('withoutExpiration should have expires = false', () {
      // Arrange & Act
      const ttl = LocalStorageTTL.withoutExpiration();

      // Assert
      expect(ttl.expires, isFalse);
      expect(ttl.duration, isNull);
    });

    test('withExpiration should have expires = true', () {
      // Arrange & Act
      const ttl = LocalStorageTTL.withExpiration(Duration(hours: 1));

      // Assert
      expect(ttl.expires, isTrue);
      expect(ttl.duration, equals(const Duration(hours: 1)));
    });

    test('equality should work correctly', () {
      // Arrange
      const ttl1 = LocalStorageTTL.withExpiration(Duration(hours: 1));
      const ttl2 = LocalStorageTTL.withExpiration(Duration(hours: 1));
      const ttl3 = LocalStorageTTL.withExpiration(Duration(hours: 2));
      const ttl4 = LocalStorageTTL.withoutExpiration();

      // Assert
      expect(ttl1, equals(ttl2));
      expect(ttl1, isNot(equals(ttl3)));
      expect(ttl1, isNot(equals(ttl4)));
    });
  });

  group('LocalStorageKey', () {
    test('value should return prefixed key', () {
      expect(LocalStorageKey.products.value, equals('local_storage_products'));
      expect(
        LocalStorageKey.themeMode.value,
        equals('local_storage_themeMode'),
      );
    });
  });

  group('LocalStorageDataResponse', () {
    test('equality should work correctly', () {
      // Arrange
      final now = DateTime.now();
      const product = TestProduct(id: 1, name: 'Test', price: 9.99);
      final response1 = LocalStorageDataResponse(data: product, storedAt: now);
      final response2 = LocalStorageDataResponse(data: product, storedAt: now);

      // Assert
      expect(response1, equals(response2));
    });

    test('toString should return readable format', () {
      // Arrange
      final now = DateTime(2026, 1, 15, 10, 30);
      const product = TestProduct(id: 1, name: 'Test', price: 9.99);
      final response = LocalStorageDataResponse(data: product, storedAt: now);

      // Assert
      expect(response.toString(), contains('LocalStorageDataResponse'));
      expect(response.toString(), contains('storedAt'));
    });
  });
}

// Helper class for testing multiple keys
class _TestThemeMode implements Serializable {
  final bool isDark;

  const _TestThemeMode({required this.isDark});

  factory _TestThemeMode.fromMap(Map<String, dynamic> map) {
    return _TestThemeMode(isDark: map['isDark'] as bool);
  }

  @override
  Map<String, dynamic> toMap() => {'isDark': isDark};
}
