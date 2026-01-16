import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/api_data_source_delegate.dart';
import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/drivers/network/request_params.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import 'package:caveo_challenge/features/products/products.barrel.dart';

class MockApiDataSourceDelegate extends Mock implements ApiDataSourceDelegate {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockApiDataSourceDelegate mockApi;

  setUp(() {
    mockApi = MockApiDataSourceDelegate();
    dataSource = ProductRemoteDataSourceImpl(api: mockApi);
  });

  setUpAll(() {
    registerFallbackValue(
      const RequestParams.get('/products', queryParams: {}),
    );
  });

  final testApiResponse = {
    'data': [
      {
        'id': 1,
        'title': 'Test Product',
        'price': 99.99,
        'description': 'Test description',
        'category': 'test',
        'image': 'https://example.com/image.png',
        'rating': {'rate': 4.5, 'count': 100},
      },
    ],
  };

  final expectedProduct = const Product(
    id: 1,
    title: 'Test Product',
    price: 99.99,
    description: 'Test description',
    category: 'test',
    imageUrl: 'https://example.com/image.png',
    rating: ProductRating(rate: 4.5, count: 100),
  );

  group('ProductRemoteDataSourceImpl.getProducts', () {
    test('should return products when API call succeeds', () async {
      when(
        () => mockApi.request<List<Product>>(
          params: any(named: 'params'),
          mapper: any(named: 'mapper'),
        ),
      ).thenAnswer((invocation) async {
        final mapper =
            invocation.namedArguments[#mapper]
                as List<Product> Function(Map<String, dynamic>);
        return Success(mapper(testApiResponse));
      });

      final result = await dataSource.getProducts();

      expect(result.isSuccess, true);
      expect(result.getOrThrow(), [expectedProduct]);
    });

    test('should return failure when API call fails', () async {
      const failure = ConnectionFailure(message: 'No connection');
      when(
        () => mockApi.request<List<Product>>(
          params: any(named: 'params'),
          mapper: any(named: 'mapper'),
        ),
      ).thenAnswer((_) async => const Failure(failure));

      final result = await dataSource.getProducts();

      expect(result.isFailure, true);
      result.fold(
        (_) => fail('Expected failure'),
        (error) => expect(error, failure),
      );
    });

    test('should calculate offset based on page number', () async {
      RequestParams? capturedParams;
      when(
        () => mockApi.request<List<Product>>(
          params: any(named: 'params'),
          mapper: any(named: 'mapper'),
        ),
      ).thenAnswer((invocation) async {
        capturedParams = invocation.namedArguments[#params] as RequestParams;
        final mapper =
            invocation.namedArguments[#mapper]
                as List<Product> Function(Map<String, dynamic>);
        return Success(mapper({'data': <dynamic>[]}));
      });

      await dataSource.getProducts(page: 3);

      // page 3 with pageSize 20 = offset 40
      expect(capturedParams?.queryParams?['offset'], '40');
      expect(capturedParams?.queryParams?['limit'], '20');
    });
  });
}
