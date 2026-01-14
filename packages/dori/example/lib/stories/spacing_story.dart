import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing Dori spacings
@widgetbook.UseCase(
  name: 'Spacing Scale',
  type: SpacingShowcase,
  path: '[Tokens]',
)
Widget buildSpacingShowcase(BuildContext context) {
  return const SpacingShowcase();
}

/// Widget showcase for spacing scale
class SpacingShowcase extends StatelessWidget {
  const SpacingShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;

    final spacings = [
      _SpacingItem('xxxs', DoriSpacing.xxxs, 'Micro spacing, icon-text'),
      _SpacingItem('xxs', DoriSpacing.xxs, 'Between close items'),
      _SpacingItem('xs', DoriSpacing.xs, 'Between list items'),
      _SpacingItem('sm', DoriSpacing.sm, 'Card padding'),
      _SpacingItem('md', DoriSpacing.md, 'Between sections'),
      _SpacingItem('lg', DoriSpacing.lg, 'Page margins'),
      _SpacingItem('xl', DoriSpacing.xl, 'Large spaces'),
    ];

    return Container(
      color: colors.surface.pure,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DoriSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spacing Scale',
              style: DoriTypography.title5.copyWith(color: colors.content.one),
            ),
            SizedBox(height: DoriSpacing.xxxs),
            Text(
              'Flat scale based on multiples of 4dp',
              style: DoriTypography.caption.copyWith(color: colors.content.two),
            ),
            SizedBox(height: DoriSpacing.md),
            ...spacings.map((item) => _buildSpacingCard(item, colors)),
            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingCard(_SpacingItem item, DoriColorScheme colors) {
    return Container(
      margin: EdgeInsets.only(bottom: DoriSpacing.xs),
      padding: EdgeInsets.all(DoriSpacing.xs),
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
      child: Row(
        children: [
          // Spacing visualization
          Container(
            width: item.value,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.brand.pure, colors.brand.one],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: DoriRadius.sm,
            ),
          ),
          SizedBox(width: DoriSpacing.xs),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name.toUpperCase(),
                      style: DoriTypography.descriptionBold.copyWith(
                        color: colors.content.one,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: DoriSpacing.xxs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DoriSpacing.xxs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.brand.two,
                        borderRadius: DoriRadius.sm,
                      ),
                      child: Text(
                        '${item.value.toInt()}dp',
                        style: DoriTypography.captionBold.copyWith(
                          color: colors.brand.pure,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  item.description,
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

class _SpacingItem {
  final String name;
  final double value;
  final String description;

  _SpacingItem(this.name, this.value, this.description);
}
