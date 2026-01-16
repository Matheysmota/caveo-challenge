/// Infinite Scroll Pagination library re-export for paginated lists.
///
/// This library provides widgets and controllers for implementing infinite
/// scroll pagination with automatic state management (loading, error, empty).
///
/// Use this export instead of importing `package:infinite_scroll_pagination`
/// directly, as per [ADR 003](../../../../documents/adrs/003-abstracao-e-governanca-bibliotecas.md).
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/libraries/infinite_scroll_pagination_export/infinite_scroll_pagination_export.dart';
///
/// // Create a controller
/// final pagingController = PagingController<int, Product>(firstPageKey: 0);
///
/// // Use with PagedListView or PagedMasonryGridView
/// PagedListView<int, Product>(
///   pagingController: pagingController,
///   builderDelegate: PagedChildBuilderDelegate<Product>(
///     itemBuilder: (context, item, index) => ProductCard(product: item),
///   ),
/// );
/// ```
///
/// See [ADR 012](../../../../documents/adrs/012-infinite-scroll-pagination.md)
/// for architectural decision and usage guidelines.
library;

export 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart'
    show
        // Core Controller
        PagingController,
        PagingState,
        PagingStatus,
        // ListView Widgets
        PagedListView,
        PagedSliverList,
        // GridView Widgets
        PagedGridView,
        PagedSliverGrid,
        // Masonry Support
        PagedMasonryGridView,
        PagedSliverMasonryGrid,
        // Builder Delegates
        PagedChildBuilderDelegate;
