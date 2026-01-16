import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/drivers/network/error/client_exception.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockNetworkConfigProvider extends Mock implements NetworkConfigProvider {}

void main() {
  late MockNetworkClient mockClient;
  late MockNetworkConfigProvider mockConfig;
  late ApiDataSourceDelegateImpl sut;

  setUp(() {
    mockClient = MockNetworkClient();
    mockConfig = MockNetworkConfigProvider();

    when(() => mockConfig.baseUrl).thenReturn('https://api.example.com');
    when(
      () => mockConfig.connectTimeout,
    ).thenReturn(const Duration(seconds: 30));
    when(
      () => mockConfig.receiveTimeout,
    ).thenReturn(const Duration(seconds: 30));
    when(() => mockConfig.sendTimeout).thenReturn(const Duration(seconds: 30));

    sut = ApiDataSourceDelegateImpl(client: mockClient, config: mockConfig);
  });

  group('ApiDataSourceDelegateImpl', () {
    test('should return Success on 200', () async {
      when(
        () => mockClient.get(
          any(),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => const NetworkResponse(
          statusCode: 200,
          data: {'id': 1, 'name': 'Test'},
        ),
      );

      final result = await sut.request<Map<String, dynamic>>(
        params: RequestParams.get('/products'),
        mapper: (json) => json,
      );

      expect(result.isSuccess, isTrue);
    });

    test('should return HttpFailure on 404', () async {
      when(
        () => mockClient.get(
          any(),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => const NetworkResponse(
          statusCode: 404,
          data: {'error': 'Not found'},
        ),
      );

      final result = await sut.request<Map<String, dynamic>>(
        params: RequestParams.get('/products'),
        mapper: (json) => json,
      );

      expect(result.isFailure, isTrue);
      result.fold(
        (data) => fail('Expected failure'),
        (error) => expect(error, isA<HttpFailure>()),
      );
    });

    test('should return ConnectionFailure on connection error', () async {
      when(
        () => mockClient.get(
          any(),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(
        const ClientException(type: ClientExceptionType.connectionError),
      );

      final result = await sut.request<Map<String, dynamic>>(
        params: RequestParams.get('/products'),
        mapper: (json) => json,
      );

      expect(result.isFailure, isTrue);
      result.fold(
        (data) => fail('Expected failure'),
        (error) => expect(error, isA<ConnectionFailure>()),
      );
    });

    test('should return TimeoutFailure on timeout', () async {
      when(
        () => mockClient.get(
          any(),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(
        const ClientException(type: ClientExceptionType.connectionTimeout),
      );

      final result = await sut.request<Map<String, dynamic>>(
        params: RequestParams.get('/products'),
        mapper: (json) => json,
      );

      expect(result.isFailure, isTrue);
      result.fold(
        (data) => fail('Expected failure'),
        (error) => expect(error, isA<TimeoutFailure>()),
      );
    });

    test('should normalize list response', () async {
      when(
        () => mockClient.get(
          any(),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => const NetworkResponse(
          statusCode: 200,
          data: [
            {'id': 1},
            {'id': 2},
          ],
        ),
      );

      final result = await sut.request<Map<String, dynamic>>(
        params: RequestParams.get('/products'),
        mapper: (json) => json,
      );

      expect(result.isSuccess, isTrue);
      result.fold(
        (data) => expect(data['data'], isA<List>()),
        (error) => fail('Expected success'),
      );
    });
  });
}
