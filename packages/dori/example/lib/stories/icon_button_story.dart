import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriIconButton atom
@widgetbook.UseCase(
  name: 'Icon Button',
  type: DoriIconButtonShowcase,
  path: '[Atoms]',
)
Widget buildDoriIconButtonShowcase(BuildContext context) {
  return const DoriIconButtonShowcase();
}

/// Widget showcase for DoriIconButton - displays sizes and states
class DoriIconButtonShowcase extends StatelessWidget {
  const DoriIconButtonShowcase({super.key});

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
              label: 'DoriIconButton',
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

            // Size Comparison Section
            _buildSectionHeader('Size Comparison', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildSizeComparison(colors),

            SizedBox(height: DoriSpacing.md),

            // States Section
            _buildSectionHeader('Button States', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildStatesShowcase(colors),

            SizedBox(height: DoriSpacing.md),

            // Color Variants Section
            _buildSectionHeader('Color Variants', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildColorVariants(colors),

            SizedBox(height: DoriSpacing.md),

            // Use Cases Section
            _buildSectionHeader('Common Use Cases', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildUseCases(colors),

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

  Widget _buildSizeComparison(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSizeItem(DoriIconButtonSize.sm, '24dp', 'Compact', colors),
          _buildSizeItem(DoriIconButtonSize.md, '32dp', 'Default', colors),
          _buildSizeItem(DoriIconButtonSize.lg, '40dp', 'Large', colors),
          _buildSizeItem(DoriIconButtonSize.xlg, '48dp', 'Touch', colors),
        ],
      ),
    );
  }

  Widget _buildSizeItem(
    DoriIconButtonSize size,
    String label,
    String description,
    DoriColorScheme colors,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(DoriSpacing.xxs),
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: DoriIconButton(
            icon: DoriIconData.search,
            size: size,
            iconColor: colors.content.one,
            onPressed: () {},
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
        DoriText(
          label: description,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }

  Widget _buildStatesShowcase(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStateItem('Enabled', true, colors),
          _buildStateItem('Disabled', false, colors),
        ],
      ),
    );
  }

  Widget _buildStateItem(String label, bool enabled, DoriColorScheme colors) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(DoriSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: DoriIconButton(
            icon: DoriIconData.close,
            iconColor: enabled ? colors.content.one : colors.content.two,
            onPressed: enabled ? () {} : null,
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

  Widget _buildColorVariants(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Wrap(
        spacing: DoriSpacing.md,
        runSpacing: DoriSpacing.xs,
        children: [
          _buildColorItem('Default', colors.content.one, null, colors),
          _buildColorItem('Brand', colors.brand.pure, null, colors),
          _buildColorItem(
            'With BG',
            colors.surface.pure,
            colors.brand.pure,
            colors,
          ),
          _buildColorItem('Error', colors.feedback.error, null, colors),
        ],
      ),
    );
  }

  Widget _buildColorItem(
    String label,
    Color iconColor,
    Color? bgColor,
    DoriColorScheme colors,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(DoriSpacing.xxs),
          decoration: BoxDecoration(
            color: colors.surface.two,
            borderRadius: DoriRadius.sm,
          ),
          child: DoriIconButton(
            icon: DoriIconData.check,
            iconColor: iconColor,
            backgroundColor: bgColor,
            onPressed: () {},
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

  Widget _buildUseCases(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Column(
        children: [
          // AppBar simulation
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: DoriSpacing.xs,
              vertical: DoriSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: colors.surface.two,
              borderRadius: DoriRadius.sm,
            ),
            child: Row(
              children: [
                DoriIconButton(
                  icon: DoriIconData.arrowBack,
                  size: DoriIconButtonSize.md,
                  iconColor: colors.content.one,
                  onPressed: () {},
                ),
                SizedBox(width: DoriSpacing.xxs),
                Expanded(
                  child: DoriText(
                    label: 'Product Details',
                    variant: DoriTypographyVariant.descriptionBold,
                    color: colors.content.one,
                  ),
                ),
                DoriIconButton(
                  icon: DoriIconData.search,
                  size: DoriIconButtonSize.md,
                  iconColor: colors.content.one,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriText(
            label: 'AppBar with back and search buttons (md size)',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
        ],
      ),
    );
  }
}
