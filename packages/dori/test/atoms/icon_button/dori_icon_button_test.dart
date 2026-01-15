import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriIconButton', () {
    Widget buildTestWidget(DoriIconButton button) {
      return MaterialApp(
        theme: DoriTheme.light,
        home: Scaffold(body: Center(child: button)),
      );
    }

    group('rendering', () {
      testWidgets('should render with default size when no size is provided', (
        tester,
      ) async {
        // Arrange
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert - Check the DoriIconButton renders
        expect(find.byType(DoriIconButton), findsOneWidget);

        // Assert - Check internal icon has correct size
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.size, equals(DoriIconButtonSize.md.iconSize.value));
      });

      testWidgets(
        'should render with small size when DoriIconButtonSize.sm is provided',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.close,
            size: DoriIconButtonSize.sm,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert - Check internal icon has small size
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconButtonSize.sm.iconSize.value));
        },
      );

      testWidgets('should render with custom icon color when provided', (
        tester,
      ) async {
        // Arrange
        const customColor = Color(0xFFFF0000);
        final button = DoriIconButton(
          icon: DoriIconData.error,
          iconColor: customColor,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.color, equals(customColor));
      });

      testWidgets('should render with custom background color when provided', (
        tester,
      ) async {
        // Arrange
        const customColor = Color(0xFF0000FF);
        final button = DoriIconButton(
          icon: DoriIconData.info,
          backgroundColor: customColor,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert - Find Material widget that wraps the button
        final materialFinder = find.descendant(
          of: find.byType(DoriIconButton),
          matching: find.byType(Material),
        );
        final material = tester.widget<Material>(materialFinder);
        expect(material.color, equals(customColor));
      });

      testWidgets('should have circular shape', (tester) async {
        // Arrange
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final materialFinder = find.descendant(
          of: find.byType(DoriIconButton),
          matching: find.byType(Material),
        );
        final material = tester.widget<Material>(materialFinder);
        expect(material.shape, isA<CircleBorder>());
      });
    });

    group('interaction', () {
      testWidgets('should call onPressed when tapped', (tester) async {
        // Arrange
        var wasPressed = false;
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: () => wasPressed = true,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));
        await tester.tap(find.byType(DoriIconButton));
        await tester.pump();

        // Assert
        expect(wasPressed, isTrue);
      });

      testWidgets('should not call onPressed when disabled', (tester) async {
        // Arrange
        var wasPressed = false;
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: null,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));
        await tester.tap(find.byType(DoriIconButton));
        await tester.pump();

        // Assert
        expect(wasPressed, isFalse);
      });

      testWidgets('should have InkWell for touch feedback', (tester) async {
        // Arrange
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final inkWellFinder = find.descendant(
          of: find.byType(DoriIconButton),
          matching: find.byType(InkWell),
        );
        expect(inkWellFinder, findsOneWidget);
      });
    });

    group('disabled state', () {
      testWidgets(
        'should apply reduced opacity to background color when disabled',
        (tester) async {
          // Arrange
          const backgroundColor = Color(0xFF0000FF);
          final enabledButton = DoriIconButton(
            icon: DoriIconData.search,
            backgroundColor: backgroundColor,
            onPressed: () {},
          );
          final disabledButton = DoriIconButton(
            icon: DoriIconData.search,
            backgroundColor: backgroundColor,
            onPressed: null,
          );

          // Act - Get enabled state color
          await tester.pumpWidget(buildTestWidget(enabledButton));
          final enabledMaterialFinder = find.descendant(
            of: find.byType(DoriIconButton),
            matching: find.byType(Material),
          );
          final enabledMaterial = tester.widget<Material>(
            enabledMaterialFinder,
          );
          final enabledColor = enabledMaterial.color!;

          // Act - Get disabled state color
          await tester.pumpWidget(buildTestWidget(disabledButton));
          final disabledMaterialFinder = find.descendant(
            of: find.byType(DoriIconButton),
            matching: find.byType(Material),
          );
          final disabledMaterial = tester.widget<Material>(
            disabledMaterialFinder,
          );
          final disabledColor = disabledMaterial.color!;

          // Assert - Disabled should have lower opacity
          expect(disabledColor.a, lessThan(enabledColor.a));
        },
      );

      testWidgets('should apply reduced opacity to icon color when disabled', (
        tester,
      ) async {
        // Arrange
        const iconColor = Color(0xFFFF0000);
        final enabledButton = DoriIconButton(
          icon: DoriIconData.search,
          iconColor: iconColor,
          onPressed: () {},
        );
        final disabledButton = DoriIconButton(
          icon: DoriIconData.search,
          iconColor: iconColor,
          onPressed: null,
        );

        // Act - Get enabled state color
        await tester.pumpWidget(buildTestWidget(enabledButton));
        final enabledIcon = tester.widget<Icon>(find.byType(Icon));
        final enabledColor = enabledIcon.color!;

        // Act - Get disabled state color
        await tester.pumpWidget(buildTestWidget(disabledButton));
        final disabledIcon = tester.widget<Icon>(find.byType(Icon));
        final disabledColor = disabledIcon.color!;

        // Assert - Disabled should have lower opacity
        expect(disabledColor.a, lessThan(enabledColor.a));
      });

      testWidgets('should not use Opacity widget to preserve ripple effect', (
        tester,
      ) async {
        // Arrange
        final button = DoriIconButton(
          icon: DoriIconData.search,
          onPressed: null,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert - Should not wrap in Opacity widget directly under DoriIconButton
        final opacityFinder = find.descendant(
          of: find.byType(DoriIconButton),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Opacity &&
                widget.opacity != 1.0 &&
                widget.opacity != 0.0,
          ),
        );
        expect(opacityFinder, findsNothing);
      });
    });

    group('accessibility', () {
      testWidgets(
        'should have semantic label from icon when no custom label is provided',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.search,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert
          final semantics = tester.getSemantics(find.byType(DoriIconButton));
          expect(semantics.label, equals(DoriIconData.search.semanticLabel));
        },
      );

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        const customLabel = 'Open search dialog';
        final button = DoriIconButton(
          icon: DoriIconData.search,
          semanticLabel: customLabel,
          onPressed: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(button));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriIconButton));
        expect(semantics.label, equals(customLabel));
      });

      testWidgets(
        'should exclude child semantics to avoid duplicate announcements',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.search,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert - Verify excludeSemantics is true on first Semantics widget
          final semanticsFinder = find.descendant(
            of: find.byType(DoriIconButton),
            matching: find.byType(Semantics),
          );
          final semanticsWidget = tester.widget<Semantics>(
            semanticsFinder.first,
          );
          expect(semanticsWidget.excludeSemantics, isTrue);
        },
      );
    });

    group('DoriIconButtonSize', () {
      test('should have correct total size for each variant', () {
        // Arrange & Act & Assert
        expect(DoriIconButtonSize.sm.totalSize, equals(32.0));
        expect(DoriIconButtonSize.md.totalSize, equals(40.0));
      });

      test('should have correct icon size for each variant', () {
        // Arrange & Act & Assert
        expect(DoriIconButtonSize.sm.iconSize, equals(DoriIconSize.sm));
        expect(DoriIconButtonSize.md.iconSize, equals(DoriIconSize.md));
      });
    });
  });
}
