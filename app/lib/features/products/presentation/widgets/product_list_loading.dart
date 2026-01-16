import 'package:dori/dori.dart';
import 'package:flutter/material.dart';

/// Loading placeholder for the product list.
///
/// Shows shimmer placeholders while products are loading.
class ProductListLoadingWidget extends StatelessWidget {
  const ProductListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DoriSpacing.xs),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: DoriSpacing.xs,
          crossAxisSpacing: DoriSpacing.xs,
          childAspectRatio: 0.7,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return Container(
      decoration: BoxDecoration(
        color: dori.colors.surface.two,
        borderRadius: DoriRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: const DoriShimmer(),
            ),
          ),

          // Content placeholder
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(DoriSpacing.xxs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SizedBox(
                    height: 12,
                    width: double.infinity,
                    child: DoriShimmer(),
                  ),
                  SizedBox(height: 4),
                  SizedBox(height: 10, width: 80, child: DoriShimmer()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
