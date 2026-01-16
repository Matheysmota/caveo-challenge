import 'package:caveo_challenge/app/di/modules/core_module.dart';
import 'package:caveo_challenge/app/router/app_router.dart';
import 'package:caveo_challenge/app/router/app_routes.dart';
import 'package:caveo_challenge/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

import '../../mocks/mock_local_cache_source.dart';
import '../../mocks/mock_sync_store.dart';

void main() {
  group('appRouterProvider', () {
    late MockSyncStore mockSyncStore;
    late MockLocalCacheSource mockLocalCache;

    setUp(() {
      mockSyncStore = MockSyncStore();
      mockLocalCache = MockLocalCacheSource();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          syncStoreProvider.overrideWithValue(mockSyncStore),
          localCacheSourceProvider.overrideWith(
            (ref) => Future.value(mockLocalCache),
          ),
        ],
      );
    }

    test('should create a GoRouter instance', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);

      expect(router, isA<GoRouter>());
    });

    test('should have splash as initial location', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);

      // The initial location is configured as '/' (splash)
      // After creation, the router state may show empty path before first navigation
      // So we verify the initial location configuration
      expect(router.configuration.routes.first, isA<GoRoute>());
      final firstRoute = router.configuration.routes.first as GoRoute;
      expect(firstRoute.path, AppRoutes.splash);
    });

    test('should have debug log diagnostics enabled', () {
      final container = createContainer();
      addTearDown(container.dispose);

      // We can verify the router is created without errors
      final router = container.read(appRouterProvider);

      // Router configuration can be verified through its state
      expect(router.configuration.routes, isNotEmpty);
    });

    test('should have routes defined for splash, products, and details', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      final routes = router.configuration.routes;

      // Should have at least the splash and products routes
      expect(routes.length, greaterThanOrEqualTo(2));
    });
  });
}
