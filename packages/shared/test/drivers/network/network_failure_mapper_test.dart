import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/drivers/network/error/client_exception.dart';
import 'package:shared/src/drivers/network/error/network_failure_mapper.dart';

void main() {
  late NetworkFailureMapper sut;

  setUp(() {
    sut = const NetworkFailureMapper();
  });

  group('NetworkFailureMapper', () {
    test('should map connectionError to ConnectionFailure', () {
      const exception = ClientException(
        type: ClientExceptionType.connectionError,
      );

      final result = sut.map(exception);

      expect(result, isA<ConnectionFailure>());
    });

    test('should map connectionTimeout to TimeoutFailure', () {
      const exception = ClientException(
        type: ClientExceptionType.connectionTimeout,
      );

      final result = sut.map(exception);

      expect(result, isA<TimeoutFailure>());
    });

    test('should map sendTimeout to TimeoutFailure', () {
      const exception = ClientException(type: ClientExceptionType.sendTimeout);

      final result = sut.map(exception);

      expect(result, isA<TimeoutFailure>());
    });

    test('should map receiveTimeout to TimeoutFailure', () {
      const exception = ClientException(
        type: ClientExceptionType.receiveTimeout,
      );

      final result = sut.map(exception);

      expect(result, isA<TimeoutFailure>());
    });

    test('should map badResponse to HttpFailure with statusCode', () {
      const exception = ClientException(
        type: ClientExceptionType.badResponse,
        statusCode: 404,
        responseData: {'error': 'Not found'},
      );

      final result = sut.map(exception);

      expect(result, isA<HttpFailure>());
      final httpFailure = result as HttpFailure;
      expect(httpFailure.statusCode, 404);
      expect(httpFailure.responseBody, {'error': 'Not found'});
    });

    test('should map badCertificate to ConnectionFailure', () {
      const exception = ClientException(
        type: ClientExceptionType.badCertificate,
      );

      final result = sut.map(exception);

      expect(result, isA<ConnectionFailure>());
      expect(result.message, 'Security certificate error.');
    });

    test('should map cancel to CancelledFailure', () {
      const exception = ClientException(type: ClientExceptionType.cancel);

      final result = sut.map(exception);

      expect(result, isA<CancelledFailure>());
    });

    test('should map unknown to UnknownNetworkFailure', () {
      const exception = ClientException(
        type: ClientExceptionType.unknown,
        message: 'Something went wrong',
      );

      final result = sut.map(exception);

      expect(result, isA<UnknownNetworkFailure>());
      expect(result.message, 'Something went wrong');
    });

    test('should use default message for unknown when message is null', () {
      const exception = ClientException(type: ClientExceptionType.unknown);

      final result = sut.map(exception);

      expect(result, isA<UnknownNetworkFailure>());
      expect(result.message, 'An unexpected error occurred.');
    });
  });
}
