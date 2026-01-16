import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';

import 'package:caveo_challenge/app/di/app_providers.dart';
import 'package:caveo_challenge/features/products/domain/entities/product.dart';
import 'package:caveo_challenge/features/products/domain/repositories/product_repository.dart';
import 'package:caveo_challenge/features/products/presentation/product_list_state.dart';
import 'package:caveo_challenge/features/products/presentation/product_list_view_model.dart';
import 'package:caveo_challenge/main.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockSyncStore extends Mock implements SyncStore {}

void main() {
  late ProviderContainer container;
  late MockProductRepository mockRepository;
  late MockSyncStore mockSyncStore;
  late StreamController<ConnectivityStatus> connectivityController;

  final testProducts = List.generate(
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

  final lessProducts = testProducts.sublist(0, 10);

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(mockRepository),
        syncStoreProvider.overrideWithValue(mockSyncStore),
        connectivityStreamProvider.overrideWith(
          (ref) => connectivityController.stream,
        ),
      ],
    );
  }

  setUp(() {
    mockRepository = MockProductRepository();
    mockSyncStore = MockSyncStore();
    connectivityController = StreamController<ConnectivityStatus>.broadcast();
  });

  tearDown(() {
    connectivityController.close();
    container.dispose();
  });

  /// Helper to wait for microtasks to complete (state transitions)
  Future<void> pumpEventQueue() async {
    await Future.delayed(Duration.zero);
  }

  group('ProductListViewModel - Initial Load', () {
    test(
      'should show ProductListLoaded when SyncStore has successful data',
      () async {
        // Arrange
        when(
          () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
        ).thenReturn(SyncStateSuccess(testProducts));

        container = createContainer();

        // Act - Reading triggers build() + _loadInitialData()
        container.read(productListViewModelProvider);
        await pumpEventQueue();

        // Assert
        final state = container.read(productListViewModelProvider);
        expect(state, isA<ProductListLoaded>());
        final loaded = state as ProductListLoaded;
        expect(loaded.products, testProducts);
        expect(loaded.hasMorePages, true); // 20 items = pageSize
      },
    );

    test('should set hasMorePages to false when products < pageSize', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(lessProducts));

      container = createContainer();

      // Act
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.hasMorePages, false); // 10 items < 20 pageSize
    });

    test(
      'should show ProductListError when SyncStore has error without cache',
      () async {
        // Arrange
        const failure = ConnectionFailure();
        when(
          () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
        ).thenReturn(const SyncStateError(failure));

        container = createContainer();

        // Act
        container.read(productListViewModelProvider);
        await pumpEventQueue();

        // Assert
        final state = container.read(productListViewModelProvider);
        expect(state, isA<ProductListError>());
        final error = state as ProductListError;
        expect(error.message, contains('internet'));
      },
    );

    test(
      'should show ProductListLoaded with stale flag when SyncStore has error with cache',
      () async {
        // Arrange
        const failure = ConnectionFailure();
        when(
          () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
        ).thenReturn(SyncStateError(failure, previousData: testProducts));

        container = createContainer();

        // Act
        container.read(productListViewModelProvider);
        await pumpEventQueue();

        // Assert
        final state = container.read(productListViewModelProvider);
        expect(state, isA<ProductListLoaded>());
        final loaded = state as ProductListLoaded;
        expect(loaded.products, testProducts);
        expect(loaded.isDataStale, true);
      },
    );

    test('should show ProductListError when SyncStore is idle', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(const SyncStateIdle());

      container = createContainer();

      // Act
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListError>());
      final error = state as ProductListError;
      expect(error.message, contains('not yet loaded'));
    });

    test('should show ProductListError when SyncStore is loading', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(const SyncStateLoading());

      container = createContainer();

      // Act
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListError>());
    });
  });

  group('ProductListViewModel - Pagination', () {
    test('should append products on loadNextPage success', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      final page2Products = List.generate(
        20,
        (i) => Product(
          id: 100 + i,
          title: 'Page 2 Product ${i + 1}',
          price: 25.0,
          description: 'Page 2',
          category: 'Page 2',
          imageUrl: 'https://example.com/page2_$i.png',
          rating: const ProductRating(rate: 3.5, count: 20),
        ),
      );

      when(
        () => mockRepository.getProducts(page: 2),
      ).thenAnswer((_) async => Success(page2Products));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      await viewModel.loadNextPage();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.products.length, 40); // 20 + 20
      expect(loaded.products.first, testProducts.first);
      expect(loaded.products.last, page2Products.last);
      expect(loaded.hasMorePages, true);
    });

    test(
      'should set hasMorePages to false when page returns < pageSize',
      () async {
        // Arrange
        when(
          () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
        ).thenReturn(SyncStateSuccess(testProducts));

        final lastPageProducts = List.generate(
          5,
          (i) => Product(
            id: 500 + i,
            title: 'Last Page Product ${i + 1}',
            price: 10.0,
            description: 'Last',
            category: 'Last',
            imageUrl: 'https://example.com/last$i.png',
            rating: const ProductRating(rate: 5.0, count: 5),
          ),
        );

        when(
          () => mockRepository.getProducts(page: 2),
        ).thenAnswer((_) async => Success(lastPageProducts));

        container = createContainer();
        container.read(productListViewModelProvider);
        await pumpEventQueue();

        final viewModel = container.read(productListViewModelProvider.notifier);

        // Act
        await viewModel.loadNextPage();

        // Assert
        final state = container.read(productListViewModelProvider);
        expect(state, isA<ProductListLoaded>());
        final loaded = state as ProductListLoaded;
        expect(loaded.products.length, 25); // 20 + 5
        expect(loaded.hasMorePages, false);
      },
    );

    test('should set paginationError on loadNextPage failure', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      const failure = ConnectionFailure(message: 'Pagination failed');
      when(
        () => mockRepository.getProducts(page: 2),
      ).thenAnswer((_) async => const Failure(failure));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      await viewModel.loadNextPage();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.paginationError, true);
      expect(loaded.products, testProducts); // Original products preserved
    });

    test('should not loadNextPage when hasMorePages is false', () async {
      // Arrange - Start with less products (hasMorePages = false)
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(lessProducts));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      await viewModel.loadNextPage();

      // Assert
      verifyNever(() => mockRepository.getProducts(page: any(named: 'page')));
    });

    test('should not loadNextPage when paginationError is true', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      const failure = ConnectionFailure(message: 'Error');
      when(
        () => mockRepository.getProducts(page: 2),
      ).thenAnswer((_) async => const Failure(failure));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);
      await viewModel.loadNextPage(); // Causes error

      // Act - Try to load again
      await viewModel.loadNextPage();

      // Assert - Should only have called once
      verify(() => mockRepository.getProducts(page: 2)).called(1);
    });

    test('should retry pagination after retryPagination is called', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      const failure = ConnectionFailure(message: 'Error');
      when(
        () => mockRepository.getProducts(page: 2),
      ).thenAnswer((_) async => const Failure(failure));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // First load fails
      viewModel.loadNextPageCommand();
      await pumpEventQueue();
      await Future.delayed(const Duration(milliseconds: 50));

      final stateWithError = container.read(productListViewModelProvider);
      expect(stateWithError, isA<ProductListLoaded>());
      expect((stateWithError as ProductListLoaded).paginationError, true);

      // Setup success for retry
      final page2Products = [testProducts.first];
      when(
        () => mockRepository.getProducts(page: 2),
      ).thenAnswer((_) async => Success(page2Products));

      // Act - Retry pagination (clears error flag and calls command)
      viewModel.retryPagination();
      await pumpEventQueue();
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert
      final stateAfterRetry = container.read(productListViewModelProvider);
      expect(stateAfterRetry, isA<ProductListLoaded>());
      final loadedAfterRetry = stateAfterRetry as ProductListLoaded;
      expect(loadedAfterRetry.paginationError, false);
      expect(loadedAfterRetry.products.length, 21);
    });
  });

  group('ProductListViewModel - Stale Data Banner', () {
    test('should dismiss stale data banner', () async {
      // Arrange - Start with stale data
      const failure = ConnectionFailure(message: 'Error');
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateError(failure, previousData: testProducts));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final stateBeforeDismiss = container.read(productListViewModelProvider);
      expect(stateBeforeDismiss, isA<ProductListLoaded>());
      final loadedBeforeDismiss = stateBeforeDismiss as ProductListLoaded;
      expect(loadedBeforeDismiss.isDataStale, true);
      expect(loadedBeforeDismiss.isStaleDataBannerDismissed, false);

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      viewModel.dismissStaleDataBanner();

      // Assert
      final stateAfterDismiss = container.read(productListViewModelProvider);
      expect(stateAfterDismiss, isA<ProductListLoaded>());
      final loadedAfterDismiss = stateAfterDismiss as ProductListLoaded;
      expect(loadedAfterDismiss.isDataStale, true); // Still stale
      expect(
        loadedAfterDismiss.isStaleDataBannerDismissed,
        true,
      ); // But banner dismissed
    });
  });

  group('ProductListViewModel - Search', () {
    test('should filter products by title', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      viewModel.search('Product 1');

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      // Products 1, 10, 11, 12... should match
      expect(loaded.products.every((p) => p.title.contains('Product 1')), true);
      expect(loaded.searchQuery, 'product 1');
    });

    test('should show all products when search is cleared', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act - Search then clear
      viewModel.search('Product 1');
      viewModel.clearSearch();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.products.length, testProducts.length);
      expect(loaded.searchQuery, '');
    });

    test('should filter products by category', () async {
      // Arrange
      final productsWithCategories = [
        Product(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          description: 'Desc 1',
          category: 'Electronics',
          imageUrl: 'https://example.com/1.png',
          rating: const ProductRating(rate: 4.0, count: 10),
        ),
        Product(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: 'Desc 2',
          category: 'Clothing',
          imageUrl: 'https://example.com/2.png',
          rating: const ProductRating(rate: 4.0, count: 10),
        ),
        Product(
          id: 3,
          title: 'Product 3',
          price: 30.0,
          description: 'Desc 3',
          category: 'Electronics',
          imageUrl: 'https://example.com/3.png',
          rating: const ProductRating(rate: 4.0, count: 10),
        ),
      ];

      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(productsWithCategories));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act
      viewModel.search('Electronics');

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.products.length, 2);
      expect(loaded.products.every((p) => p.category == 'Electronics'), true);
    });
  });

  group('ProductListViewModel - Edge Cases', () {
    test('should handle empty product list', () async {
      // Arrange
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(const SyncStateSuccess([]));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      // Assert
      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListLoaded>());
      final loaded = state as ProductListLoaded;
      expect(loaded.products, isEmpty);
      expect(loaded.hasMorePages, false);
    });

    test('should not crash when loadNextPage called in Error state', () async {
      // Arrange
      const failure = ConnectionFailure(message: 'Error');
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(const SyncStateError(failure));

      container = createContainer();
      container.read(productListViewModelProvider);
      await pumpEventQueue();

      final state = container.read(productListViewModelProvider);
      expect(state, isA<ProductListError>());

      final viewModel = container.read(productListViewModelProvider.notifier);

      // Act & Assert - Should not throw
      await viewModel.loadNextPage();
    });
  });
}
