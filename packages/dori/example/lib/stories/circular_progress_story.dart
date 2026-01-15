import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriCircularProgress atom
@widgetbook.UseCase(
  name: 'Circular Progress Showcase',
  type: DoriCircularProgressShowcase,
  path: '[Atoms]',
)
Widget buildDoriCircularProgressShowcase(BuildContext context) {
  return const DoriCircularProgressShowcase();
}

/// Widget showcase for DoriCircularProgress - displays all sizes and options
class DoriCircularProgressShowcase extends StatelessWidget {
  const DoriCircularProgressShowcase({super.key});

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
              label: 'DoriCircularProgress',
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

            // Colors Section
            _buildSectionHeader('Custom Colors', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildColorsSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Background Section
            _buildSectionHeader('With Background Halo', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildBackgroundSection(colors),

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

  Widget _buildSizesSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSizeItem('sm (20dp)', DoriCircularProgressSize.sm, colors),
          _buildSizeItem('md (36dp)', DoriCircularProgressSize.md, colors),
          _buildSizeItem('lg (48dp)', DoriCircularProgressSize.lg, colors),
        ],
      ),
    );
  }

  Widget _buildSizeItem(
    String label,
    DoriCircularProgressSize size,
    DoriColorScheme colors,
  ) {
    return Column(
      children: [
        DoriCircularProgress(size: size),
        SizedBox(height: DoriSpacing.xxs),
        DoriText(
          label: label,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }

  Widget _buildColorsSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildColorItem('Brand', colors.brand.pure, colors),
          _buildColorItem('Success', colors.feedback.success, colors),
          _buildColorItem('Error', colors.feedback.error, colors),
          _buildColorItem('Info', colors.feedback.info, colors),
        ],
      ),
    );
  }

  Widget _buildColorItem(String label, Color color, DoriColorScheme colors) {
    return Column(
      children: [
        DoriCircularProgress(color: color),
        SizedBox(height: DoriSpacing.xxs),
        DoriText(
          label: label,
          variant: DoriTypographyVariant.caption,
          color: colors.content.two,
        ),
      ],
    );
  }

  Widget _buildBackgroundSection(DoriColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const DoriCircularProgress(showBackground: false),
              SizedBox(height: DoriSpacing.xxs),
              DoriText(
                label: 'Without',
                variant: DoriTypographyVariant.caption,
                color: colors.content.two,
              ),
            ],
          ),
          Column(
            children: [
              const DoriCircularProgress(showBackground: true),
              SizedBox(height: DoriSpacing.xxs),
              DoriText(
                label: 'With',
                variant: DoriTypographyVariant.caption,
                color: colors.content.two,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUseCasesSection(DoriColorScheme colors) {
    return Column(
      children: [
        // Button loading state
        Container(
          padding: EdgeInsets.all(DoriSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.one,
            borderRadius: DoriRadius.lg,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: DoriSpacing.sm,
                  vertical: DoriSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colors.brand.pure,
                  borderRadius: DoriRadius.md,
                ),
                child: DoriCircularProgress(
                  size: DoriCircularProgressSize.sm,
                  color: colors.surface.pure,
                ),
              ),
              SizedBox(width: DoriSpacing.xs),
              Expanded(
                child: DoriText(
                  label: 'Button loading state',
                  variant: DoriTypographyVariant.description,
                  color: colors.content.one,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DoriSpacing.xxs),
        // Page loading
        Container(
          padding: EdgeInsets.all(DoriSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.one,
            borderRadius: DoriRadius.lg,
          ),
          child: Row(
            children: [
              const DoriCircularProgress(
                size: DoriCircularProgressSize.lg,
                showBackground: true,
              ),
              SizedBox(width: DoriSpacing.xs),
              Expanded(
                child: DoriText(
                  label: 'Page loading indicator',
                  variant: DoriTypographyVariant.description,
                  color: colors.content.one,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DoriSpacing.xxs),
        // Inline loading
        Container(
          padding: EdgeInsets.all(DoriSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.one,
            borderRadius: DoriRadius.lg,
          ),
          child: Row(
            children: [
              const DoriCircularProgress(size: DoriCircularProgressSize.sm),
              SizedBox(width: DoriSpacing.xxs),
              Expanded(
                child: DoriText(
                  label: 'Inline loading text',
                  variant: DoriTypographyVariant.description,
                  color: colors.content.one,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
