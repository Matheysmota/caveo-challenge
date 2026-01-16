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
        'should render with extra small size when DoriIconButtonSize.xs is provided',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.close,
            size: DoriIconButtonSize.xs,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert - Check internal icon has xs size (xxs = 12dp)
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconButtonSize.xs.iconSize.value));
        },
      );

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

      testWidgets(
        'should render with large size when DoriIconButtonSize.lg is provided',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.arrowBack,
            size: DoriIconButtonSize.lg,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert - Check internal icon has large size (md = 24dp)
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconButtonSize.lg.iconSize.value));
        },
      );

      testWidgets(
        'should render with extra large size when DoriIconButtonSize.xlg is provided',
        (tester) async {
          // Arrange
          final button = DoriIconButton(
            icon: DoriIconData.refresh,
            size: DoriIconButtonSize.xlg,
            onPressed: () {},
          );

          // Act
          await tester.pumpWidget(buildTestWidget(button));

          // Assert - Check internal icon has xlg size (lg = 32dp)
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(
            iconWidget.size,
            equals(DoriIconButtonSize.xlg.iconSize.value),
          );
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
        expect(DoriIconButtonSize.xs.totalSize, equals(16.0));
        expect(DoriIconButtonSize.sm.totalSize, equals(24.0));
        expect(DoriIconButtonSize.md.totalSize, equals(32.0));
        expect(DoriIconButtonSize.lg.totalSize, equals(40.0));
        expect(DoriIconButtonSize.xlg.totalSize, equals(48.0));
      });

      test('should have correct icon size for each variant', () {
        // Arrange & Act & Assert
        // xs uses xxs icon (12dp) for clear buttons in inputs
        expect(DoriIconButtonSize.xs.iconSize, equals(DoriIconSize.xxs));
        // sm uses xs icon (16dp) for visibility, with 4dp padding
        expect(DoriIconButtonSize.sm.iconSize, equals(DoriIconSize.xs));
        expect(DoriIconButtonSize.md.iconSize, equals(DoriIconSize.sm));
        expect(DoriIconButtonSize.lg.iconSize, equals(DoriIconSize.md));
        expect(DoriIconButtonSize.xlg.iconSize, equals(DoriIconSize.lg));
      });

      test('should have correct padding for each variant', () {
        // xs: 16dp total - 12dp icon = 4dp total / 2 = 2dp per side
        expect(DoriIconButtonSize.xs.padding, equals(2.0));
        // sm: 24dp total - 16dp icon = 8dp total / 2 = 4dp per side
        expect(DoriIconButtonSize.sm.padding, equals(4.0));
        // md: 32dp total - 16dp icon = 16dp total / 2 = 8dp per side
        expect(DoriIconButtonSize.md.padding, equals(8.0));
        // lg: 40dp total - 24dp icon = 16dp total / 2 = 8dp per side
        expect(DoriIconButtonSize.lg.padding, equals(8.0));
        // xlg: 48dp total - 32dp icon = 16dp total / 2 = 8dp per side
        expect(DoriIconButtonSize.xlg.padding, equals(8.0));
      });
    });
  });
}
