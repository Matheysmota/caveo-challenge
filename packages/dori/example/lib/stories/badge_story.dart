import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriBadge atom
@widgetbook.UseCase(
  name: 'Badge Showcase',
  type: DoriBadgeShowcase,
  path: '[Atoms]',
)
Widget buildDoriBadgeShowcase(BuildContext context) {
  return const DoriBadgeShowcase();
}

/// Widget showcase for DoriBadge - displays all variants and sizes
class DoriBadgeShowcase extends StatelessWidget {
  const DoriBadgeShowcase({super.key});

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
              label: 'DoriBadge',
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

            // Variants Section
            _buildSectionHeader('Variants', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildVariantsSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Sizes Section
            _buildSectionHeader('Sizes', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildSizesSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Use Cases Section
            _buildSectionHeader('Use Cases', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildUseCasesSection(colors),

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

  Widget _buildVariantsSection(DoriColorScheme colors) {
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
          _buildVariantRow('Neutral', DoriBadgeVariant.neutral, colors),
          SizedBox(height: DoriSpacing.xs),
          _buildVariantRow('Success', DoriBadgeVariant.success, colors),
          SizedBox(height: DoriSpacing.xs),
          _buildVariantRow('Error', DoriBadgeVariant.error, colors),
          SizedBox(height: DoriSpacing.xs),
          _buildVariantRow('Info', DoriBadgeVariant.info, colors),
        ],
      ),
    );
  }

  Widget _buildVariantRow(
    String label,
    DoriBadgeVariant variant,
    DoriColorScheme colors,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: DoriText(
            label: label,
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
        ),
        SizedBox(width: DoriSpacing.xs),
        DoriBadge(label: 'Label', variant: variant),
        SizedBox(width: DoriSpacing.xxs),
        DoriBadge(label: '12', variant: variant),
        SizedBox(width: DoriSpacing.xxs),
        DoriBadge(label: 'NEW', variant: variant),
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
          _buildSizeItem('Small (sm)', DoriBadgeSize.sm, colors),
          _buildSizeItem('Medium (md)', DoriBadgeSize.md, colors),
        ],
      ),
    );
  }

  Widget _buildSizeItem(
    String label,
    DoriBadgeSize size,
    DoriColorScheme colors,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(DoriSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: DoriBadge(
            label: 'Badge',
            variant: DoriBadgeVariant.info,
            size: size,
          ),
        ),
        SizedBox(height: DoriSpacing.xxs),
        DoriText(
          label: label,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }

  Widget _buildUseCasesSection(DoriColorScheme colors) {
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
          // Status indicator
          _buildUseCase(
            'Status Indicator',
            Row(
              children: [
                const DoriBadge(
                  label: 'Active',
                  variant: DoriBadgeVariant.success,
                ),
                SizedBox(width: DoriSpacing.xxs),
                const DoriBadge(
                  label: 'Inactive',
                  variant: DoriBadgeVariant.neutral,
                ),
                SizedBox(width: DoriSpacing.xxs),
                const DoriBadge(
                  label: 'Error',
                  variant: DoriBadgeVariant.error,
                ),
              ],
            ),
            colors,
          ),
          SizedBox(height: DoriSpacing.sm),

          // Count badge
          _buildUseCase(
            'Notification Count',
            Row(
              children: [
                const DoriBadge(
                  label: '3',
                  variant: DoriBadgeVariant.error,
                  size: DoriBadgeSize.sm,
                  semanticLabel: '3 notifications',
                ),
                SizedBox(width: DoriSpacing.xxs),
                const DoriBadge(
                  label: '99+',
                  variant: DoriBadgeVariant.error,
                  size: DoriBadgeSize.sm,
                  semanticLabel: 'More than 99 notifications',
                ),
              ],
            ),
            colors,
          ),
          SizedBox(height: DoriSpacing.sm),

          // Labels
          _buildUseCase(
            'Category Labels',
            Row(
              children: [
                const DoriBadge(label: 'Featured'),
                SizedBox(width: DoriSpacing.xxs),
                const DoriBadge(label: 'New', variant: DoriBadgeVariant.info),
                SizedBox(width: DoriSpacing.xxs),
                const DoriBadge(
                  label: 'Sale',
                  variant: DoriBadgeVariant.success,
                ),
              ],
            ),
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildUseCase(String label, Widget content, DoriColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoriText(
          label: label,
          variant: DoriTypographyVariant.captionBold,
          color: colors.content.one,
        ),
        SizedBox(height: DoriSpacing.xxs),
        content,
      ],
    );
  }
}
