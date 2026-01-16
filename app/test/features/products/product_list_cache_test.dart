import 'package:caveo_challenge/features/products/domain/entities/product.dart';
import 'package:caveo_challenge/features/products/infrastructure/models/product_list_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductListCache', () {
    final testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test description',
      category: 'electronics',
      imageUrl: 'https://example.com/image.png',
      rating: const ProductRating(rate: 4.5, count: 100),
    );

    final testMap = {
      'products': [
        {
          'id': 1,
          'title': 'Test Product',
          'price': 99.99,
          'description': 'Test description',
          'category': 'electronics',
          'imageUrl': 'https://example.com/image.png',
          'rating': {'rate': 4.5, 'count': 100},
        },
      ],
    };

    test('should create ProductListCache from list of products', () {
      // Arrange & Act
      final cache = ProductListCache([testProduct]);

      // Assert
      expect(cache.products, hasLength(1));
      expect(cache.products.first.id, 1);
      expect(cache.products.first.title, 'Test Product');
    });

    test('should serialize to map correctly', () {
      // Arrange
      final cache = ProductListCache([testProduct]);

      // Act
      final map = cache.toMap();

      // Assert
      expect(map, equals(testMap));
    });

    test('should deserialize from map correctly', () {
      // Arrange & Act
      final cache = ProductListCache.fromMap(testMap);

      // Assert
      expect(cache.products, hasLength(1));
      final product = cache.products.first;
      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.description, 'Test description');
      expect(product.category, 'electronics');
      expect(product.imageUrl, 'https://example.com/image.png');
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
    });

    test('should handle multiple products', () {
      // Arrange
      final products = [
        testProduct,
        Product(
          id: 2,
          title: 'Second Product',
          price: 49.99,
          description: 'Another description',
          category: 'clothing',
          imageUrl: 'https://example.com/image2.png',
          rating: const ProductRating(rate: 3.5, count: 50),
        ),
      ];

      // Act
      final cache = ProductListCache(products);
      final map = cache.toMap();
      final restored = ProductListCache.fromMap(map);

      // Assert
      expect(restored.products, hasLength(2));
      expect(restored.products[0].id, 1);
      expect(restored.products[1].id, 2);
    });

    test('should handle empty list', () {
      // Arrange
      final cache = ProductListCache([]);

      // Act
      final map = cache.toMap();
      final restored = ProductListCache.fromMap(map);

      // Assert
      expect(restored.products, isEmpty);
    });

    test('should handle integer price correctly', () {
      // Arrange
      final mapWithIntPrice = {
        'products': [
          {
            'id': 1,
            'title': 'Test',
            'price': 100, // Integer instead of double
            'description': 'Test',
            'category': 'test',
            'imageUrl': 'https://test.com',
            'rating': {'rate': 4, 'count': 10}, // Integer rate
          },
        ],
      };

      // Act
      final cache = ProductListCache.fromMap(mapWithIntPrice);

      // Assert
      expect(cache.products.first.price, 100.0);
      expect(cache.products.first.rating.rate, 4.0);
    });
  });
}
