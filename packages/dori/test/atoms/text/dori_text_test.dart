import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriText', () {
    Widget buildTestWidget(DoriText text) {
      return MaterialApp(
        theme: DoriTheme.light,
        home: Scaffold(body: Center(child: text)),
      );
    }

    group('rendering', () {
      testWidgets('should render text with provided label', (tester) async {
        // Arrange
        const label = 'Hello, World!';
        const text = DoriText(label: label);

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        expect(find.text(label), findsOneWidget);
      });

      testWidgets(
        'should render with default variant (description) when no variant provided',
        (tester) async {
          // Arrange
          const text = DoriText(label: 'Test');

          // Act
          await tester.pumpWidget(buildTestWidget(text));

          // Assert
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.style?.fontSize,
            equals(DoriTypography.sizeDescription),
          );
          expect(
            textWidget.style?.fontWeight,
            equals(DoriTypography.weightMedium),
          );
        },
      );

      testWidgets('should render with title5 variant when specified', (
        tester,
      ) async {
        // Arrange
        const text = DoriText(
          label: 'Title',
          variant: DoriTypographyVariant.title5,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, equals(DoriTypography.sizeTitle));
        expect(
          textWidget.style?.fontWeight,
          equals(DoriTypography.weightExtraBold),
        );
      });

      testWidgets('should render with descriptionBold variant when specified', (
        tester,
      ) async {
        // Arrange
        const text = DoriText(
          label: 'Bold Text',
          variant: DoriTypographyVariant.descriptionBold,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(
          textWidget.style?.fontSize,
          equals(DoriTypography.sizeDescription),
        );
        expect(textWidget.style?.fontWeight, equals(DoriTypography.weightBold));
      });

      testWidgets('should render with caption variant when specified', (
        tester,
      ) async {
        // Arrange
        const text = DoriText(
          label: 'Small text',
          variant: DoriTypographyVariant.caption,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, equals(DoriTypography.sizeCaption));
        expect(
          textWidget.style?.fontWeight,
          equals(DoriTypography.weightMedium),
        );
      });

      testWidgets('should render with captionBold variant when specified', (
        tester,
      ) async {
        // Arrange
        const text = DoriText(
          label: 'Bold small text',
          variant: DoriTypographyVariant.captionBold,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, equals(DoriTypography.sizeCaption));
        expect(textWidget.style?.fontWeight, equals(DoriTypography.weightBold));
      });

      testWidgets('should render with custom color when provided', (
        tester,
      ) async {
        // Arrange
        const customColor = Color(0xFFFF0000);
        const text = DoriText(label: 'Colored text', color: customColor);

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, equals(customColor));
      });
    });

    group('text properties', () {
      testWidgets('should apply maxLines when provided', (tester) async {
        // Arrange
        const text = DoriText(
          label: 'Long text that might need multiple lines',
          maxLines: 2,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.maxLines, equals(2));
      });

      testWidgets('should apply overflow when provided', (tester) async {
        // Arrange
        const text = DoriText(
          label: 'Text with ellipsis overflow',
          overflow: TextOverflow.ellipsis,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.overflow, equals(TextOverflow.ellipsis));
      });

      testWidgets('should apply textAlign when provided', (tester) async {
        // Arrange
        const text = DoriText(
          label: 'Centered text',
          textAlign: TextAlign.center,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.textAlign, equals(TextAlign.center));
      });

      testWidgets('should combine all properties correctly', (tester) async {
        // Arrange
        const customColor = Color(0xFF00FF00);
        const text = DoriText(
          label: 'Complete text',
          variant: DoriTypographyVariant.title5,
          color: customColor,
          maxLines: 1,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.right,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(text));

        // Assert
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, equals(DoriTypography.sizeTitle));
        expect(
          textWidget.style?.fontWeight,
          equals(DoriTypography.weightExtraBold),
        );
        expect(textWidget.style?.color, equals(customColor));
        expect(textWidget.maxLines, equals(1));
        expect(textWidget.overflow, equals(TextOverflow.fade));
        expect(textWidget.textAlign, equals(TextAlign.right));
      });
    });

    group('DoriTypographyVariant', () {
      test('should have correct style for each variant', () {
        // Arrange & Act & Assert
        expect(
          DoriTypographyVariant.title5.style.fontSize,
          equals(DoriTypography.sizeTitle),
        );
        expect(
          DoriTypographyVariant.description.style.fontSize,
          equals(DoriTypography.sizeDescription),
        );
        expect(
          DoriTypographyVariant.descriptionBold.style.fontSize,
          equals(DoriTypography.sizeDescription),
        );
        expect(
          DoriTypographyVariant.caption.style.fontSize,
          equals(DoriTypography.sizeCaption),
        );
        expect(
          DoriTypographyVariant.captionBold.style.fontSize,
          equals(DoriTypography.sizeCaption),
        );
      });

      test('should have correct font weight for each variant', () {
        // Arrange & Act & Assert
        expect(
          DoriTypographyVariant.title5.style.fontWeight,
          equals(DoriTypography.weightExtraBold),
        );
        expect(
          DoriTypographyVariant.description.style.fontWeight,
          equals(DoriTypography.weightMedium),
        );
        expect(
          DoriTypographyVariant.descriptionBold.style.fontWeight,
          equals(DoriTypography.weightBold),
        );
        expect(
          DoriTypographyVariant.caption.style.fontWeight,
          equals(DoriTypography.weightMedium),
        );
        expect(
          DoriTypographyVariant.captionBold.style.fontWeight,
          equals(DoriTypography.weightBold),
        );
      });
    });

    group('DoriTypography', () {
      test('should have correct size values', () {
        // Arrange & Act & Assert
        expect(DoriTypography.sizeTitle, equals(24.0));
        expect(DoriTypography.sizeDescription, equals(14.0));
        expect(DoriTypography.sizeCaption, equals(12.0));
      });

      test('should have correct font weights', () {
        // Arrange & Act & Assert
        expect(DoriTypography.weightMedium, equals(FontWeight.w500));
        expect(DoriTypography.weightBold, equals(FontWeight.w700));
        expect(DoriTypography.weightExtraBold, equals(FontWeight.w800));
      });

      test('should have Plus Jakarta Sans as font family', () {
        // Arrange & Act & Assert
        expect(DoriTypography.fontFamily, equals('PlusJakartaSans'));
      });
    });
  });
}
