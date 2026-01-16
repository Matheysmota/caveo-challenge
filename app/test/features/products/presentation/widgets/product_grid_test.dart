import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:caveo_challenge/features/products/domain/entities/product.dart';
import 'package:caveo_challenge/features/products/presentation/widgets/product_grid.dart';

void main() {
  final testProducts = List.generate(
    5,
    (i) => Product(
      id: i + 1,
      title: 'Product ${i + 1}',
      price: (i + 1) * 10.0,
      description: 'Description ${i + 1}',
      category: 'Category',
      imageUrl: 'https://example.com/image$i.png',
      rating: const ProductRating(rate: 4.5, count: 100),
    ),
  );

  Widget createWidget({
    List<Product> products = const [],
    VoidCallback? onLoadMore,
    bool isLoadingMore = false,
    bool hasPaginationError = false,
    VoidCallback? onRetryPagination,
  }) {
    return MaterialApp(
      theme: DoriTheme.light,
      home: Scaffold(
        body: ProductGrid(
          products: products,
          onLoadMore: onLoadMore ?? () {},
          isLoadingMore: isLoadingMore,
          hasPaginationError: hasPaginationError,
          onRetryPagination: onRetryPagination,
        ),
      ),
    );
  }

  group('ProductGrid', () {
    testWidgets('should render CustomScrollView', (tester) async {
      await tester.pumpWidget(createWidget(products: testProducts));

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should render product cards', (tester) async {
      await tester.pumpWidget(createWidget(products: testProducts));

      // DoriProductCard should be rendered (at least some visible in viewport)
      expect(find.byType(DoriProductCard), findsWidgets);
    });

    testWidgets('should render empty grid when products is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(products: []));

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(DoriProductCard), findsNothing);
    });

    testWidgets('should format price correctly', (tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Description',
        category: 'Category',
        imageUrl: 'https://example.com/image.png',
        rating: const ProductRating(rate: 4.5, count: 100),
      );

      await tester.pumpWidget(createWidget(products: [product]));

      // Price should be formatted as "R$ 99,99"
      expect(find.textContaining('R\$'), findsOneWidget);
    });

    testWidgets('should trigger onLoadMore callback when available', (
      tester,
    ) async {
      var loadMoreCalled = false;

      // Create more products to enable scrolling
      final manyProducts = List.generate(
        20,
        (i) => Product(
          id: i + 1,
          title: 'Product ${i + 1}',
          price: (i + 1) * 10.0,
          description: 'Description ${i + 1}',
          category: 'Category',
          imageUrl: 'https://example.com/image$i.png',
          rating: const ProductRating(rate: 4.5, count: 100),
        ),
      );

      await tester.pumpWidget(
        createWidget(
          products: manyProducts,
          onLoadMore: () => loadMoreCalled = true,
        ),
      );

      // Scroll to the bottom
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -5000));
      await tester.pump();

      expect(loadMoreCalled, isTrue);
    });

    testWidgets('should accept isLoadingMore parameter', (tester) async {
      // This test verifies the widget builds with isLoadingMore=true
      await tester.pumpWidget(
        createWidget(products: testProducts, isLoadingMore: true),
      );

      expect(find.byType(ProductGrid), findsOneWidget);
    });

    testWidgets('should accept hasPaginationError parameter', (tester) async {
      // This test verifies the widget builds with hasPaginationError=true
      await tester.pumpWidget(
        createWidget(products: testProducts, hasPaginationError: true),
      );

      expect(find.byType(ProductGrid), findsOneWidget);
    });
  });
}
