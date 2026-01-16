/// Re-exports of [flutter_staggered_grid_view] types for use within the app.
///
/// This file provides controlled access to the underlying staggered grid view
/// library, ensuring that the app layer uses these types through Dori
/// (per ADR 003 - Dependency Governance).
///
/// ## Exported Types
///
/// - [SliverMasonryGrid] — For building masonry grids as slivers
/// - [MasonryGridView] — For standalone scrollable masonry grids
/// - [SliverSimpleGridDelegate] — Base delegate for grid configuration
/// - [SliverSimpleGridDelegateWithFixedCrossAxisCount] — Fixed column count
///
/// ## Usage
///
/// ```dart
/// import 'package:dori/dori.dart';
///
/// // Use SliverMasonryGrid in CustomScrollView
/// CustomScrollView(
///   slivers: [
///     SliverMasonryGrid.count(
///       crossAxisCount: 2,
///       itemBuilder: (context, index) => MyCard(),
///       childCount: items.length,
///     ),
///   ],
/// )
/// ```
///
/// {@category Organisms}
library;

export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    show
        SliverMasonryGrid,
        MasonryGridView,
        SliverSimpleGridDelegate,
        SliverSimpleGridDelegateWithFixedCrossAxisCount;
