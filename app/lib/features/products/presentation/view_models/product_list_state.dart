import 'package:shared/libraries/equatable_export/equatable_export.dart';

import '../../domain/entities/product.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();
}

final class ProductListLoading extends ProductListState {
  const ProductListLoading();

  @override
  List<Object?> get props => [];
}

final class ProductListLoaded extends ProductListState {
  const ProductListLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.isDataStale = false,
    this.isStaleDataBannerDismissed = false,
    this.paginationError = false,
    this.hasMorePages = true,
    this.searchQuery = '',
    this.isOffline = false,
  });

  final List<Product> products;
  final bool isLoadingMore;
  final bool isDataStale;
  final bool isStaleDataBannerDismissed;
  final String searchQuery;
  final bool paginationError;
  final bool hasMorePages;
  final bool isOffline;

  ProductListLoaded copyWith({
    List<Product>? products,
    bool? isLoadingMore,
    bool? isDataStale,
    bool? isStaleDataBannerDismissed,
    bool? paginationError,
    bool? hasMorePages,
    String? searchQuery,
    bool? isOffline,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isDataStale: isDataStale ?? this.isDataStale,
      isStaleDataBannerDismissed:
          isStaleDataBannerDismissed ?? this.isStaleDataBannerDismissed,
      paginationError: paginationError ?? this.paginationError,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      searchQuery: searchQuery ?? this.searchQuery,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoadingMore,
    isDataStale,
    isStaleDataBannerDismissed,
    paginationError,
    hasMorePages,
    searchQuery,
    isOffline,
  ];
}

final class ProductListError extends ProductListState {
  const ProductListError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
