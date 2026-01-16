import 'dart:async';

import 'package:caveo_challenge/app/di/modules/core_module.dart';
import 'package:caveo_challenge/app/di/modules/products_module.dart';
import 'package:caveo_challenge/features/products/domain/entities/product.dart';
import 'package:caveo_challenge/features/products/domain/repositories/product_repository.dart';
import 'package:caveo_challenge/features/splash/presentation/view_models/splash_state.dart';
import 'package:caveo_challenge/features/splash/presentation/view_models/splash_view_model.dart';
import 'package:caveo_challenge/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';

class MockSyncStore extends Mock implements SyncStore {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockLocalCacheSource extends Mock implements LocalCacheSource {}

void main() {
  late MockSyncStore mockSyncStore;
  late MockProductRepository mockRepository;
  late MockLocalCacheSource mockLocalCache;
  late StreamController<SyncState<List<Product>>> streamController;

  setUp(() {
    mockSyncStore = MockSyncStore();
    mockRepository = MockProductRepository();
    mockLocalCache = MockLocalCacheSource();
    streamController = StreamController<SyncState<List<Product>>>.broadcast();

    // Default setup for hasKey
    when(() => mockSyncStore.hasKey(SyncStoreKey.products)).thenReturn(true);
  });

  tearDown(() async {
    await streamController.close();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        syncStoreProvider.overrideWithValue(mockSyncStore),
        productRepositoryProvider.overrideWithValue(mockRepository),
        localCacheSourceProvider.overrideWith(
          (ref) => Future.value(mockLocalCache),
        ),
      ],
    );
  }

  group('SplashViewModel', () {
    test('should start with SplashLoading state', () {
      // Arrange
      when(
        () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) => streamController.stream);
      when(
        () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) async => const SyncStateLoading<List<Product>>());

      // Act
      final container = createContainer();
      addTearDown(container.dispose);

      final state = container.read(splashViewModelProvider);

      // Assert
      expect(state, isA<SplashLoading>());
    });

    test(
      'should transition to SplashSuccess after sync and min time',
      () async {
        // Arrange
        when(
          () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
        ).thenAnswer((_) => streamController.stream);
        when(
          () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
        ).thenAnswer((_) async {
          streamController.add(const SyncStateSuccess<List<Product>>([]));
          return const SyncStateSuccess<List<Product>>([]);
        });

        final container = createContainer();
        addTearDown(container.dispose);

        final states = <SplashState>[];
        container.listen(
          splashViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // Act - Wait for minimum display time
        await Future<void>.delayed(
          SplashConfig.minimumDisplayDuration +
              const Duration(milliseconds: 200),
        );

        // Assert
        expect(states.first, isA<SplashLoading>());
        expect(states.last, isA<SplashSuccess>());
      },
    );

    test('should transition to SplashError on sync failure', () async {
      // Arrange
      const failure = ConnectionFailure(message: 'No connection');
      when(
        () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) => streamController.stream);
      when(
        () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) async {
        streamController.add(const SyncStateError<List<Product>>(failure));
        return const SyncStateError<List<Product>>(failure);
      });

      final container = createContainer();
      addTearDown(container.dispose);

      final states = <SplashState>[];
      container.listen(
        splashViewModelProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // Act - Wait for minimum display time
      await Future<void>.delayed(
        SplashConfig.minimumDisplayDuration + const Duration(milliseconds: 200),
      );

      // Assert
      expect(states.last, isA<SplashError>());
      expect((states.last as SplashError).failure, failure);
    });

    test('should not transition before minimum display time', () async {
      // Arrange
      when(
        () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) => streamController.stream);
      when(
        () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) async {
        streamController.add(const SyncStateSuccess<List<Product>>([]));
        return const SyncStateSuccess<List<Product>>([]);
      });

      final container = createContainer();
      addTearDown(container.dispose);

      final states = <SplashState>[];
      container.listen(
        splashViewModelProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // Act - Wait less than minimum display time
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Assert - Should still be initial state
      expect(states.length, 1);
      expect(states.first, isA<SplashLoading>());
    });

    test(
      'should set isRetrying true when retry is called from error state',
      () async {
        // Arrange
        const failure = ConnectionFailure(message: 'No connection');
        when(
          () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
        ).thenAnswer((_) => streamController.stream);
        when(
          () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
        ).thenAnswer((_) async {
          // First call fails, subsequent calls also fail (for retry test)
          streamController.add(const SyncStateError<List<Product>>(failure));
          return const SyncStateError<List<Product>>(failure);
        });

        final container = createContainer();
        addTearDown(container.dispose);

        final states = <SplashState>[];
        container.listen(
          splashViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // Wait for error state
        await Future<void>.delayed(
          SplashConfig.minimumDisplayDuration +
              const Duration(milliseconds: 200),
        );

        // Verify we're in error state
        expect(states.last, isA<SplashError>());
        expect((states.last as SplashError).isRetrying, isFalse);

        final notifier = container.read(splashViewModelProvider.notifier);

        // Act - Trigger retry
        notifier.retry();

        // Assert - Should be SplashError with isRetrying true immediately after retry
        final stateAfterRetry = container.read(splashViewModelProvider);
        expect(stateAfterRetry, isA<SplashError>());
        expect((stateAfterRetry as SplashError).isRetrying, isTrue);
      },
    );

    test('should ignore retry when not in error state', () async {
      // Arrange
      when(
        () => mockSyncStore.watch<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) => streamController.stream);
      when(
        () => mockSyncStore.sync<List<Product>>(SyncStoreKey.products),
      ).thenAnswer((_) async => const SyncStateLoading<List<Product>>());

      final container = createContainer();
      addTearDown(container.dispose);

      final notifier = container.read(splashViewModelProvider.notifier);

      // State is SplashLoading initially
      expect(container.read(splashViewModelProvider), isA<SplashLoading>());

      // Act - Try retry when not in error
      notifier.retry();

      // Assert - Should still be loading
      expect(container.read(splashViewModelProvider), isA<SplashLoading>());
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
}
