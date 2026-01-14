import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing Dori typography
@widgetbook.UseCase(
  name: 'Typography',
  type: TypographyShowcase,
  path: '[Tokens]',
)
Widget buildTypographyShowcase(BuildContext context) {
  return const TypographyShowcase();
}

/// Widget showcase for typography
class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;

    final variants = [
      _TypographyItem(
        'title5',
        DoriTypography.title5,
        '24px / ExtraBold (800)',
        'Main titles',
      ),
      _TypographyItem(
        'description',
        DoriTypography.description,
        '14px / Medium (500)',
        'Default text',
      ),
      _TypographyItem(
        'descriptionBold',
        DoriTypography.descriptionBold,
        '14px / Bold (700)',
        'Default text with emphasis',
      ),
      _TypographyItem(
        'caption',
        DoriTypography.caption,
        '12px / Medium (500)',
        'Small text, labels',
      ),
      _TypographyItem(
        'captionBold',
        DoriTypography.captionBold,
        '12px / Bold (700)',
        'Small text with emphasis',
      ),
    ];

    return Container(
      color: colors.surface.pure,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DoriSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Typography',
              style: DoriTypography.title5.copyWith(color: colors.content.one),
            ),
            SizedBox(height: DoriSpacing.xxxs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DoriSpacing.xxs,
                vertical: DoriSpacing.xxxs,
              ),
              decoration: BoxDecoration(
                color: colors.surface.two,
                borderRadius: DoriRadius.sm,
              ),
              child: Text(
                'Plus Jakarta Sans',
                style: DoriTypography.captionBold.copyWith(
                  color: colors.content.two,
                ),
              ),
            ),
            SizedBox(height: DoriSpacing.md),
            ...variants.map((item) => _buildTypographyCard(item, colors)),
            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyCard(_TypographyItem item, DoriColorScheme colors) {
    return Container(
      margin: EdgeInsets.only(bottom: DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with accent bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: DoriSpacing.xs,
              vertical: DoriSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: colors.brand.two,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DoriRadius.mdValue),
                topRight: Radius.circular(DoriRadius.mdValue),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: DoriTypography.captionBold.copyWith(
                    color: colors.brand.pure,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  item.specs,
                  style: DoriTypography.caption.copyWith(
                    color: colors.brand.one,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Sample text area
          Padding(
            padding: EdgeInsets.all(DoriSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The quick brown fox jumps over the lazy dog',
                  style: item.style.copyWith(color: colors.content.one),
                ),
                SizedBox(height: DoriSpacing.xxs),
                Text(
                  item.usage,
                  style: DoriTypography.caption.copyWith(
                    color: colors.content.two,
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

class _TypographyItem {
  final String name;
  final TextStyle style;
  final String specs;
  final String usage;

  _TypographyItem(this.name, this.style, this.specs, this.usage);
}
