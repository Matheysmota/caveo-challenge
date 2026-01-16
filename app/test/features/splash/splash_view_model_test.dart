import 'package:caveo_challenge/features/splash/presentation/splash_state.dart';
import 'package:caveo_challenge/features/splash/presentation/splash_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/riverpod_export/riverpod_export.dart';

void main() {
  group('SplashViewModel', () {
    test('should start with SplashReady state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final state = container.read(splashViewModelProvider);

      expect(state, isA<SplashReady>());
    });

    test('should remain in SplashReady after minimum display time', () async {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final states = <SplashState>[];
      container.listen(
        splashViewModelProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(
        SplashConfig.minimumDisplayDuration + const Duration(milliseconds: 200),
      );

      expect(states.first, isA<SplashReady>());
      expect(states.last, isA<SplashReady>());
    });

    test('should not transition before minimum display time', () async {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final states = <SplashState>[];
      container.listen(
        splashViewModelProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // Wait less than minimum time
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Should still be in initial state (only one state recorded)
      expect(states.length, 1);
      expect(states.first, isA<SplashReady>());
    });

    test('should reset state on retry', () async {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(splashViewModelProvider.notifier);

      // Wait for initial completion
      await Future<void>.delayed(
        SplashConfig.minimumDisplayDuration + const Duration(milliseconds: 200),
      );

      notifier.retry();

      expect(container.read(splashViewModelProvider), isA<SplashReady>());
    });
  });

  group('SplashConfig', () {
    test('minimumDisplayDuration should be 1 second', () {
      expect(SplashConfig.minimumDisplayDuration, const Duration(seconds: 1));
    });

    test('timeoutDuration should be 10 seconds', () {
      expect(SplashConfig.timeoutDuration, const Duration(seconds: 10));
    });
  });

  group('SplashState equality', () {
    test('SplashReady instances should be equal', () {
      expect(const SplashReady(), const SplashReady());
    });

    test('SplashError with same failure should be equal', () {
      const failure = TimeoutFailure(message: 'test');

      expect(
        const SplashError(failure: failure),
        const SplashError(failure: failure),
      );
    });

    test('SplashError with different failures should not be equal', () {
      const failure1 = TimeoutFailure(message: 'error 1');
      const failure2 = TimeoutFailure(message: 'error 2');

      expect(
        const SplashError(failure: failure1),
        isNot(const SplashError(failure: failure2)),
      );
    });
  });
}
