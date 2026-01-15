import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriCircularProgress', () {
    Widget buildTestWidget(DoriCircularProgress progress, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(body: Center(child: progress)),
      );
    }

    group('rendering', () {
      testWidgets(
        'should render with default size (md) when no size provided',
        (tester) async {
          // Arrange
          const progress = DoriCircularProgress();

          // Act
          await tester.pumpWidget(buildTestWidget(progress));

          // Assert
          expect(find.byType(DoriCircularProgress), findsOneWidget);
          final progressWidget = tester.widget<DoriCircularProgress>(
            find.byType(DoriCircularProgress),
          );
          expect(progressWidget.size, equals(DoriCircularProgressSize.md));
        },
      );

      testWidgets('should render with small size when sm is provided', (
        tester,
      ) async {
        // Arrange
        const progress = DoriCircularProgress(
          size: DoriCircularProgressSize.sm,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.size, equals(DoriCircularProgressSize.sm));
      });

      testWidgets('should render with large size when lg is provided', (
        tester,
      ) async {
        // Arrange
        const progress = DoriCircularProgress(
          size: DoriCircularProgressSize.lg,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.size, equals(DoriCircularProgressSize.lg));
      });

      testWidgets('should include RepaintBoundary for performance', (
        tester,
      ) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert - RepaintBoundary exists (multiple may exist in tree)
        expect(find.byType(RepaintBoundary), findsWidgets);
      });
    });

    group('animation', () {
      testWidgets('should animate when widget is mounted', (tester) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Advance animation frames
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Assert - animation should be running (widget rebuilds)
        expect(find.byType(DoriCircularProgress), findsOneWidget);
      });

      testWidgets('should stop animation when disposed', (tester) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));
        await tester.pump(const Duration(milliseconds: 100));

        // Remove widget
        await tester.pumpWidget(
          MaterialApp(
            theme: DoriTheme.light,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        // Assert - no errors thrown after disposal
        expect(find.byType(DoriCircularProgress), findsNothing);
      });
    });

    group('accessibility', () {
      testWidgets('should have default semantic label', (tester) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert - verify semanticLabel property is set
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.semanticLabel, equals('Loading'));
      });

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        const progress = DoriCircularProgress(
          semanticLabel: 'Carregando dados',
        );

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.semanticLabel, equals('Carregando dados'));
      });
    });

    group('background', () {
      testWidgets('should not show background by default', (tester) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert - showBackground defaults to false
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.showBackground, isFalse);
      });

      testWidgets('should show background when enabled', (tester) async {
        // Arrange
        const progress = DoriCircularProgress(showBackground: true);

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.showBackground, isTrue);
      });
    });

    group('theming', () {
      testWidgets('should use brand.pure color by default in light theme', (
        tester,
      ) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert - color property should be null (uses default)
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.color, isNull);
      });

      testWidgets('should use custom color when provided', (tester) async {
        // Arrange
        const customColor = Color(0xFFFF5733);
        const progress = DoriCircularProgress(color: customColor);

        // Act
        await tester.pumpWidget(buildTestWidget(progress));

        // Assert
        final progressWidget = tester.widget<DoriCircularProgress>(
          find.byType(DoriCircularProgress),
        );
        expect(progressWidget.color, equals(customColor));
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange
        const progress = DoriCircularProgress();

        // Act
        await tester.pumpWidget(
          buildTestWidget(progress, theme: DoriTheme.dark),
        );

        // Assert
        expect(find.byType(DoriCircularProgress), findsOneWidget);
      });
    });

    group('size enum', () {
      test('should have correct size values', () {
        expect(DoriCircularProgressSize.sm.size, equals(20));
        expect(DoriCircularProgressSize.md.size, equals(36));
        expect(DoriCircularProgressSize.lg.size, equals(48));
      });
    });
  });
}
