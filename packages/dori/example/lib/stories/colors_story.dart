import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the Dori color palette
@widgetbook.UseCase(
  name: 'Color Palette',
  type: ColorPaletteShowcase,
  path: '[Tokens]',
)
Widget buildColorPaletteShowcase(BuildContext context) {
  return const ColorPaletteShowcase();
}

/// Widget showcase for color palette - Pantone style cards
class ColorPaletteShowcase extends StatelessWidget {
  const ColorPaletteShowcase({super.key});

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
            Text(
              'Color Palette',
              style: DoriTypography.title5.copyWith(color: colors.content.one),
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
              child: Text(
                isDark ? 'Dark Mode' : 'Light Mode',
                style: DoriTypography.captionBold.copyWith(
                  color: isDark ? colors.brand.pure : Colors.white,
                ),
              ),
            ),
            SizedBox(height: DoriSpacing.md),

            // Brand Colors
            _buildSection('Brand', colors, [
              _ColorItem('pure', colors.brand.pure),
              _ColorItem('one', colors.brand.one),
              _ColorItem('two', colors.brand.two),
            ]),

            SizedBox(height: DoriSpacing.sm),

            // Surface Colors
            _buildSection('Surface', colors, [
              _ColorItem('pure', colors.surface.pure),
              _ColorItem('one', colors.surface.one),
              _ColorItem('two', colors.surface.two),
            ]),

            SizedBox(height: DoriSpacing.sm),

            // Content Colors
            _buildSection('Content', colors, [
              _ColorItem('pure', colors.content.pure),
              _ColorItem('one', colors.content.one),
              _ColorItem('two', colors.content.two),
            ]),

            SizedBox(height: DoriSpacing.sm),

            // Feedback Colors
            _buildSection('Feedback', colors, [
              _ColorItem('success', colors.feedback.success),
              _ColorItem('error', colors.feedback.error),
              _ColorItem('info', colors.feedback.info),
            ]),

            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    DoriColorScheme colors,
    List<_ColorItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Text(
              title,
              style: DoriTypography.descriptionBold.copyWith(
                color: colors.content.one,
              ),
            ),
          ],
        ),
        SizedBox(height: DoriSpacing.xs),
        Wrap(
          spacing: DoriSpacing.xs,
          runSpacing: DoriSpacing.xs,
          children:
              items.map((item) => _buildPantoneCard(item, colors)).toList(),
        ),
      ],
    );
  }

  Widget _buildPantoneCard(_ColorItem item, DoriColorScheme colors) {
    final hexColor =
        '#${item.color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Color swatch - larger area like Pantone
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DoriRadius.mdValue),
                topRight: Radius.circular(DoriRadius.mdValue),
              ),
            ),
          ),
          // Info section - clean background
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(DoriSpacing.xxs),
            decoration: BoxDecoration(
              color: colors.surface.one,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(DoriRadius.mdValue),
                bottomRight: Radius.circular(DoriRadius.mdValue),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: DoriTypography.captionBold.copyWith(
                    color: colors.content.one,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  hexColor,
                  style: DoriTypography.caption.copyWith(
                    color: colors.content.two,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;

  _ColorItem(this.name, this.color);
}
