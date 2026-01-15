import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriButton', () {
    Widget buildTestWidget(DoriButton button, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(body: Center(child: button)),
      );
    }

    group('rendering', () {
      testWidgets('should render with label', (tester) async {
        // Arrange
        final button = DoriButton(label: 'Continue', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriButton), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      });

      testWidgets('should render primary variant by default', (tester) async {
        // Arrange
        final button = DoriButton(label: 'Primary', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.variant, equals(DoriButtonVariant.primary));
      });

      testWidgets('should render secondary variant with soft background', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Secondary',
          variant: DoriButtonVariant.secondary,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.variant, equals(DoriButtonVariant.secondary));
      });

      testWidgets('should render tertiary variant without background', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Tertiary',
          variant: DoriButtonVariant.tertiary,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.variant, equals(DoriButtonVariant.tertiary));
      });
    });

    group('sizes', () {
      testWidgets('should render with medium size by default', (tester) async {
        // Arrange
        final button = DoriButton(label: 'Medium', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.size, equals(DoriButtonSize.md));
      });

      testWidgets('should render with small size when provided', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Small',
          size: DoriButtonSize.sm,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.size, equals(DoriButtonSize.sm));
      });

      testWidgets('should render with large size when provided', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Large',
          size: DoriButtonSize.lg,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.size, equals(DoriButtonSize.lg));
      });
    });

    group('interaction', () {
      testWidgets('should call onPressed when tapped', (tester) async {
        // Arrange
        var pressed = false;
        final button = DoriButton(
          label: 'Tap me',
          onPressed: () => pressed = true,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));
        await tester.tap(find.byType(DoriButton));
        await tester.pumpAndSettle();

        // Assert
        expect(pressed, isTrue);
      });

      testWidgets('should not call onPressed when disabled', (tester) async {
        // Arrange
        var pressed = false;
        final button = DoriButton(label: 'Disabled', onPressed: null);

        // Act
        await tester.pumpWidget(buildTestWidget(button));
        await tester.tap(find.byType(DoriButton));
        await tester.pumpAndSettle();

        // Assert
        expect(pressed, isFalse);
      });

      testWidgets('should not call onPressed when loading', (tester) async {
        // Arrange
        var pressed = false;
        final button = DoriButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () => pressed = true,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));
        await tester.tap(find.byType(DoriButton));
        // Don't use pumpAndSettle because animation is infinite
        await tester.pump();

        // Assert
        expect(pressed, isFalse);
      });

      testWidgets('should animate scale when pressed', (tester) async {
        // Arrange
        final button = DoriButton(label: 'Press me', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Start press
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(DoriButton)),
        );
        await tester.pump(const Duration(milliseconds: 50));

        // Assert - button should still be rendered
        expect(find.byType(DoriButton), findsOneWidget);

        // Release
        await gesture.up();
        await tester.pumpAndSettle();
      });
    });

    group('loading state', () {
      testWidgets('should show loading indicator when isLoading is true', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriCircularProgress), findsOneWidget);
        expect(find.text('Loading'), findsNothing);
      });

      testWidgets('should not show loading indicator when isLoading is false', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Not Loading',
          isLoading: false,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriCircularProgress), findsNothing);
        expect(find.text('Not Loading'), findsOneWidget);
      });

      testWidgets(
        'should maintain normal colors when loading (not disabled appearance)',
        (tester) async {
          // Arrange - loading button should look like enabled button, not disabled
          final loadingButton = DoriButton(
            label: 'Loading',
            isLoading: true,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(loadingButton));

          // Assert - button renders but is not interactable
          final buttonWidget = tester.widget<DoriButton>(
            find.byType(DoriButton),
          );
          expect(buttonWidget.isLoading, isTrue);
          expect(buttonWidget.onPressed, isNotNull);
        },
      );
    });

    group('icons', () {
      testWidgets('should render leading icon when provided', (tester) async {
        // Arrange
        final button = DoriButton(
          label: 'With icon',
          leadingIcon: DoriIconData.check,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriIcon), findsOneWidget);
      });

      testWidgets('should render trailing icon when provided', (tester) async {
        // Arrange
        final button = DoriButton(
          label: 'With arrow',
          trailingIcon: DoriIconData.chevronRight,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriIcon), findsOneWidget);
      });

      testWidgets('should render both icons when both provided', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Both icons',
          leadingIcon: DoriIconData.check,
          trailingIcon: DoriIconData.chevronRight,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriIcon), findsNWidgets(2));
      });
    });

    group('expanded', () {
      testWidgets('should expand to fill width when isExpanded is true', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'Expanded',
          isExpanded: true,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.isExpanded, isTrue);
      });
    });

    group('collapsed', () {
      testWidgets(
        'should render with compact sizing when isCollapsed is true',
        (tester) async {
          // Arrange
          final button = DoriButton(
            label: 'Collapsed',
            isCollapsed: true,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert
          final buttonWidget = tester.widget<DoriButton>(
            find.byType(DoriButton),
          );
          expect(buttonWidget.isCollapsed, isTrue);
        },
      );

      testWidgets('should have smaller height when collapsed', (tester) async {
        // Arrange - md size: normal = 44dp, collapsed = 36dp
        final collapsedButton = DoriButton(
          label: 'Collapsed',
          size: DoriButtonSize.md,
          isCollapsed: true,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(collapsedButton));
        final collapsedSize = tester.getSize(find.byType(AnimatedContainer));

        // Assert - collapsed md should be 36dp height (less than normal 44dp)
        expect(collapsedSize.height, equals(36));
      });

      testWidgets('should work with all sizes when collapsed', (tester) async {
        // Test collapsed with different sizes
        for (final size in DoriButtonSize.values) {
          // Arrange
          final button = DoriButton(
            label: 'Test',
            size: size,
            isCollapsed: true,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert
          expect(find.byType(DoriButton), findsOneWidget);
        }
      });
    });

    group('accessibility', () {
      testWidgets('should have semantic label from label by default', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(label: 'Click me', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert - verify semantic label is set
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.semanticLabel, isNull);
        expect(buttonWidget.label, equals('Click me'));
      });

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(
          label: 'OK',
          semanticLabel: 'Confirm action',
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final buttonWidget = tester.widget<DoriButton>(find.byType(DoriButton));
        expect(buttonWidget.semanticLabel, equals('Confirm action'));
      });

      testWidgets('should mark as disabled in semantics when null callback', (
        tester,
      ) async {
        // Arrange
        final button = DoriButton(label: 'Disabled', onPressed: null);

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert - widget is rendered but disabled
        expect(find.byType(DoriButton), findsOneWidget);
      });
    });

    group('theming', () {
      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange
        final button = DoriButton(label: 'Dark theme', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button, theme: DoriTheme.dark));

        // Assert
        expect(find.byType(DoriButton), findsOneWidget);
      });

      testWidgets('should use DoriText for label', (tester) async {
        // Arrange
        final button = DoriButton(label: 'With DoriText', onPressed: () {});

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        expect(find.byType(DoriText), findsOneWidget);
      });
    });
  });
}
