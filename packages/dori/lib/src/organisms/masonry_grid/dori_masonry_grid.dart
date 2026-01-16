import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../tokens/dori_spacing.dart';

/// A masonry grid layout component for displaying items in a Pinterest-like layout.
///
/// This organism encapsulates [flutter_staggered_grid_view] and provides a
/// simplified API for creating staggered/masonry grids. Items can have
/// different heights, creating a visually dynamic layout.
///
/// The grid is designed to work with external pagination controllers
/// (like `PagingController` from `infinite_scroll_pagination`), where the
/// parent widget handles data fetching and provides the items list.
///
/// ## Example
///
/// ```dart
/// // Basic usage with fixed items
/// DoriMasonryGrid<Product>(
///   items: products,
///   itemBuilder: (context, item, index) => DoriProductCard(
///     imageUrl: item.imageUrl,
///     primaryText: item.title,
///     secondaryText: item.price,
///   ),
/// )
///
/// // With custom column count
/// DoriMasonryGrid<Product>(
///   items: products,
///   crossAxisCount: 3,
///   itemBuilder: (context, item, index) => ProductCard(product: item),
/// )
///
/// // As sliver (for use in CustomScrollView)
/// CustomScrollView(
///   slivers: [
///     DoriMasonryGrid<Product>.sliver(
///       items: products,
///       itemBuilder: (context, item, index) => ProductCard(product: item),
///     ),
///   ],
/// )
/// ```
///
/// ## Integration with Pagination
///
/// This widget is intentionally simple and does NOT handle pagination internally.
/// Use it alongside `infinite_scroll_pagination` by providing items from the
/// paging controller:
///
/// ```dart
/// // In parent widget
/// PagedMasonryGridView<int, Product>(
///   pagingController: _pagingController,
///   builderDelegate: PagedChildBuilderDelegate<Product>(
///     itemBuilder: (context, item, index) => DoriProductCard(...),
///   ),
///   gridDelegateBuilder: (childCount) =>
///     SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
/// );
/// ```
///
/// ## Accessibility
///
/// The grid respects the semantic tree of its children. Ensure each item
/// in the grid has proper semantic labels.
///
/// {@category Organisms}
class DoriMasonryGrid<T> extends StatelessWidget {
  /// Creates a masonry grid with the specified items.
  const DoriMasonryGrid({
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  }) : _isSliver = false;

  /// Creates a masonry grid as a sliver for use in [CustomScrollView].
  const DoriMasonryGrid.sliver({
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding,
    super.key,
  }) : shrinkWrap = false,
       physics = null,
       _isSliver = true;

  /// List of items to display in the grid.
  final List<T> items;

  /// Builder function for creating item widgets.
  ///
  /// Receives the build context, the item, and its index.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Number of columns in the grid.
  ///
  /// Defaults to 2 for a typical Pinterest-like layout.
  final int crossAxisCount;

  /// Spacing between items along the main axis (vertical).
  ///
  /// Defaults to [DoriSpacing.xs] (16dp).
  final double? mainAxisSpacing;

  /// Spacing between items along the cross axis (horizontal).
  ///
  /// Defaults to [DoriSpacing.xs] (16dp).
  final double? crossAxisSpacing;

  /// Padding around the grid.
  ///
  /// Defaults to [DoriSpacing.xs] (16dp) on all sides.
  final EdgeInsets? padding;

  /// Whether to shrink wrap the grid.
  ///
  /// Only applicable for non-sliver variant.
  final bool shrinkWrap;

  /// Scroll physics for the grid.
  ///
  /// Only applicable for non-sliver variant.
  final ScrollPhysics? physics;

  /// Internal flag to track if this is a sliver variant.
  final bool _isSliver;

  double get _mainAxisSpacing => mainAxisSpacing ?? DoriSpacing.xs;
  double get _crossAxisSpacing => crossAxisSpacing ?? DoriSpacing.xs;
  EdgeInsets get _padding => padding ?? const EdgeInsets.all(DoriSpacing.xs);

  @override
  Widget build(BuildContext context) {
    if (_isSliver) {
      return _buildSliver();
    }
    return _buildScrollable();
  }

  Widget _buildScrollable() {
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: _mainAxisSpacing,
      crossAxisSpacing: _crossAxisSpacing,
      padding: _padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index),
    );
  }

  Widget _buildSliver() {
    return SliverPadding(
      padding: _padding,
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: _mainAxisSpacing,
        crossAxisSpacing: _crossAxisSpacing,
        childCount: items.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, items[index], index),
      ),
    );
  }
}

/// Delegate for building masonry grid with staggered grid view.
///
/// Use this with [PagedSliverMasonryGrid] from `infinite_scroll_pagination`
/// when building paginated grids.
///
/// ## Example
///
/// ```dart
/// PagedSliverMasonryGrid<int, Product>(
///   pagingController: _pagingController,
///   builderDelegate: PagedChildBuilderDelegate<Product>(...),
///   gridDelegateBuilder: DoriMasonryGridDelegate.simple(crossAxisCount: 2),
/// );
/// ```
///
/// {@category Organisms}
class DoriMasonryGridDelegate {
  const DoriMasonryGridDelegate._();

  /// Creates a simple fixed cross-axis count delegate.
  ///
  /// Use this factory to create a delegate compatible with
  /// `PagedMasonryGridView.gridDelegateBuilder`.
  static SliverSimpleGridDelegate Function(int childCount) simple({
    int crossAxisCount = 2,
  }) {
    return (_) => SliverSimpleGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
    );
  }
}
