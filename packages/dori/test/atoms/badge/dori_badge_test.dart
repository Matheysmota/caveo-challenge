import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriBadge', () {
    Widget buildTestWidget(DoriBadge badge, {bool isDark = false}) {
      return MaterialApp(
        theme: isDark ? DoriTheme.dark : DoriTheme.light,
        home: Scaffold(body: Center(child: badge)),
      );
    }

    group('rendering', () {
      testWidgets('should render badge with label text', (tester) async {
        // Arrange
        const badge = DoriBadge(label: 'New');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        expect(find.text('New'), findsOneWidget);
      });

      testWidgets('should render badge with default neutral variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Status');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        // Neutral uses surface.three color for better contrast
        expect(decoration.color, equals(DoriColors.light.surface.three));
      });

      testWidgets('should render badge with success variant', (tester) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Active',
          variant: DoriBadgeVariant.success,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.light.feedback.successSoft));
      });

      testWidgets('should render badge with error variant', (tester) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Error',
          variant: DoriBadgeVariant.error,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.light.feedback.errorSoft));
      });

      testWidgets('should render badge with info variant', (tester) async {
        // Arrange
        const badge = DoriBadge(label: 'Beta', variant: DoriBadgeVariant.info);

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.light.feedback.infoSoft));
      });
    });

    group('sizes', () {
      testWidgets('should render badge with default medium size padding', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Medium');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final padding = container.padding as EdgeInsets;
        expect(
          padding,
          equals(
            const EdgeInsets.symmetric(
              horizontal: DoriSpacing.sm,
              vertical: DoriSpacing.xxxs,
            ),
          ),
        );
      });

      testWidgets('should render badge with small size padding', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Small', size: DoriBadgeSize.sm);

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final padding = container.padding as EdgeInsets;
        expect(
          padding,
          equals(
            const EdgeInsets.symmetric(
              horizontal: DoriSpacing.xxs,
              vertical: DoriSpacing.xxxs / 2,
            ),
          ),
        );
      });
    });

    group('typography', () {
      testWidgets('should use captionBold typography style', (tester) async {
        // Arrange
        const badge = DoriBadge(label: 'Test');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Test'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w700));
        expect(textWidget.style?.fontSize, equals(DoriTypography.sizeCaption));
      });

      testWidgets('should use correct text color for neutral variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Neutral');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Neutral'));
        expect(textWidget.style?.color, equals(DoriColors.light.content.one));
      });

      testWidgets('should use correct text color for success variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Success',
          variant: DoriBadgeVariant.success,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Success'));
        expect(
          textWidget.style?.color,
          equals(DoriColors.light.feedback.success),
        );
      });

      testWidgets('should use correct text color for error variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Error',
          variant: DoriBadgeVariant.error,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Error'));
        expect(
          textWidget.style?.color,
          equals(DoriColors.light.feedback.error),
        );
      });

      testWidgets('should use correct text color for info variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Info', variant: DoriBadgeVariant.info);

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Info'));
        expect(textWidget.style?.color, equals(DoriColors.light.feedback.info));
      });
    });

    group('decoration', () {
      testWidgets('should have correct border radius', (tester) async {
        // Arrange
        const badge = DoriBadge(label: 'Rounded');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(DoriRadius.md));
      });

      testWidgets('should have shadow using DoriShadows.xs token', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Shadow');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.boxShadow, equals(DoriShadows.light.xs));
      });

      testWidgets('should have shadow for all variants', (tester) async {
        // Test all variants have shadow
        for (final variant in DoriBadgeVariant.values) {
          // Arrange
          final badge = DoriBadge(label: 'Test', variant: variant);

          // Act
          await tester.pumpWidget(buildTestWidget(badge));

          // Assert
          final container = tester.widget<Container>(find.byType(Container));
          final decoration = container.decoration as BoxDecoration;
          expect(
            decoration.boxShadow,
            isNotNull,
            reason: 'Shadow should exist for $variant',
          );
        }
      });
    });

    group('accessibility', () {
      testWidgets(
        'should have semantic label matching the label text by default',
        (tester) async {
          // Arrange
          const badge = DoriBadge(label: 'Status');

          // Act
          await tester.pumpWidget(buildTestWidget(badge));

          // Assert
          final semantics = tester.getSemantics(find.byType(DoriBadge));
          expect(semantics.label, equals('Status'));
        },
      );

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: '3', semanticLabel: '3 notifications');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriBadge));
        expect(semantics.label, equals('3 notifications'));
      });

      testWidgets('should exclude child semantics', (tester) async {
        // Arrange
        const badge = DoriBadge(label: 'Test');

        // Act
        await tester.pumpWidget(buildTestWidget(badge));

        // Assert
        final semanticsFinder = find.bySemanticsLabel('Test');
        // Should find exactly one semantic node (the parent Semantics widget)
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('dark mode', () {
      testWidgets('should use dark mode colors for neutral variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Dark');

        // Act
        await tester.pumpWidget(buildTestWidget(badge, isDark: true));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.dark.surface.three));
      });

      testWidgets('should use dark mode text color for neutral variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Dark');

        // Act
        await tester.pumpWidget(buildTestWidget(badge, isDark: true));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Dark'));
        expect(textWidget.style?.color, equals(DoriColors.dark.content.one));
      });

      testWidgets('should use dark mode soft background for success variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Success',
          variant: DoriBadgeVariant.success,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge, isDark: true));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.dark.feedback.successSoft));
      });

      testWidgets('should use dark mode soft background for error variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(
          label: 'Error',
          variant: DoriBadgeVariant.error,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(badge, isDark: true));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.dark.feedback.errorSoft));
      });

      testWidgets('should use dark mode soft background for info variant', (
        tester,
      ) async {
        // Arrange
        const badge = DoriBadge(label: 'Info', variant: DoriBadgeVariant.info);

        // Act
        await tester.pumpWidget(buildTestWidget(badge, isDark: true));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.dark.feedback.infoSoft));
      });

      testWidgets(
        'should use light green text color for success variant in dark mode',
        (tester) async {
          // Arrange
          const badge = DoriBadge(
            label: 'Success',
            variant: DoriBadgeVariant.success,
          );

          // Act
          await tester.pumpWidget(buildTestWidget(badge, isDark: true));

          // Assert
          final textWidget = tester.widget<Text>(find.text('Success'));
          expect(
            textWidget.style?.color,
            equals(DoriColors.dark.feedback.successLight),
          );
        },
      );

      testWidgets(
        'should use light red text color for error variant in dark mode',
        (tester) async {
          // Arrange
          const badge = DoriBadge(
            label: 'Error',
            variant: DoriBadgeVariant.error,
          );

          // Act
          await tester.pumpWidget(buildTestWidget(badge, isDark: true));

          // Assert
          final textWidget = tester.widget<Text>(find.text('Error'));
          expect(
            textWidget.style?.color,
            equals(DoriColors.dark.feedback.errorLight),
          );
        },
      );

      testWidgets(
        'should use light blue text color for info variant in dark mode',
        (tester) async {
          // Arrange
          const badge = DoriBadge(
            label: 'Info',
            variant: DoriBadgeVariant.info,
          );

          // Act
          await tester.pumpWidget(buildTestWidget(badge, isDark: true));

          // Assert
          final textWidget = tester.widget<Text>(find.text('Info'));
          expect(
            textWidget.style?.color,
            equals(DoriColors.dark.feedback.infoLight),
          );
        },
      );
    });

    group('DoriBadgeVariant', () {
      test('should have all expected variants', () {
        // Arrange & Act & Assert
        expect(DoriBadgeVariant.values.length, equals(4));
        expect(DoriBadgeVariant.values, contains(DoriBadgeVariant.neutral));
        expect(DoriBadgeVariant.values, contains(DoriBadgeVariant.success));
        expect(DoriBadgeVariant.values, contains(DoriBadgeVariant.error));
        expect(DoriBadgeVariant.values, contains(DoriBadgeVariant.info));
      });
    });

    group('DoriBadgeSize', () {
      test('should have all expected sizes', () {
        // Arrange & Act & Assert
        expect(DoriBadgeSize.values.length, equals(2));
        expect(DoriBadgeSize.values, contains(DoriBadgeSize.sm));
        expect(DoriBadgeSize.values, contains(DoriBadgeSize.md));
      });
    });
  });
}
