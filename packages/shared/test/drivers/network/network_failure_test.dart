import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('NetworkFailure', () {
    test('HttpFailure with default message', () {
      const failure = HttpFailure(statusCode: 404);
      expect(failure.message, equals('Request failed with status 404'));
      expect(failure.statusCode, equals(404));
    });

    test('HttpFailure with custom message', () {
      const failure = HttpFailure(statusCode: 500, message: 'Server error');
      expect(failure.message, equals('Server error'));
    });

    test('HttpFailure equality', () {
      const f1 = HttpFailure(statusCode: 404);
      const f2 = HttpFailure(statusCode: 404);
      expect(f1, equals(f2));
    });

    test('ConnectionFailure default message', () {
      const failure = ConnectionFailure();
      expect(failure.message, contains('Unable to connect'));
    });

    test('TimeoutFailure default message', () {
      const failure = TimeoutFailure();
      expect(failure.message, contains('timed out'));
    });

    test('ParseFailure default message', () {
      const failure = ParseFailure();
      expect(failure.message, equals('Invalid response format.'));
    });

    test('UnknownNetworkFailure default message', () {
      const failure = UnknownNetworkFailure();
      expect(failure.message, equals('An unexpected error occurred.'));
    });

    test('pattern matching exhaustive', () {
      NetworkFailure failure = const HttpFailure(statusCode: 404);
      final message = switch (failure) {
        HttpFailure(:final statusCode) => 'HTTP $statusCode',
        ConnectionFailure() => 'Connection',
        TimeoutFailure() => 'Timeout',
        ParseFailure() => 'Parse',
        UnknownNetworkFailure() => 'Unknown',
      };
      expect(message, equals('HTTP 404'));
    });
  });
}
