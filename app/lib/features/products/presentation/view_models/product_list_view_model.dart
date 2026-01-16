/// Product list state management using Command Pattern (ADR 006).
library;

import 'package:shared/shared.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../main.dart';
import '../../domain/entities/product.dart';
import '../../domain/product_config.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_list_state.dart';

final productListViewModelProvider =
    NotifierProvider<ProductListViewModel, ProductListState>(
      ProductListViewModel.new,
    );

/// Manages product list state with Commands for pagination and search.
class ProductListViewModel extends Notifier<ProductListState> {
  ProductRepository? _repository;
  int _currentPage = 1;
  List<Product> _allProducts = [];
  String _searchQuery = '';
  bool _isOffline = false;

  late final Command<void, void> loadNextPageCommand;
  late final Command<String, List<Product>> searchCommand;

  @override
  ProductListState build() {
    _repository = ref.watch(productRepositoryProvider);
    _initializeCommands();
    _observeConnectivity();
    Future.microtask(_loadInitialData);
    return const ProductListLoading();
  }

  void _initializeCommands() {
    loadNextPageCommand = Command.createAsyncNoParamNoResult(
      _executeLoadNextPage,
    );

    searchCommand = Command.createSync<String, List<Product>>(
      _executeSearch,
      [],
    );
  }

  void _observeConnectivity() {
    ref.listen<AsyncValue<ConnectivityStatus>>(connectivityStreamProvider, (
      previous,
      next,
    ) {
      final isOffline = next.when(
        data: (status) => status == ConnectivityStatus.offline,
        loading: () => false,
        error: (e, st) => false,
      );

      if (_isOffline != isOffline) {
        _isOffline = isOffline;
        _updateOfflineStatus(isOffline);
      }
    });
  }

  void _updateOfflineStatus(bool isOffline) {
    final currentState = state;
    if (currentState is ProductListLoaded) {
      state = currentState.copyWith(isOffline: isOffline);
    }
  }

  void _loadInitialData() {
    final syncStore = ref.read(syncStoreProvider);
    final productState = syncStore.get<List<Product>>(SyncStoreKey.products);

    switch (productState) {
      case SyncStateSuccess(:final data):
        _allProducts = data;
        state = ProductListLoaded(
          products: data,
          hasMorePages: data.length >= ProductConfig.pageSize,
        );
        return;

      case SyncStateError(:final failure, :final previousData):
        if (previousData != null) {
          _allProducts = previousData;
          state = ProductListLoaded(
            products: previousData,
            isDataStale: true,
            hasMorePages: previousData.length >= ProductConfig.pageSize,
          );
          return;
        }
        state = ProductListError(message: failure.message);
        return;

      case SyncStateIdle():
      case SyncStateLoading():
        state = const ProductListError(
          message: 'Products not yet loaded. Please restart the app.',
        );
        return;
    }
  }

  Future<void> _executeLoadNextPage() async {
    final currentState = state;
    if (currentState is! ProductListLoaded) return;

    final repository = _repository;
    if (repository == null) return;

    state = currentState.copyWith(isLoadingMore: true);

    final nextPage = _currentPage + 1;
    final result = await repository.getProducts(page: nextPage);

    result.fold(
      (products) {
        _currentPage = nextPage;
        final updatedProducts = [...currentState.products, ...products];
        _allProducts = updatedProducts;

        state = ProductListLoaded(
          products: _filterProducts(updatedProducts, _searchQuery),
          hasMorePages: products.length >= ProductConfig.pageSize,
        );
      },
      (failure) {
        state = currentState.copyWith(
          isLoadingMore: false,
          paginationError: true,
        );
      },
    );
  }

  List<Product> _executeSearch(String query) {
    _searchQuery = query.toLowerCase().trim();

    final currentState = state;
    if (currentState is! ProductListLoaded) return [];

    final filteredProducts = _filterProducts(_allProducts, _searchQuery);

    state = currentState.copyWith(
      products: filteredProducts,
      searchQuery: _searchQuery,
    );

    return filteredProducts;
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;

    return products.where((product) {
      final titleMatch = product.title.toLowerCase().contains(query);
      final categoryMatch = product.category.toLowerCase().contains(query);
      return titleMatch || categoryMatch;
    }).toList();
  }

  Future<void> retryPagination() async {
    final currentState = state;
    if (currentState is! ProductListLoaded) return;

    state = currentState.copyWith(paginationError: false);
    await loadNextPageCommand.executeWithFuture();
  }

  void dismissStaleDataBanner() {
    final currentState = state;
    if (currentState is! ProductListLoaded) return;

    state = currentState.copyWith(isStaleDataBannerDismissed: true);
  }

  void clearSearch() {
    searchCommand.execute('');
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! ProductListLoaded) return;
    if (!currentState.hasMorePages) return;
    if (currentState.paginationError) return;
    if (currentState.isLoadingMore) return;

    await loadNextPageCommand.executeWithFuture();
  }

  void search(String query) => searchCommand.execute(query);
}
