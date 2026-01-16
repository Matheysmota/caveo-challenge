import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/result_export/result_export.dart';

void main() {
  group('Result', () {
    test('Success should create with value', () {
      final result = Success<int, String>(42);
      expect(result.value, equals(42));
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('Success fold should call onSuccess', () {
      final result = Success<int, String>(10);
      final folded = result.fold(
        (value) => 'Value: $value',
        (error) => 'Error: $error',
      );
      expect(folded, equals('Value: 10'));
    });

    test('Failure should create with error', () {
      final result = Failure<int, String>('error');
      expect(result.error, equals('error'));
      expect(result.isFailure, isTrue);
    });

    test('Failure fold should call onFailure', () {
      final result = Failure<int, String>('oops');
      final folded = result.fold(
        (value) => 'Value: $value',
        (error) => 'Error: $error',
      );
      expect(folded, equals('Error: oops'));
    });

    test('getOrThrow on Failure should throw', () {
      final result = Failure<int, String>('error');
      expect(() => result.getOrThrow(), throwsStateError);
    });

    test('getOrElse on Failure should return default', () {
      final result = Failure<int, String>('error');
      expect(result.getOrElse(42), equals(42));
    });

    test('equality for Success', () {
      final result1 = Success<int, String>(42);
      final result2 = Success<int, String>(42);
      expect(result1, equals(result2));
    });

    test('equality for Failure', () {
      final result1 = Failure<int, String>('error');
      final result2 = Failure<int, String>('error');
      expect(result1, equals(result2));
    });
  });
}
