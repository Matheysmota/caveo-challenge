import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../../app/app_strings.dart';
import 'view_models/product_list_state.dart';
import 'view_models/product_list_view_model.dart';
import 'widgets/product_grid.dart';
import 'widgets/product_list_app_bar.dart';
import 'widgets/product_list_loading.dart';
import 'widgets/status_banners.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListViewModelProvider);
    final viewModel = ref.read(productListViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: context.dori.colors.surface.one,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Search
            ProductListAppBar(
              onSearch: (query) => viewModel.searchCommand.execute(query),
            ),

            // Status Banners (offline + stale data)
            StatusBanners(
              isOffline: _isOffline(state),
              isDataStale: _isDataStale(state),
              onDismissStale: viewModel.dismissStaleDataBanner,
            ),

            // Main Content
            Expanded(child: _buildContent(state, viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ProductListState state, ProductListViewModel viewModel) {
    return switch (state) {
      ProductListLoading() => const ProductListLoadingWidget(),
      ProductListError(:final message) => _buildErrorState(message),
      ProductListLoaded(:final products) => _buildProductList(
        state,
        viewModel,
        products,
      ),
    };
  }

  Widget _buildProductList(
    ProductListLoaded state,
    ProductListViewModel viewModel,
    List products,
  ) {
    return ProductGrid(
      products: state.products,
      onLoadMore: () => viewModel.loadNextPageCommand(),
      isLoadingMore: state.isLoadingMore,
      hasPaginationError: state.paginationError,
      onRetryPagination: viewModel.retryPagination,
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DoriSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DoriIcon(
              icon: DoriIconData.error,
              size: DoriIconSize.lg,
              color: context.dori.colors.feedback.error,
            ),
            const SizedBox(height: DoriSpacing.sm),
            DoriText(
              label: message,
              variant: DoriTypographyVariant.description,
              textAlign: TextAlign.center,
              color: context.dori.colors.content.two,
            ),
            const SizedBox(height: DoriSpacing.md),
            DoriButton(
              label: AppStrings.tryAgain,
              onPressed: () => ref.invalidate(productListViewModelProvider),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOffline(ProductListState state) {
    if (state is! ProductListLoaded) return false;
    return state.isOffline;
  }

  bool _isDataStale(ProductListState state) {
    if (state is! ProductListLoaded) return false;
    return state.isDataStale && !state.isStaleDataBannerDismissed;
  }
}
