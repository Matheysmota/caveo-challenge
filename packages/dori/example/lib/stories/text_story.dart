import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriText atom
@widgetbook.UseCase(
  name: 'Text Variants',
  type: DoriTextShowcase,
  path: '[Atoms]',
)
Widget buildDoriTextShowcase(BuildContext context) {
  return const DoriTextShowcase();
}

/// Widget showcase for DoriText variants - Pantone style cards
class DoriTextShowcase extends StatelessWidget {
  const DoriTextShowcase({super.key});

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
              label: 'DoriText',
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

            // Typography Variants Section
            _buildSectionHeader('Typography Variants', colors),
            SizedBox(height: DoriSpacing.xs),

            // Title5
            _buildVariantCard(
              context: context,
              name: 'title5',
              description: '24px ExtraBold',
              variant: DoriTypographyVariant.title5,
              colors: colors,
            ),
            SizedBox(height: DoriSpacing.xs),

            // Description
            _buildVariantCard(
              context: context,
              name: 'description',
              description: '14px Medium',
              variant: DoriTypographyVariant.description,
              colors: colors,
            ),
            SizedBox(height: DoriSpacing.xs),

            // Description Bold
            _buildVariantCard(
              context: context,
              name: 'descriptionBold',
              description: '14px Bold',
              variant: DoriTypographyVariant.descriptionBold,
              colors: colors,
            ),
            SizedBox(height: DoriSpacing.xs),

            // Caption
            _buildVariantCard(
              context: context,
              name: 'caption',
              description: '12px Medium',
              variant: DoriTypographyVariant.caption,
              colors: colors,
            ),
            SizedBox(height: DoriSpacing.xs),

            // Caption Bold
            _buildVariantCard(
              context: context,
              name: 'captionBold',
              description: '12px Bold',
              variant: DoriTypographyVariant.captionBold,
              colors: colors,
            ),

            SizedBox(height: DoriSpacing.md),

            // Color Variants Section
            _buildSectionHeader('Color Variations', colors),
            SizedBox(height: DoriSpacing.xs),

            _buildColorShowcase(colors),

            SizedBox(height: DoriSpacing.md),

            // Overflow Section
            _buildSectionHeader('Overflow Handling', colors),
            SizedBox(height: DoriSpacing.xs),

            _buildOverflowShowcase(colors),

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

  Widget _buildVariantCard({
    required BuildContext context,
    required String name,
    required String description,
    required DoriTypographyVariant variant,
    required DoriColorScheme colors,
  }) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview area
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(DoriSpacing.sm),
            decoration: BoxDecoration(
              color: colors.surface.two,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DoriRadius.mdValue),
                topRight: Radius.circular(DoriRadius.mdValue),
              ),
            ),
            child: DoriText(
              label: 'The quick brown fox jumps over the lazy dog',
              variant: variant,
              color: colors.content.one,
            ),
          ),
          // Info area
          Padding(
            padding: EdgeInsets.all(DoriSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DoriText(
                  label: name.toUpperCase(),
                  variant: DoriTypographyVariant.captionBold,
                  color: colors.content.one,
                ),
                DoriText(
                  label: description,
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

  Widget _buildColorShowcase(DoriColorScheme colors) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'content.pure',
            variant: DoriTypographyVariant.description,
            color: colors.content.pure,
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriText(
            label: 'content.one (default)',
            variant: DoriTypographyVariant.description,
            color: colors.content.one,
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriText(
            label: 'content.two',
            variant: DoriTypographyVariant.description,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriText(
            label: 'brand.pure',
            variant: DoriTypographyVariant.description,
            color: colors.brand.pure,
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriText(
            label: 'feedback.success',
            variant: DoriTypographyVariant.description,
            color: colors.feedback.success,
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriText(
            label: 'feedback.error',
            variant: DoriTypographyVariant.description,
            color: colors.feedback.error,
          ),
        ],
      ),
    );
  }

  Widget _buildOverflowShowcase(DoriColorScheme colors) {
    const longText =
        'This is a very long text that demonstrates how DoriText handles overflow. '
        'It will be truncated with an ellipsis when it exceeds the maximum number of lines.';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'maxLines: 1',
            variant: DoriTypographyVariant.captionBold,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: longText,
            variant: DoriTypographyVariant.description,
            color: colors.content.one,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriText(
            label: 'maxLines: 2',
            variant: DoriTypographyVariant.captionBold,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: longText,
            variant: DoriTypographyVariant.description,
            color: colors.content.one,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriText(
            label: 'No limit',
            variant: DoriTypographyVariant.captionBold,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: longText,
            variant: DoriTypographyVariant.description,
            color: colors.content.one,
          ),
        ],
      ),
    );
  }
}
