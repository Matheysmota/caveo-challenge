import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriProductCard organism
@widgetbook.UseCase(
  name: 'Product Card Showcase',
  type: DoriProductCardShowcase,
  path: '[Organisms]',
)
Widget buildDoriProductCardShowcase(BuildContext context) {
  return const DoriProductCardShowcase();
}

/// Widget showcase for DoriProductCard - displays all variants and configurations
class DoriProductCardShowcase extends StatelessWidget {
  const DoriProductCardShowcase({super.key});

  // Sample product images (placeholder URLs)
  static const _sampleImages = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
    'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final isDark = context.dori.isDark;

    return Container(
      color: colors.surface.pure,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DoriSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DoriText(
              label: 'DoriProductCard',
              variant: DoriTypographyVariant.title5,
              color: colors.content.one,
            ),
            SizedBox(height: DoriSpacing.xxxs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DoriSpacing.xxs,
                vertical: DoriSpacing.xxxs,
              ),
              decoration: BoxDecoration(
                color: isDark ? colors.brand.two : colors.brand.pure,
                borderRadius: DoriRadius.sm,
              ),
              child: DoriText(
                label: isDark ? 'Dark Mode' : 'Light Mode',
                variant: DoriTypographyVariant.captionBold,
                color: isDark ? colors.brand.pure : Colors.white,
              ),
            ),
            SizedBox(height: DoriSpacing.md),

            // Sizes Section
            _buildSectionHeader('Sizes', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildSizesSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Shimmer Loading Section
            _buildSectionHeader('Shimmer Loading State', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildShimmerSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Content Variants Section
            _buildSectionHeader('Content Variants', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildContentVariantsSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Grid Layout Section
            _buildSectionHeader('Grid Layout Example', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildGridLayoutSection(colors),

            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, DoriColorScheme colors) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: colors.brand.pure,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: DoriSpacing.xxs),
        DoriText(
          label: title,
          variant: DoriTypographyVariant.descriptionBold,
          color: colors.content.one,
        ),
      ],
    );
  }

  Widget _buildSizesSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small
          Expanded(
            child: Column(
              children: [
                DoriText(
                  label: 'sm (3:4)',
                  variant: DoriTypographyVariant.captionBold,
                  color: colors.content.two,
                ),
                SizedBox(height: DoriSpacing.xxs),
                DoriProductCard(
                  imageUrl: _sampleImages[0],
                  primaryText: 'Wireless Headphones',
                  secondaryText: 'R\$ 299',
                  badgeText: 'Audio',
                  size: DoriProductCardSize.sm,
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(width: DoriSpacing.xs),
          // Medium
          Expanded(
            child: Column(
              children: [
                DoriText(
                  label: 'md (4:5)',
                  variant: DoriTypographyVariant.captionBold,
                  color: colors.content.two,
                ),
                SizedBox(height: DoriSpacing.xxs),
                DoriProductCard(
                  imageUrl: _sampleImages[1],
                  primaryText: 'Premium Watch',
                  secondaryText: 'R\$ 1.299',
                  badgeText: 'Accessories',
                  size: DoriProductCardSize.md,
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(width: DoriSpacing.xs),
          // Large
          Expanded(
            child: Column(
              children: [
                DoriText(
                  label: 'lg (1:1)',
                  variant: DoriTypographyVariant.captionBold,
                  color: colors.content.two,
                ),
                SizedBox(height: DoriSpacing.xxs),
                DoriProductCard(
                  imageUrl: _sampleImages[2],
                  primaryText: 'Sunglasses Pro',
                  secondaryText: 'R\$ 450',
                  badgeText: 'Fashion',
                  size: DoriProductCardSize.lg,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Shimmer animation while image loads',
            variant: DoriTypographyVariant.captionBold,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card with shimmer forced via imageBuilder
              Expanded(
                child: Column(
                  children: [
                    DoriText(
                      label: 'Card Loading',
                      variant: DoriTypographyVariant.caption,
                      color: colors.content.two,
                    ),
                    SizedBox(height: DoriSpacing.xxs),
                    DoriProductCard(
                      imageUrl: 'https://example.com/loading',
                      primaryText: 'Product Loading',
                      secondaryText: 'Price loading...',
                      badgeText: 'New',
                      size: DoriProductCardSize.md,
                      // Force shimmer state with custom builder
                      imageBuilder: (context, url) => const _ShimmerDemo(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: DoriSpacing.xs),
              // Standalone shimmer demo
              Expanded(
                child: Column(
                  children: [
                    DoriText(
                      label: 'Shimmer Only',
                      variant: DoriTypographyVariant.caption,
                      color: colors.content.two,
                    ),
                    SizedBox(height: DoriSpacing.xxs),
                    AspectRatio(
                      aspectRatio: 4 / 5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(24),
                        ),
                        child: const _ShimmerDemo(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentVariantsSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full content
          _buildVariantRow(
            'Complete (badge + secondary)',
            colors,
            DoriProductCard(
              imageUrl: _sampleImages[0],
              primaryText: 'Wireless Headphones Pro Max',
              secondaryText: 'R\$ 1.999',
              badgeText: 'Best Seller',
              size: DoriProductCardSize.md,
              onTap: () {},
            ),
          ),
          SizedBox(height: DoriSpacing.sm),

          // Without badge
          _buildVariantRow(
            'Without badge',
            colors,
            DoriProductCard(
              imageUrl: _sampleImages[1],
              primaryText: 'Premium Leather Watch',
              secondaryText: 'R\$ 2.499',
              size: DoriProductCardSize.md,
              onTap: () {},
            ),
          ),
          SizedBox(height: DoriSpacing.sm),

          // Without secondary text
          _buildVariantRow(
            'Without secondary text',
            colors,
            DoriProductCard(
              imageUrl: _sampleImages[2],
              primaryText: 'Designer Sunglasses',
              badgeText: 'New',
              size: DoriProductCardSize.md,
              onTap: () {},
            ),
          ),
          SizedBox(height: DoriSpacing.sm),

          // Minimal
          _buildVariantRow(
            'Minimal (only primary text)',
            colors,
            DoriProductCard(
              imageUrl: _sampleImages[3],
              primaryText: 'Smart Watch Series 5',
              size: DoriProductCardSize.md,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantRow(String label, DoriColorScheme colors, Widget card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoriText(
          label: label,
          variant: DoriTypographyVariant.captionBold,
          color: colors.content.two,
        ),
        SizedBox(height: DoriSpacing.xxs),
        SizedBox(width: 200, child: card),
      ],
    );
  }

  Widget _buildGridLayoutSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Pinterest-style 2-column grid',
            variant: DoriTypographyVariant.captionBold,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: [
                    DoriProductCard(
                      imageUrl: _sampleImages[0],
                      primaryText: 'Noise Cancelling Headphones',
                      secondaryText: 'R\$ 599',
                      badgeText: 'Audio',
                      size: DoriProductCardSize.sm,
                      onTap: () {},
                    ),
                    SizedBox(height: DoriSpacing.xs),
                    DoriProductCard(
                      imageUrl: _sampleImages[2],
                      primaryText: 'Aviator Sunglasses',
                      secondaryText: 'R\$ 350',
                      size: DoriProductCardSize.lg,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(width: DoriSpacing.xs),
              // Right column
              Expanded(
                child: Column(
                  children: [
                    DoriProductCard(
                      imageUrl: _sampleImages[1],
                      primaryText: 'Minimalist Chronograph',
                      secondaryText: 'R\$ 1.899',
                      badgeText: 'Premium',
                      size: DoriProductCardSize.md,
                      onTap: () {},
                    ),
                    SizedBox(height: DoriSpacing.xs),
                    DoriProductCard(
                      imageUrl: _sampleImages[3],
                      primaryText: 'Fitness Tracker Pro',
                      secondaryText: 'R\$ 799',
                      badgeText: 'Tech',
                      size: DoriProductCardSize.sm,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Demo widget that shows shimmer animation indefinitely.
///
/// Used in the Widgetbook to demonstrate the loading state.
class _ShimmerDemo extends StatefulWidget {
  const _ShimmerDemo();

  @override
  State<_ShimmerDemo> createState() => _ShimmerDemoState();
}

class _ShimmerDemoState extends State<_ShimmerDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                dori.colors.surface.two,
                dori.colors.surface.three,
                dori.colors.surface.two,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
