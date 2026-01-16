import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

import 'package:caveo_challenge/app/app_widget.dart';
import 'package:caveo_challenge/app/di/app_providers.dart';

import 'mocks/mock_local_cache_source.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localCacheSourceProvider.overrideWithValue(MockLocalCacheSource()),
        ],
        child: const AppWidget(),
      ),
    );

    // Pump a few frames to let the router initialize
    // (don't use pumpAndSettle because CircularProgressIndicator is animating)
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // The splash screen placeholder should be visible
    expect(find.text('Splash Screen Placeholder'), findsOneWidget);
  });
}
