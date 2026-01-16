import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriShimmer', () {
    Widget buildTestWidget(Widget child, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(
          body: Center(child: SizedBox(width: 200, child: child)),
        ),
      );
    }

    group('rendering', () {
      testWidgets('should render correctly', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(const DoriShimmer()));

        // Assert
        expect(find.byType(DoriShimmer), findsOneWidget);
      });

      testWidgets('should use AnimatedBuilder for shimmer effect', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(const DoriShimmer()));

        // Assert - at least one AnimatedBuilder exists in the tree
        expect(find.byType(AnimatedBuilder), findsWidgets);
      });
    });

    group('animation', () {
      testWidgets('should animate over time', (tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget(const DoriShimmer()));

        // Act - pump some frames to verify animation runs
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Assert - no errors during animation
        expect(find.byType(DoriShimmer), findsOneWidget);
      });

      testWidgets('should dispose animation controller properly', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget(const DoriShimmer()));
        await tester.pump(const Duration(milliseconds: 100));

        // Act - dispose by removing widget
        await tester.pumpWidget(Container());

        // Assert - no errors means dispose worked correctly
        expect(tester.takeException(), isNull);
      });

      testWidgets('should respect reduced motion settings', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: buildTestWidget(const DoriShimmer()),
          ),
        );

        // Assert - widget still renders
        expect(find.byType(DoriShimmer), findsOneWidget);
      });
    });

    group('theming', () {
      testWidgets('should render correctly in light theme', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          buildTestWidget(const DoriShimmer(), theme: DoriTheme.light),
        );

        // Assert
        expect(find.byType(DoriShimmer), findsOneWidget);
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          buildTestWidget(const DoriShimmer(), theme: DoriTheme.dark),
        );

        // Assert
        expect(find.byType(DoriShimmer), findsOneWidget);
      });
    });

    group('gradient', () {
      testWidgets('should use DecoratedBox with LinearGradient', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(const DoriShimmer()));

        // Assert
        expect(find.byType(DecoratedBox), findsOneWidget);

        final decoratedBox = tester.widget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        final boxDecoration = decoratedBox.decoration as BoxDecoration;
        expect(boxDecoration.gradient, isA<LinearGradient>());
      });
    });
  });
}
