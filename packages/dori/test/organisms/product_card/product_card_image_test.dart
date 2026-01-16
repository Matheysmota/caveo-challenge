import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductCardImage', () {
    const testImageUrl = 'https://example.com/product.jpg';
    const testAspectRatio = 4 / 5;

    Widget buildTestWidget(ProductCardImage image, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(
          body: Center(child: SizedBox(width: 200, child: image)),
        ),
      );
    }

    group('rendering', () {
      testWidgets('should render with required properties', (tester) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert
        expect(find.byType(ProductCardImage), findsOneWidget);
        expect(find.byType(AspectRatio), findsOneWidget);
      });

      testWidgets('should apply correct aspect ratio', (tester) async {
        // Arrange
        const customAspectRatio = 1.0;
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: customAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert
        final aspectRatio = tester.widget<AspectRatio>(
          find.byType(AspectRatio),
        );
        expect(aspectRatio.aspectRatio, equals(customAspectRatio));
      });

      testWidgets('should use ClipRRect for rounded corners', (tester) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert
        expect(find.byType(ClipRRect), findsOneWidget);
      });
    });

    group('custom image builder', () {
      testWidgets('should use custom image builder when provided', (
        tester,
      ) async {
        // Arrange
        final image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
          imageBuilder: (context, url) =>
              Container(key: const Key('custom-image'), color: Colors.blue),
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert
        expect(find.byKey(const Key('custom-image')), findsOneWidget);
      });

      testWidgets('should pass correct URL to image builder', (tester) async {
        // Arrange
        String? receivedUrl;
        final image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
          imageBuilder: (context, url) {
            receivedUrl = url;
            return Container();
          },
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert
        expect(receivedUrl, equals(testImageUrl));
      });
    });

    group('theming', () {
      testWidgets('should render correctly in light theme', (tester) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image, theme: DoriTheme.light));

        // Assert
        expect(find.byType(ProductCardImage), findsOneWidget);
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image, theme: DoriTheme.dark));

        // Assert
        expect(find.byType(ProductCardImage), findsOneWidget);
      });
    });

    group('shimmer loading', () {
      testWidgets('should be StatelessWidget that delegates to Image.network', (
        tester,
      ) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));

        // Assert - ProductCardImage is now a StatelessWidget
        // The shimmer is only instantiated via Image.network's loadingBuilder
        expect(find.byType(ProductCardImage), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('should render correctly when disposed', (tester) async {
        // Arrange
        const image = ProductCardImage(
          imageUrl: testImageUrl,
          aspectRatio: testAspectRatio,
        );

        // Act
        await tester.pumpWidget(buildTestWidget(image));
        await tester.pumpWidget(Container());

        // Assert - no errors means dispose worked correctly
        expect(tester.takeException(), isNull);
      });
    });
  });
}
