import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing Dori border radii
@widgetbook.UseCase(
  name: 'Border Radius',
  type: RadiusShowcase,
  path: '[Tokens]',
)
Widget buildRadiusShowcase(BuildContext context) {
  return const RadiusShowcase();
}

/// Widget showcase for border radius
class RadiusShowcase extends StatelessWidget {
  const RadiusShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;

    final radii = [
      _RadiusItem(
        'sm',
        DoriRadius.sm,
        DoriRadius.smValue,
        'Buttons, inputs, badges',
      ),
      _RadiusItem(
        'md',
        DoriRadius.md,
        DoriRadius.mdValue,
        'Small cards, chips',
      ),
      _RadiusItem(
        'lg',
        DoriRadius.lg,
        DoriRadius.lgValue,
        'Main cards, modals',
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
              'Border Radius',
              style: DoriTypography.title5.copyWith(color: colors.content.one),
            ),
            SizedBox(height: DoriSpacing.xxxs),
            Text(
              'Rounded corners scale',
              style: DoriTypography.caption.copyWith(color: colors.content.two),
            ),
            SizedBox(height: DoriSpacing.md),
            ...radii.map((item) => _buildRadiusCard(item, colors)),
            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusCard(_RadiusItem item, DoriColorScheme colors) {
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
          // Radius visualization
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.brand.pure, colors.brand.one],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: item.radius,
              boxShadow: [
                BoxShadow(
                  color: colors.brand.pure.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${item.value.toInt()}',
                style: DoriTypography.title5.copyWith(
                  color: Colors.white,
                ),
              ),
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

class _RadiusItem {
  final String name;
  final BorderRadius radius;
  final double value;
  final String usage;

  _RadiusItem(this.name, this.radius, this.value, this.usage);
}
