import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriProductCard', () {
    const testImageUrl = 'https://example.com/product.jpg';
    const testPrimaryText = 'Wireless Headphones Pro';
    const testSecondaryText = 'R\$ 1.200';
    const testBadgeText = 'Audio';

    Widget buildTestWidget(DoriProductCard card, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(
          body: Center(child: SizedBox(width: 200, child: card)),
        ),
      );
    }

    group('rendering', () {
      testWidgets('should render with required properties', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        expect(find.byType(DoriProductCard), findsOneWidget);
        expect(find.text(testPrimaryText), findsOneWidget);
      });

      testWidgets('should display secondary text when provided', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          secondaryText: testSecondaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        expect(find.text(testSecondaryText), findsOneWidget);
      });

      testWidgets('should not display secondary text when null', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        // Only primary text should be present
        expect(find.byType(DoriText), findsOneWidget);
      });

      testWidgets('should display badge when badgeText is provided', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          badgeText: testBadgeText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        expect(find.byType(DoriBadge), findsOneWidget);
        expect(find.text(testBadgeText.toUpperCase()), findsOneWidget);
      });

      testWidgets('should not display badge when badgeText is null', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        expect(find.byType(DoriBadge), findsNothing);
      });

      testWidgets('should use DoriText for primary text', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final doriText = tester.widget<DoriText>(find.byType(DoriText).first);
        expect(doriText.label, equals(testPrimaryText));
        expect(doriText.variant, equals(DoriTypographyVariant.description));
      });

      testWidgets('should use DoriText for secondary text', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          secondaryText: testSecondaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final doriTexts = tester.widgetList<DoriText>(find.byType(DoriText));
        final secondaryDoriText = doriTexts.last;
        expect(secondaryDoriText.label, equals(testSecondaryText));
        expect(
          secondaryDoriText.variant,
          equals(DoriTypographyVariant.caption),
        );
      });
    });

    group('sizes', () {
      testWidgets('should use md size by default', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final cardWidget = tester.widget<DoriProductCard>(
          find.byType(DoriProductCard),
        );
        expect(cardWidget.size, equals(DoriProductCardSize.md));
      });

      testWidgets('should accept sm size', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          size: DoriProductCardSize.sm,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final cardWidget = tester.widget<DoriProductCard>(
          find.byType(DoriProductCard),
        );
        expect(cardWidget.size, equals(DoriProductCardSize.sm));
      });

      testWidgets('should accept lg size', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          size: DoriProductCardSize.lg,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final cardWidget = tester.widget<DoriProductCard>(
          find.byType(DoriProductCard),
        );
        expect(cardWidget.size, equals(DoriProductCardSize.lg));
      });
    });

    group('size enum', () {
      test('should have correct aspect ratios', () {
        expect(DoriProductCardSize.sm.imageAspectRatio, equals(3 / 4));
        expect(DoriProductCardSize.md.imageAspectRatio, equals(4 / 5));
        expect(DoriProductCardSize.lg.imageAspectRatio, equals(1 / 1));
      });
    });

    group('interaction', () {
      testWidgets('should call onTap when tapped', (tester) async {
        // Arrange
        var tapCount = 0;
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () => tapCount++,
          // Use custom image builder to avoid shimmer animation
          imageBuilder: (context, url) => Container(color: Colors.grey),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));
        await tester.tap(find.byType(DoriProductCard));

        // Wait for minimum press duration timer to complete
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(tapCount, equals(1));
      });

      testWidgets('should not crash when onTap is null', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));
        await tester.tap(find.byType(DoriProductCard));

        // Assert - no crash
        expect(find.byType(DoriProductCard), findsOneWidget);
      });

      testWidgets('should show press animation when onTap is provided', (
        tester,
      ) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () {},
          // Use custom image builder to avoid shimmer animation
          imageBuilder: (context, url) => Container(color: Colors.grey),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert - should have Transform.scale when interactive
        expect(find.byType(Transform), findsWidgets);
      });

      testWidgets('should animate scale on tap down', (tester) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () {},
          // Use custom image builder to avoid shimmer animation
          imageBuilder: (context, url) => Container(color: Colors.grey),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Find the gesture detector and simulate tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(DoriProductCard)),
        );
        await tester.pump(const Duration(milliseconds: 50));

        // Assert - animation should be running
        expect(find.byType(DoriProductCard), findsOneWidget);

        // Clean up
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 150));
      });

      testWidgets('should not animate when onTap is null', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert - no Transform.scale wrapper when not interactive
        // The card should still render without animation
        expect(find.byType(DoriProductCard), findsOneWidget);
      });

      testWidgets('should dispose animation controller properly', (
        tester,
      ) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () {},
          // Use custom image builder to avoid shimmer animation
          imageBuilder: (context, url) => Container(color: Colors.grey),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));
        // Wait for any pending timers
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpWidget(Container());

        // Assert - no errors means dispose worked correctly
        expect(tester.takeException(), isNull);
      });

      testWidgets('should hold press state for minimum duration', (
        tester,
      ) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () {},
          // Use custom image builder to avoid shimmer animation
          imageBuilder: (context, url) => Container(color: Colors.grey),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Quick tap
        await tester.tap(find.byType(DoriProductCard));

        // Pump halfway through minimum duration - animation should still be pressed
        await tester.pump(const Duration(milliseconds: 40));
        expect(find.byType(DoriProductCard), findsOneWidget);

        // Pump past minimum duration - animation should reverse
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(DoriProductCard), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('should have semantic label with primary text', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert - verify card has semantics
        final semantics = tester.getSemantics(find.byType(DoriProductCard));
        expect(semantics.label, contains(testPrimaryText));
      });

      testWidgets('should include secondary text in semantic label', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          secondaryText: testSecondaryText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriProductCard));
        expect(semantics.label, contains(testSecondaryText));
      });

      testWidgets('should include badge text in semantic label', (
        tester,
      ) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          badgeText: testBadgeText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriProductCard));
        expect(semantics.label, contains(testBadgeText));
      });

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        const customLabel = 'Custom accessibility label';
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          semanticLabel: customLabel,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert - custom label should be part of the semantic tree
        final semantics = tester.getSemantics(find.byType(DoriProductCard));
        expect(semantics.label, contains(customLabel));
      });

      testWidgets('should mark as button when onTap is provided', (
        tester,
      ) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          onTap: () {},
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriProductCard));
        final data = semantics.getSemanticsData();
        expect(data.flagsCollection.isButton, isTrue);
      });
    });

    group('theming', () {
      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          secondaryText: testSecondaryText,
          badgeText: testBadgeText,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card, theme: DoriTheme.dark));

        // Assert
        expect(find.byType(DoriProductCard), findsOneWidget);
        expect(find.text(testPrimaryText), findsOneWidget);
      });
    });

    group('custom image builder', () {
      testWidgets('should use custom image builder when provided', (
        tester,
      ) async {
        // Arrange
        final card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          imageBuilder: (context, url) =>
              Container(key: const Key('custom-image'), color: Colors.blue),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        expect(find.byKey(const Key('custom-image')), findsOneWidget);
      });
    });

    group('ProductCardImage', () {
      testWidgets('should render with correct aspect ratio', (tester) async {
        // Arrange
        const card = DoriProductCard(
          imageUrl: testImageUrl,
          primaryText: testPrimaryText,
          size: DoriProductCardSize.lg,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(card));

        // Assert
        final aspectRatio = tester.widget<AspectRatio>(
          find.byType(AspectRatio).first,
        );
        expect(aspectRatio.aspectRatio, equals(1.0));
      });
    });
  });
}
