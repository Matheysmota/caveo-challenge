import 'package:dori/dori.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/riverpod_export/riverpod_export.dart';

import 'package:caveo_challenge/app/app_widget.dart';
import 'package:caveo_challenge/app/di/app_providers.dart';
import 'package:caveo_challenge/features/splash/splash.barrel.dart';

import 'mocks/mock_local_cache_source.dart';

void main() {
  testWidgets('App smoke test - splash page renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localCacheSourceProvider.overrideWith(
            (ref) => Future.value(MockLocalCacheSource()),
          ),
          splashViewModelProvider.overrideWith(_StubSplashViewModel.new),
        ],
        child: const AppWidget(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(DoriSvg), findsOneWidget);
    expect(find.byType(DoriCircularProgress), findsOneWidget);
  });
}

class _StubSplashViewModel extends SplashViewModel {
  @override
  SplashState build() => const SplashLoading();
}
