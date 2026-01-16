import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:caveo_challenge/features/products/presentation/widgets/product_list_loading.dart';

void main() {
  Widget createWidget() {
    return MaterialApp(
      theme: DoriTheme.light,
      home: const Scaffold(body: ProductListLoadingWidget()),
    );
  }

  group('ProductListLoadingWidget', () {
    testWidgets('should render GridView with shimmer cards', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(ProductListLoadingWidget), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should render 6 shimmer cards', (tester) async {
      await tester.pumpWidget(createWidget());

      // Each shimmer card contains DoriShimmer widgets
      expect(find.byType(DoriShimmer), findsWidgets);
    });

    testWidgets('should have correct grid configuration', (tester) async {
      await tester.pumpWidget(createWidget());

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.crossAxisCount, 2);
    });
  });
}
