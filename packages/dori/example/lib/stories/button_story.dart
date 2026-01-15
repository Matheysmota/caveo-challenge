import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriButton atom
@widgetbook.UseCase(
  name: 'Button Showcase',
  type: DoriButtonShowcase,
  path: '[Atoms]',
)
Widget buildDoriButtonShowcase(BuildContext context) {
  return const DoriButtonShowcase();
}

/// Widget showcase for DoriButton - displays all variants, sizes, and states
class DoriButtonShowcase extends StatelessWidget {
  const DoriButtonShowcase({super.key});

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
              label: 'DoriButton',
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

            // States Section
            _buildSectionHeader('States', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildStatesSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Icons Section
            _buildSectionHeader('With Icons', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildIconsSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Expanded Section
            _buildSectionHeader('Expanded Width', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildExpandedSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Collapsed Section
            _buildSectionHeader('Collapsed (Compact)', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildCollapsedSection(colors),

            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, DoriColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoriText(
          label: title,
          variant: DoriTypographyVariant.descriptionBold,
          color: colors.content.one,
        ),
        SizedBox(height: DoriSpacing.xxxs),
        Container(height: 1, color: colors.surface.three),
      ],
    );
  }

  Widget _buildVariantsSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        children: [
          _buildVariantRow('Primary', DoriButtonVariant.primary, colors),
          SizedBox(height: DoriSpacing.xxs),
          _buildVariantRow('Secondary', DoriButtonVariant.secondary, colors),
          SizedBox(height: DoriSpacing.xxs),
          _buildVariantRow('Tertiary', DoriButtonVariant.tertiary, colors),
        ],
      ),
    );
  }

  Widget _buildVariantRow(
    String label,
    DoriButtonVariant variant,
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
        Expanded(
          child: DoriButton(
            label: 'Button',
            variant: variant,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSizesSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        children: [
          _buildSizeRow('sm (32dp)', DoriButtonSize.sm, colors),
          SizedBox(height: DoriSpacing.xxs),
          _buildSizeRow('md (44dp)', DoriButtonSize.md, colors),
          SizedBox(height: DoriSpacing.xxs),
          _buildSizeRow('lg (52dp)', DoriButtonSize.lg, colors),
        ],
      ),
    );
  }

  Widget _buildSizeRow(
    String label,
    DoriButtonSize size,
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
        Expanded(
          child: DoriButton(label: 'Button', size: size, onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildStatesSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Enabled',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              Expanded(
                child: DoriButton(label: 'Enabled', onPressed: () {}),
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xxs),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Disabled',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              const Expanded(
                child: DoriButton(label: 'Disabled', onPressed: null),
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xxs),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Loading',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              Expanded(
                child: DoriButton(
                  label: 'Loading',
                  isLoading: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconsSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Leading',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              Expanded(
                child: DoriButton(
                  label: 'Add to Cart',
                  leadingIcon: DoriIconData.check,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xxs),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Trailing',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              Expanded(
                child: DoriButton(
                  label: 'Continue',
                  trailingIcon: DoriIconData.chevronRight,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xxs),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: DoriText(
                  label: 'Both',
                  variant: DoriTypographyVariant.caption,
                  color: colors.content.two,
                ),
              ),
              Expanded(
                child: DoriButton(
                  label: 'Refresh',
                  leadingIcon: DoriIconData.refresh,
                  trailingIcon: DoriIconData.chevronRight,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        children: [
          DoriButton(
            label: 'Full Width Primary',
            isExpanded: true,
            onPressed: () {},
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriButton(
            label: 'Full Width Secondary',
            variant: DoriButtonVariant.secondary,
            isExpanded: true,
            onPressed: () {},
          ),
          SizedBox(height: DoriSpacing.xxs),
          DoriButton(
            label: 'Full Width Loading',
            isExpanded: true,
            isLoading: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Normal vs Collapsed comparison:',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          // Normal vs Collapsed - Primary
          Row(
            children: [
              DoriButton(label: 'Normal', onPressed: () {}),
              SizedBox(width: DoriSpacing.xxs),
              DoriButton(
                label: 'Collapsed',
                isCollapsed: true,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xxs),
          // Normal vs Collapsed - Secondary
          Row(
            children: [
              DoriButton(
                label: 'Normal',
                variant: DoriButtonVariant.secondary,
                onPressed: () {},
              ),
              SizedBox(width: DoriSpacing.xxs),
              DoriButton(
                label: 'Collapsed',
                variant: DoriButtonVariant.secondary,
                isCollapsed: true,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriText(
            label: 'Collapsed with different sizes:',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxs),
          Wrap(
            spacing: DoriSpacing.xxs,
            runSpacing: DoriSpacing.xxs,
            children: [
              DoriButton(
                label: 'sm',
                size: DoriButtonSize.sm,
                isCollapsed: true,
                onPressed: () {},
              ),
              DoriButton(
                label: 'md',
                size: DoriButtonSize.md,
                isCollapsed: true,
                onPressed: () {},
              ),
              DoriButton(
                label: 'lg',
                size: DoriButtonSize.lg,
                isCollapsed: true,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
