import 'package:caveo_challenge/features/splash/presentation/widgets/splash_error_content.dart';
import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/network_failure.dart';

void main() {
  group('SplashErrorContent', () {
    Widget createWidget({
      required NetworkFailure failure,
      required VoidCallback onRetry,
      bool isRetrying = false,
    }) {
      return MaterialApp(
        theme: DoriTheme.light,
        home: Scaffold(
          body: SplashErrorContent(
            failure: failure,
            onRetry: onRetry,
            isRetrying: isRetrying,
          ),
        ),
      );
    }

    testWidgets('should display error message from failure', (tester) async {
      // Arrange
      const failure = ConnectionFailure(message: 'No internet connection');

      // Act
      await tester.pumpWidget(createWidget(failure: failure, onRetry: () {}));

      // Assert
      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('should display error icon', (tester) async {
      // Arrange
      const failure = ConnectionFailure(message: 'Error');

      // Act
      await tester.pumpWidget(createWidget(failure: failure, onRetry: () {}));

      // Assert
      expect(find.byType(DoriIcon), findsOneWidget);
    });

    testWidgets('should display retry button', (tester) async {
      // Arrange
      const failure = ConnectionFailure(message: 'Error');

      // Act
      await tester.pumpWidget(createWidget(failure: failure, onRetry: () {}));

      // Assert
      expect(find.byType(DoriButton), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('should call onRetry when button is pressed', (tester) async {
      // Arrange
      var retryCalled = false;
      const failure = ConnectionFailure(message: 'Error');

      // Act
      await tester.pumpWidget(
        createWidget(failure: failure, onRetry: () => retryCalled = true),
      );
      await tester.tap(find.byType(DoriButton));

      // Assert
      expect(retryCalled, isTrue);
    });

    testWidgets('should show loading indicator when isRetrying is true', (
      tester,
    ) async {
      // Arrange
      const failure = ConnectionFailure(message: 'Error');

      // Act
      await tester.pumpWidget(
        createWidget(failure: failure, onRetry: () {}, isRetrying: true),
      );

      // Assert
      expect(find.byType(DoriCircularProgress), findsOneWidget);
    });

    testWidgets('should disable button when isRetrying is true', (
      tester,
    ) async {
      // Arrange
      var retryCalled = false;
      const failure = ConnectionFailure(message: 'Error');

      // Act
      await tester.pumpWidget(
        createWidget(
          failure: failure,
          onRetry: () => retryCalled = true,
          isRetrying: true,
        ),
      );
      await tester.tap(find.byType(DoriButton));

      // Assert
      expect(retryCalled, isFalse);
    });

    testWidgets('should display different error types correctly', (
      tester,
    ) async {
      // Arrange
      const failure = TimeoutFailure(message: 'Request timed out');

      // Act
      await tester.pumpWidget(createWidget(failure: failure, onRetry: () {}));

      // Assert
      expect(find.text('Request timed out'), findsOneWidget);
    });
  });
}
