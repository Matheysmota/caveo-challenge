import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:caveo_challenge/features/products/presentation/widgets/status_banners.dart';
import 'package:caveo_challenge/features/products/product_list_strings.dart';

void main() {
  Widget createWidget({
    bool isOffline = false,
    bool isDataStale = false,
    VoidCallback? onDismissStale,
  }) {
    return MaterialApp(
      theme: DoriTheme.light,
      home: Scaffold(
        body: StatusBanners(
          isOffline: isOffline,
          isDataStale: isDataStale,
          onDismissStale: onDismissStale,
        ),
      ),
    );
  }

  group('StatusBanners', () {
    testWidgets('should show nothing when both flags are false', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DoriStatusFeedbackBanner), findsNothing);
    });

    testWidgets('should show offline banner when isOffline is true', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(isOffline: true));

      expect(find.byType(DoriStatusFeedbackBanner), findsOneWidget);
      expect(find.text(ProductListStrings.offlineBanner), findsOneWidget);
    });

    testWidgets('should show stale data banner when isDataStale is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(isDataStale: true, onDismissStale: () {}),
      );

      expect(find.byType(DoriStatusFeedbackBanner), findsOneWidget);
      expect(find.text(ProductListStrings.staleDataBanner), findsOneWidget);
    });

    testWidgets('should show both banners when both flags are true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(isOffline: true, isDataStale: true, onDismissStale: () {}),
      );

      expect(find.byType(DoriStatusFeedbackBanner), findsNWidgets(2));
      expect(find.text(ProductListStrings.offlineBanner), findsOneWidget);
      expect(find.text(ProductListStrings.staleDataBanner), findsOneWidget);
    });

    testWidgets('should call onDismissStale when stale banner is dismissed', (
      tester,
    ) async {
      var dismissCalled = false;

      await tester.pumpWidget(
        createWidget(
          isDataStale: true,
          onDismissStale: () => dismissCalled = true,
        ),
      );

      // Find the dismiss button on the stale banner
      final dismissButton = find.byIcon(Icons.close);
      expect(dismissButton, findsOneWidget);

      await tester.tap(dismissButton);
      await tester.pump();

      expect(dismissCalled, isTrue);
    });
  });
}
