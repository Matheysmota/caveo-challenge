import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';

class MockEnvironmentReader extends Mock implements EnvironmentReader {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  group('EnvironmentNetworkConfig', () {
    late MockEnvironmentReader mockReader;
    late EnvironmentNetworkConfig config;

    setUp(() {
      mockReader = MockEnvironmentReader();
      config = EnvironmentNetworkConfig(mockReader);
    });

    test('baseUrl should call require on reader', () {
      when(
        () => mockReader.require('BASE_URL'),
      ).thenReturn('https://api.test.com');

      final result = config.baseUrl;

      expect(result, equals('https://api.test.com'));
      verify(() => mockReader.require('BASE_URL')).called(1);
    });

    test('connectTimeout should use getDuration', () {
      when(
        () => mockReader.getDuration(
          'CONNECT_TIMEOUT',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(const Duration(seconds: 15));

      final result = config.connectTimeout;

      expect(result, equals(const Duration(seconds: 15)));
    });

    test('should use default timeout when not configured', () {
      when(
        () => mockReader.getDuration(
          'RECEIVE_TIMEOUT',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(const Duration(seconds: 30));

      final result = config.receiveTimeout;

      expect(result, equals(const Duration(seconds: 30)));
    });
  });

  group('DotEnvReader', () {
    test('fromMap should create reader with provided env', () {
      final reader = DotEnvReader.fromMap({'KEY': 'value'});

      expect(reader.get('KEY'), equals('value'));
      expect(reader.get('MISSING'), isNull);
    });

    test('require should throw on missing key', () {
      final reader = DotEnvReader.fromMap({});

      expect(() => reader.require('MISSING'), throwsStateError);
    });

    test('getInt should parse integer', () {
      final reader = DotEnvReader.fromMap({'NUM': '42'});

      expect(reader.getInt('NUM'), equals(42));
    });

    test('getInt should return default on invalid', () {
      final reader = DotEnvReader.fromMap({'NUM': 'not_a_number'});

      expect(reader.getInt('NUM', defaultValue: 10), equals(10));
    });

    test('getDuration should return Duration from milliseconds', () {
      final reader = DotEnvReader.fromMap({'TIMEOUT': '5000'});

      final duration = reader.getDuration('TIMEOUT');

      expect(duration, equals(const Duration(milliseconds: 5000)));
    });
  });
}
