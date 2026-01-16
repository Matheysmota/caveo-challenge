import 'package:caveo_challenge/features/splash/presentation/view_models/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/network_failure.dart';

void main() {
  group('SplashState', () {
    group('SplashLoading', () {
      test('should be equal to another SplashLoading', () {
        // Arrange
        const state1 = SplashLoading();
        const state2 = SplashLoading();

        // Assert
        expect(state1, equals(state2));
        expect(state1.props, isEmpty);
      });
    });

    group('SplashSuccess', () {
      test('should be equal to another SplashSuccess', () {
        // Arrange
        const state1 = SplashSuccess();
        const state2 = SplashSuccess();

        // Assert
        expect(state1, equals(state2));
        expect(state1.props, isEmpty);
      });
    });

    group('SplashError', () {
      test('should contain failure in props', () {
        // Arrange
        const failure = ConnectionFailure(message: 'No internet');
        const state = SplashError(failure: failure);

        // Assert
        expect(state.failure, failure);
        expect(state.props, contains(failure));
      });

      test('should be equal when failure is the same', () {
        // Arrange
        const failure = ConnectionFailure(message: 'No internet');
        const state1 = SplashError(failure: failure);
        const state2 = SplashError(failure: failure);

        // Assert
        expect(state1, equals(state2));
      });

      test('should not be equal when failure is different', () {
        // Arrange
        const failure1 = ConnectionFailure(message: 'Error 1');
        const failure2 = ConnectionFailure(message: 'Error 2');
        const state1 = SplashError(failure: failure1);
        const state2 = SplashError(failure: failure2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should default isRetrying to false', () {
        // Arrange
        const failure = ConnectionFailure(message: 'Error');
        const state = SplashError(failure: failure);

        // Assert
        expect(state.isRetrying, isFalse);
      });

      test('should include isRetrying in equality check', () {
        // Arrange
        const failure = ConnectionFailure(message: 'Error');
        const state1 = SplashError(failure: failure);
        const state2 = SplashError(failure: failure, isRetrying: true);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should be equal when both failure and isRetrying match', () {
        // Arrange
        const failure = ConnectionFailure(message: 'Error');
        const state1 = SplashError(failure: failure, isRetrying: true);
        const state2 = SplashError(failure: failure, isRetrying: true);

        // Assert
        expect(state1, equals(state2));
      });
    });
  });
}
