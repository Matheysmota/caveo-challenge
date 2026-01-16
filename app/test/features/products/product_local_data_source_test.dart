import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/local_cache/local_cache_source.dart';
import 'package:shared/drivers/local_cache/local_storage_data_response.dart';
import 'package:shared/drivers/local_cache/local_storage_key.dart';
import 'package:shared/drivers/local_cache/local_storage_ttl.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';

import 'package:caveo_challenge/features/products/products.barrel.dart';

class MockLocalCacheSource extends Mock implements LocalCacheSource {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockLocalCacheSource mockCache;

  setUp(() {
    mockCache = MockLocalCacheSource();
    dataSource = ProductLocalDataSourceImpl(cache: mockCache);
  });

  setUpAll(() {
    registerFallbackValue(LocalStorageKey.products);
    registerFallbackValue(const LocalStorageTTL.withExpiration(Duration.zero));
    registerFallbackValue(ProductListCache(const []));
  });

  final testProducts = [
    const Product(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test description',
      category: 'test',
      imageUrl: 'https://example.com/image.png',
      rating: ProductRating(rate: 4.5, count: 100),
    ),
  ];

  group('ProductLocalDataSourceImpl.getProducts', () {
    test('should return products from cache when available', () async {
      when(() => mockCache.getModel<ProductListCache>(any(), any())).thenAnswer(
        (_) async => LocalStorageDataResponse(
          data: ProductListCache(testProducts),
          storedAt: DateTime.now(),
        ),
      );

      final result = await dataSource.getProducts();

      expect(result, testProducts);
    });

    test('should return null when cache is empty', () async {
      when(
        () => mockCache.getModel<ProductListCache>(any(), any()),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getProducts();

      expect(result, null);
    });
  });

  group('ProductLocalDataSourceImpl.saveProducts', () {
    test('should save products to cache with TTL', () async {
      when(
        () => mockCache.setModel(
          any(),
          any<ProductListCache>(),
          ttl: any(named: 'ttl'),
        ),
      ).thenAnswer((_) async {});

      await dataSource.saveProducts(testProducts);

      verify(
        () => mockCache.setModel(
          LocalStorageKey.products,
          any<ProductListCache>(),
          ttl: any(named: 'ttl'),
        ),
      ).called(1);
    });
  });

  group('ProductLocalDataSourceImpl.clear', () {
    test('should delete products from cache', () async {
      when(
        () => mockCache.delete(LocalStorageKey.products),
      ).thenAnswer((_) async {});

      await dataSource.clear();

      verify(() => mockCache.delete(LocalStorageKey.products)).called(1);
    });
  });
}
