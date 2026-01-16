import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriMasonryGrid organism
@widgetbook.UseCase(
  name: 'Masonry Grid Showcase',
  type: DoriMasonryGridShowcase,
  path: '[Organisms]',
)
Widget buildDoriMasonryGridShowcase(BuildContext context) {
  return const DoriMasonryGridShowcase();
}

/// Widget showcase for DoriMasonryGrid - displays Pinterest-style grid
class DoriMasonryGridShowcase extends StatelessWidget {
  const DoriMasonryGridShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final isDark = context.dori.isDark;

    return Container(
      color: colors.surface.pure,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(DoriSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoriText(
                  label: 'DoriMasonryGrid',
                  variant: DoriTypographyVariant.title5,
                  color: colors.content.one,
                ),
                const SizedBox(height: DoriSpacing.xxxs),
                Container(
                  padding: const EdgeInsets.symmetric(
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
                const SizedBox(height: DoriSpacing.xxs),
                DoriText(
                  label:
                      'Pinterest-style staggered grid layout for displaying items with varying heights.',
                  variant: DoriTypographyVariant.description,
                  color: colors.content.two,
                ),
              ],
            ),
          ),

          // Grid Demo
          Expanded(child: _MasonryGridDemo(colors: colors)),
        ],
      ),
    );
  }
}

class _MasonryGridDemo extends StatelessWidget {
  const _MasonryGridDemo({required this.colors});

  final DoriColorScheme colors;

  @override
  Widget build(BuildContext context) {
    // Generate sample items with random heights
    final items = List.generate(
      20,
      (index) => _SampleItem(
        id: index,
        title: 'Item ${index + 1}',
        height: _randomHeight(index),
        color: _getColor(index, colors),
      ),
    );

    return DoriMasonryGrid<_SampleItem>(
      items: items,
      crossAxisCount: 2,
      itemBuilder: (context, item, index) => _SampleCard(item: item),
    );
  }

  double _randomHeight(int index) {
    // Deterministic "random" height based on index
    final heights = [150.0, 200.0, 180.0, 220.0, 160.0, 240.0, 190.0, 170.0];
    return heights[index % heights.length];
  }

  Color _getColor(int index, DoriColorScheme colors) {
    final colorList = [
      colors.brand.pure,
      colors.feedback.success,
      colors.feedback.info,
      colors.brand.one,
      colors.feedback.error,
    ];
    return colorList[index % colorList.length];
  }
}

class _SampleItem {
  const _SampleItem({
    required this.id,
    required this.title,
    required this.height,
    required this.color,
  });

  final int id;
  final String title;
  final double height;
  final Color color;
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.item});

  final _SampleItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;

    return Container(
      height: item.height,
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
        boxShadow: DoriShadows.of(context).sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored header
          Container(
            height: item.height * 0.6,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Center(
              child: DoriIcon(
                icon: DoriIconData.info,
                color: item.color,
                size: DoriIconSize.lg,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(DoriSpacing.xxs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoriText(
                  label: item.title,
                  variant: DoriTypographyVariant.descriptionBold,
                  color: colors.content.one,
                ),
                const SizedBox(height: DoriSpacing.xxxs),
                DoriText(
                  label: 'Height: ${item.height.toInt()}px',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
