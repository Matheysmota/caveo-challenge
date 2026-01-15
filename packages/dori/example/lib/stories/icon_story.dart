import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriIcon atom
@widgetbook.UseCase(
  name: 'Icon Gallery',
  type: DoriIconShowcase,
  path: '[Atoms]',
)
Widget buildDoriIconShowcase(BuildContext context) {
  return const DoriIconShowcase();
}

/// Widget showcase for DoriIcon - displays all icons and sizes
class DoriIconShowcase extends StatelessWidget {
  const DoriIconShowcase({super.key});

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
              label: 'DoriIcon',
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

            // Icon Gallery Section
            _buildSectionHeader('Icon Gallery', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildIconGallery(colors),

            SizedBox(height: DoriSpacing.md),

            // Size Comparison Section
            _buildSectionHeader('Size Comparison', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildSizeComparison(colors),

            SizedBox(height: DoriSpacing.md),

            // Color Variants Section
            _buildSectionHeader('Color Variants', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildColorVariants(colors),

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

  Widget _buildIconGallery(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: DoriSpacing.xs,
        runSpacing: DoriSpacing.xs,
        children: DoriIconData.values.map((iconData) {
          return _buildIconCard(iconData, colors);
        }).toList(),
      ),
    );
  }

  Widget _buildIconCard(DoriIconData iconData, DoriColorScheme colors) {
    return Container(
      width: 80,
      padding: EdgeInsets.all(DoriSpacing.xxs),
      decoration: BoxDecoration(
        color: colors.surface.two,
        borderRadius: DoriRadius.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DoriIcon(
            icon: iconData,
            size: DoriIconSize.md,
            color: colors.content.one,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: iconData.name,
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeComparison(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSizeItem(DoriIconSize.sm, '16dp', colors),
          _buildSizeItem(DoriIconSize.md, '24dp', colors),
          _buildSizeItem(DoriIconSize.lg, '32dp', colors),
        ],
      ),
    );
  }

  Widget _buildSizeItem(
    DoriIconSize size,
    String label,
    DoriColorScheme colors,
  ) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: Center(
            child: DoriIcon(
              icon: DoriIconData.search,
              size: size,
              color: colors.content.one,
            ),
          ),
        ),
        SizedBox(height: DoriSpacing.xxs),
        DoriText(
          label: size.name.toUpperCase(),
          variant: DoriTypographyVariant.captionBold,
          color: colors.content.one,
        ),
        DoriText(
          label: label,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }

  Widget _buildColorVariants(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: DoriSpacing.md,
        runSpacing: DoriSpacing.xs,
        children: [
          _buildColorItem('content.one', colors.content.one, colors),
          _buildColorItem('content.two', colors.content.two, colors),
          _buildColorItem('brand.pure', colors.brand.pure, colors),
          _buildColorItem('feedback.success', colors.feedback.success, colors),
          _buildColorItem('feedback.error', colors.feedback.error, colors),
          _buildColorItem('feedback.info', colors.feedback.info, colors),
        ],
      ),
    );
  }

  Widget _buildColorItem(String label, Color color, DoriColorScheme colors) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: Center(
            child: DoriIcon(
              icon: DoriIconData.check,
              size: DoriIconSize.md,
              color: color,
            ),
          ),
        ),
        SizedBox(height: DoriSpacing.xxxs),
        DoriText(
          label: label,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }
}
