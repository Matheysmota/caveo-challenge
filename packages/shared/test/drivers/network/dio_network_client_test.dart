import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/drivers/network/error/client_exception.dart';

class MockDio extends Mock implements Dio {}

class MockNetworkConfigProvider extends Mock implements NetworkConfigProvider {}

void main() {
  late MockDio mockDio;
  late DioNetworkClient sut;

  setUp(() {
    mockDio = MockDio();
    sut = DioNetworkClient.withDio(mockDio);
  });

  setUpAll(() {
    registerFallbackValue(Options());
  });

  group('DioNetworkClient', () {
    group('get', () {
      test('should return NetworkResponse on success', () async {
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
            data: {'id': 1},
          ),
        );

        final result = await sut.get('https://api.test.com/endpoint');

        expect(result.statusCode, 200);
        expect(result.data, {'id': 1});
        expect(result.isSuccess, isTrue);
      });

      test('should throw ClientException on DioException', () async {
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(),
          ),
        );

        expect(
          () => sut.get('https://api.test.com/endpoint'),
          throwsA(isA<ClientException>()),
        );
      });

      test('should map DioExceptionType.connectionTimeout correctly', () async {
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(),
          ),
        );

        try {
          await sut.get('https://api.test.com/endpoint');
          fail('Expected ClientException');
        } on ClientException catch (e) {
          expect(e.type, ClientExceptionType.connectionTimeout);
        }
      });

      test('should pass headers correctly', () async {
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
            data: {},
          ),
        );

        await sut.get(
          'https://api.test.com/endpoint',
          headers: {'Authorization': 'Bearer token'},
        );

        final captured = verify(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: captureAny(named: 'options'),
          ),
        ).captured;

        final options = captured.first as Options;
        expect(options.headers, {'Authorization': 'Bearer token'});
      });
    });

    group('post', () {
      test('should return NetworkResponse on success', () async {
        when(
          () => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 201,
            data: {'id': 1, 'created': true},
          ),
        );

        final result = await sut.post(
          'https://api.test.com/endpoint',
          body: {'name': 'Test'},
        );

        expect(result.statusCode, 201);
        expect(result.data, {'id': 1, 'created': true});
      });

      test('should throw ClientException on DioException', () async {
        when(
          () => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            type: DioExceptionType.sendTimeout,
            requestOptions: RequestOptions(),
          ),
        );

        try {
          await sut.post('https://api.test.com/endpoint');
          fail('Expected ClientException');
        } on ClientException catch (e) {
          expect(e.type, ClientExceptionType.sendTimeout);
        }
      });
    });

    group('response mapping', () {
      test('should map headers correctly', () async {
        final response = Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {},
          headers: Headers.fromMap({
            'Content-Type': ['application/json'],
            'X-Custom-Header': ['value1', 'value2'],
          }),
        );

        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        final result = await sut.get('https://api.test.com/endpoint');

        expect(result.headers['content-type'], 'application/json');
        expect(result.headers['x-custom-header'], 'value1, value2');
      });
    });
  });
}
