import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriToast atom
@widgetbook.UseCase(
  name: 'Toast Showcase',
  type: DoriToastShowcase,
  path: '[Atoms]',
)
Widget buildDoriToastShowcase(BuildContext context) {
  return const DoriToastShowcase();
}

/// Widget showcase for DoriToast - displays all variants and interactions
class DoriToastShowcase extends StatelessWidget {
  const DoriToastShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final isDark = context.dori.isDark;

    return Container(
      color: colors.surface.pure,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DoriSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DoriText(
              label: 'DoriToast',
              variant: DoriTypographyVariant.title5,
              color: colors.content.one,
            ),
            const SizedBox(height: DoriSpacing.xxxs),
            Container(
              padding: const EdgeInsets.symmetric(
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
            const SizedBox(height: DoriSpacing.md),

            // Variants Section
            _buildSectionHeader('Variants', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildVariantsSection(colors),

            const SizedBox(height: DoriSpacing.md),

            // With Dismiss Button
            _buildSectionHeader('With Dismiss Button', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildDismissableSection(colors),

            const SizedBox(height: DoriSpacing.md),

            // Long Text
            _buildSectionHeader('Long Text', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildLongTextSection(colors),

            const SizedBox(height: DoriSpacing.md),

            // Interactive Demo
            _buildSectionHeader('Interactive Demo', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildInteractiveDemo(context),

            const SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, DoriColorScheme colors) {
    return DoriText(
      label: title,
      variant: DoriTypographyVariant.descriptionBold,
      color: colors.content.one,
    );
  }

  Widget _buildVariantsSection(DoriColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.two,
        borderRadius: DoriRadius.lg,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriToast(
            message: 'Neutral toast message',
            variant: DoriToastVariant.neutral,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriToast(
            message: 'Success! Operation completed.',
            variant: DoriToastVariant.success,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriToast(
            message: 'Error! Something went wrong.',
            variant: DoriToastVariant.error,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriToast(
            message: 'Info: New update available.',
            variant: DoriToastVariant.info,
          ),
        ],
      ),
    );
  }

  Widget _buildDismissableSection(DoriColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.two,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriToast(
            message: 'Tap X to dismiss',
            variant: DoriToastVariant.info,
            onDismiss: () {},
          ),
          const SizedBox(height: DoriSpacing.xs),
          DoriToast(
            message: 'Success with dismiss',
            variant: DoriToastVariant.success,
            onDismiss: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLongTextSection(DoriColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface.two,
        borderRadius: DoriRadius.lg,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriToast(
            message:
                'This is a very long toast message that should wrap to multiple lines and show ellipsis if too long.',
            variant: DoriToastVariant.info,
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveDemo(BuildContext context) {
    return Wrap(
      spacing: DoriSpacing.xxs,
      runSpacing: DoriSpacing.xxs,
      children: [
        DoriButton(
          label: 'Show Neutral',
          variant: DoriButtonVariant.secondary,
          size: DoriButtonSize.sm,
          onPressed: () => context.showDoriToast(
            message: 'Neutral notification',
            variant: DoriToastVariant.neutral,
          ),
        ),
        DoriButton(
          label: 'Show Success',
          variant: DoriButtonVariant.secondary,
          size: DoriButtonSize.sm,
          onPressed: () => context.showDoriToast(
            message: 'Operation successful!',
            variant: DoriToastVariant.success,
          ),
        ),
        DoriButton(
          label: 'Show Error',
          variant: DoriButtonVariant.secondary,
          size: DoriButtonSize.sm,
          onPressed: () => context.showDoriToast(
            message: 'Something went wrong',
            variant: DoriToastVariant.error,
          ),
        ),
        DoriButton(
          label: 'Show Info',
          variant: DoriButtonVariant.secondary,
          size: DoriButtonSize.sm,
          onPressed: () => context.showDoriToast(
            message: 'Here is some information',
            variant: DoriToastVariant.info,
          ),
        ),
      ],
    );
  }
}
