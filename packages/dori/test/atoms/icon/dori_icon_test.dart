import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriIcon', () {
    Widget buildTestWidget(DoriIcon icon) {
      return MaterialApp(
        theme: DoriTheme.light,
        home: Scaffold(body: Center(child: icon)),
      );
    }

    group('rendering', () {
      testWidgets(
        'should render icon with default size when no size is provided',
        (tester) async {
          // Arrange
          const icon = DoriIcon(icon: DoriIconData.search);

          // Act
          await tester.pumpWidget(buildTestWidget(icon));

          // Assert
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconSize.md.value));
        },
      );

      testWidgets(
        'should render icon with small size when DoriIconSize.sm is provided',
        (tester) async {
          // Arrange
          const icon = DoriIcon(
            icon: DoriIconData.close,
            size: DoriIconSize.sm,
          );

          // Act
          await tester.pumpWidget(buildTestWidget(icon));

          // Assert
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconSize.sm.value));
        },
      );

      testWidgets(
        'should render icon with large size when DoriIconSize.lg is provided',
        (tester) async {
          // Arrange
          const icon = DoriIcon(
            icon: DoriIconData.refresh,
            size: DoriIconSize.lg,
          );

          // Act
          await tester.pumpWidget(buildTestWidget(icon));

          // Assert
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, equals(DoriIconSize.lg.value));
        },
      );

      testWidgets(
        'should render icon with custom color when color is provided',
        (tester) async {
          // Arrange
          const customColor = Color(0xFFFF0000);
          const icon = DoriIcon(icon: DoriIconData.error, color: customColor);

          // Act
          await tester.pumpWidget(buildTestWidget(icon));

          // Assert
          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.color, equals(customColor));
        },
      );

      testWidgets('should render correct Material icon for each DoriIconData', (
        tester,
      ) async {
        // Arrange & Act & Assert for each icon
        for (final iconData in DoriIconData.values) {
          final icon = DoriIcon(icon: iconData);
          await tester.pumpWidget(buildTestWidget(icon));

          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(
            iconWidget.icon,
            equals(iconData.icon),
            reason: 'Icon ${iconData.name} should render correctly',
          );
        }
      });
    });

    group('accessibility', () {
      testWidgets(
        'should have default semantic label when no custom label is provided',
        (tester) async {
          // Arrange
          const icon = DoriIcon(icon: DoriIconData.search);

          // Act
          await tester.pumpWidget(buildTestWidget(icon));

          // Assert
          final semantics = tester.getSemantics(find.byType(DoriIcon));
          expect(semantics.label, equals(DoriIconData.search.semanticLabel));
        },
      );

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        const customLabel = 'Custom search label';
        const icon = DoriIcon(
          icon: DoriIconData.search,
          semanticLabel: customLabel,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(icon));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriIcon));
        expect(semantics.label, equals(customLabel));
      });

      testWidgets('should use ExcludeSemantics on child Icon', (tester) async {
        // Arrange
        const icon = DoriIcon(icon: DoriIconData.info);

        // Act
        await tester.pumpWidget(buildTestWidget(icon));

        // Assert - At least one ExcludeSemantics widget should be present
        final excludeSemanticsFinder = find.descendant(
          of: find.byType(DoriIcon),
          matching: find.byType(ExcludeSemantics),
        );
        expect(excludeSemanticsFinder, findsWidgets);
      });
    });

    group('DoriIconData', () {
      test('should have semantic label for all icons', () {
        // Arrange & Act & Assert
        for (final iconData in DoriIconData.values) {
          expect(
            iconData.semanticLabel,
            isNotEmpty,
            reason: 'Icon ${iconData.name} should have a semantic label',
          );
        }
      });

      test('should have valid IconData for all icons', () {
        // Arrange & Act & Assert
        for (final iconData in DoriIconData.values) {
          expect(
            iconData.icon,
            isA<IconData>(),
            reason: 'Icon ${iconData.name} should have valid IconData',
          );
        }
      });
    });

    group('DoriIconSize', () {
      test('should have correct values for each size', () {
        // Arrange & Act & Assert
        expect(DoriIconSize.sm.value, equals(16.0));
        expect(DoriIconSize.md.value, equals(24.0));
        expect(DoriIconSize.lg.value, equals(32.0));
      });
    });
  });
}
