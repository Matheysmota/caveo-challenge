import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import 'package:caveo_challenge/features/products/products.barrel.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

class MockProductLocalDataSource extends Mock
    implements ProductLocalDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    repository = ProductRepositoryImpl(remote: mockRemote, local: mockLocal);
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

  group('ProductRepository.getProducts', () {
    test('should return products from remote on success', () async {
      when(
        () => mockRemote.getProducts(page: 1),
      ).thenAnswer((_) async => Success(testProducts));
      when(() => mockLocal.saveProducts(testProducts)).thenAnswer((_) async {});

      final result = await repository.getProducts();

      expect(result.isSuccess, true);
      expect(result.getOrThrow(), testProducts);
      verify(() => mockLocal.saveProducts(testProducts)).called(1);
    });

    test('should fallback to cache when remote fails on page 1', () async {
      when(() => mockRemote.getProducts(page: 1)).thenAnswer(
        (_) async => const Failure(ConnectionFailure(message: 'No connection')),
      );
      when(() => mockLocal.getProducts()).thenAnswer((_) async => testProducts);

      final result = await repository.getProducts();

      expect(result.isSuccess, true);
      expect(result.getOrThrow(), testProducts);
    });

    test(
      'should return failure when remote fails and cache is empty',
      () async {
        const failure = ConnectionFailure(message: 'No connection');
        when(
          () => mockRemote.getProducts(page: 1),
        ).thenAnswer((_) async => const Failure(failure));
        when(() => mockLocal.getProducts()).thenAnswer((_) async => null);

        final result = await repository.getProducts();

        expect(result.isFailure, true);
        result.fold(
          (_) => fail('Expected failure'),
          (error) => expect(error, failure),
        );
      },
    );

    test('should not fallback to cache on page > 1', () async {
      const failure = ConnectionFailure(message: 'No connection');
      when(
        () => mockRemote.getProducts(page: 2),
      ).thenAnswer((_) async => const Failure(failure));

      final result = await repository.getProducts(page: 2);

      expect(result.isFailure, true);
      verifyNever(() => mockLocal.getProducts());
    });

    test('should not cache products on page > 1', () async {
      when(
        () => mockRemote.getProducts(page: 2),
      ).thenAnswer((_) async => Success(testProducts));

      final result = await repository.getProducts(page: 2);

      expect(result.isSuccess, true);
      verifyNever(() => mockLocal.saveProducts(any()));
    });
  });
}
