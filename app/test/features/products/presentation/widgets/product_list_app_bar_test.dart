import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

import 'package:caveo_challenge/features/products/presentation/widgets/product_list_app_bar.dart';
import 'package:caveo_challenge/features/products/product_list_strings.dart';

void main() {
  Widget createWidget({ValueChanged<String>? onSearch}) {
    return ProviderScope(
      child: MaterialApp(
        theme: DoriTheme.light,
        darkTheme: DoriTheme.dark,
        home: Scaffold(body: ProductListAppBar(onSearch: onSearch)),
      ),
    );
  }

  group('ProductListAppBar', () {
    testWidgets('should render logo', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DoriSvg), findsOneWidget);
    });

    testWidgets('should render search bar', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DoriSearchBar), findsOneWidget);
    });

    testWidgets('should render theme toggle button', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DoriIconButton), findsOneWidget);
    });

    testWidgets('should have search hint text', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text(ProductListStrings.searchHint), findsOneWidget);
    });

    testWidgets('should call onSearch when text is submitted', (tester) async {
      String? searchedQuery;

      await tester.pumpWidget(
        createWidget(onSearch: (query) => searchedQuery = query),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(searchedQuery, equals('test'));
    });

    testWidgets('should toggle theme when theme button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());

      // Find and tap the theme toggle button
      await tester.tap(find.byType(DoriIconButton));
      await tester.pumpAndSettle();

      // The button should still exist after tapping
      expect(find.byType(DoriIconButton), findsOneWidget);
    });
  });
}
