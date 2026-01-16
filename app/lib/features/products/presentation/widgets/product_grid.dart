import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../domain/entities/product.dart';
import '../../product_list_strings.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({
    required this.products,
    required this.onLoadMore,
    this.isLoadingMore = false,
    this.hasPaginationError = false,
    this.onRetryPagination,
    super.key,
  });

  final List<Product> products;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasPaginationError;
  final VoidCallback? onRetryPagination;

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom && !widget.isLoadingMore && !widget.hasPaginationError) {
      widget.onLoadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Product grid
        SliverPadding(
          padding: const EdgeInsets.all(DoriSpacing.xs),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: DoriSpacing.xs,
            crossAxisSpacing: DoriSpacing.xs,
            childCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              final size = index % 3 == 0
                  ? DoriProductCardSize.lg
                  : DoriProductCardSize.md;

              return DoriProductCard(
                imageUrl: product.imageUrl,
                primaryText: product.title,
                secondaryText: _formatPrice(product.price),
                size: size,
                imageBuilder: _buildCachedImage,
              );
            },
          ),
        ),

        // Footer (loading/error/end)
        SliverToBoxAdapter(child: _buildFooter()),
      ],
    );
  }

  Widget _buildFooter() {
    if (widget.hasPaginationError) {
      return _PaginationErrorFooter(onRetry: widget.onRetryPagination);
    }

    if (widget.isLoadingMore) {
      return const _LoadingFooter();
    }

    return const SizedBox(height: DoriSpacing.lg);
  }

  String _formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Widget _buildCachedImage(BuildContext context, String url) {
    final dori = context.dori;

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const DoriShimmer(),
      errorWidget: (context, url, error) => Container(
        color: dori.colors.surface.two,
        child: Center(
          child: DoriIcon(
            icon: DoriIconData.close,
            color: dori.colors.content.two,
            size: DoriIconSize.lg,
          ),
        ),
      ),
    );
  }
}

class _LoadingFooter extends StatelessWidget {
  const _LoadingFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(DoriSpacing.md),
      child: Center(child: DoriCircularProgress()),
    );
  }
}

class _PaginationErrorFooter extends StatelessWidget {
  const _PaginationErrorFooter({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DoriSpacing.md),
      child: Center(
        child: DoriButton(
          label: ProductListStrings.paginationRetry,
          variant: DoriButtonVariant.secondary,
          onPressed: onRetry,
        ),
      ),
    );
  }
}
