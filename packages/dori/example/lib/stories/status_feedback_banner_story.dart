import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriStatusFeedbackBanner molecule
@widgetbook.UseCase(
  name: 'Status Feedback Banner Showcase',
  type: DoriStatusFeedbackBannerShowcase,
  path: '[Molecules]',
)
Widget buildDoriStatusFeedbackBannerShowcase(BuildContext context) {
  return const DoriStatusFeedbackBannerShowcase();
}

/// Widget showcase for DoriStatusFeedbackBanner - displays all variants
class DoriStatusFeedbackBannerShowcase extends StatefulWidget {
  const DoriStatusFeedbackBannerShowcase({super.key});

  @override
  State<DoriStatusFeedbackBannerShowcase> createState() =>
      _DoriStatusFeedbackBannerShowcaseState();
}

class _DoriStatusFeedbackBannerShowcaseState
    extends State<DoriStatusFeedbackBannerShowcase> {
  bool _isInfoDismissed = false;
  bool _isWarningDismissed = false;
  bool _isErrorDismissed = false;

  void _resetAll() {
    setState(() {
      _isInfoDismissed = false;
      _isWarningDismissed = false;
      _isErrorDismissed = false;
    });
  }

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
              label: 'DoriStatusFeedbackBanner',
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
            _buildVariantsSection(),

            const SizedBox(height: DoriSpacing.md),

            // Dismissible Section
            _buildSectionHeader('Dismissible', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildDismissibleSection(colors),

            const SizedBox(height: DoriSpacing.md),

            // With Action Section
            _buildSectionHeader('With Action Button', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildActionSection(context),

            const SizedBox(height: DoriSpacing.md),

            // Use Cases Section
            _buildSectionHeader('Real-world Use Cases', colors),
            const SizedBox(height: DoriSpacing.xs),
            _buildUseCasesSection(context),

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

  Widget _buildVariantsSection() {
    return const Column(
      children: [
        DoriStatusFeedbackBanner(
          message: 'Info: This is an informational banner',
          variant: DoriStatusFeedbackBannerVariant.info,
        ),
        SizedBox(height: DoriSpacing.xxs),
        DoriStatusFeedbackBanner(
          message: 'Warning: Your data may be outdated',
          variant: DoriStatusFeedbackBannerVariant.warning,
        ),
        SizedBox(height: DoriSpacing.xxs),
        DoriStatusFeedbackBanner(
          message: 'Error: Failed to connect to server',
          variant: DoriStatusFeedbackBannerVariant.error,
        ),
        SizedBox(height: DoriSpacing.xxs),
        DoriStatusFeedbackBanner(
          message: 'Success: Operation completed',
          variant: DoriStatusFeedbackBannerVariant.success,
        ),
      ],
    );
  }

  Widget _buildDismissibleSection(DoriColorScheme colors) {
    return Column(
      children: [
        if (!_isInfoDismissed)
          DoriStatusFeedbackBanner(
            message: 'Dismissible info banner',
            variant: DoriStatusFeedbackBannerVariant.info,
            isDismissible: true,
            onDismiss: () => setState(() => _isInfoDismissed = true),
          ),
        if (!_isWarningDismissed) ...[
          const SizedBox(height: DoriSpacing.xxs),
          DoriStatusFeedbackBanner(
            message: 'Dismissible warning banner',
            variant: DoriStatusFeedbackBannerVariant.warning,
            isDismissible: true,
            onDismiss: () => setState(() => _isWarningDismissed = true),
          ),
        ],
        if (!_isErrorDismissed) ...[
          const SizedBox(height: DoriSpacing.xxs),
          DoriStatusFeedbackBanner(
            message: 'Dismissible error banner',
            variant: DoriStatusFeedbackBannerVariant.error,
            isDismissible: true,
            onDismiss: () => setState(() => _isErrorDismissed = true),
          ),
        ],
        if (_isInfoDismissed || _isWarningDismissed || _isErrorDismissed) ...[
          const SizedBox(height: DoriSpacing.xs),
          Center(
            child: DoriButton(
              label: 'Reset All',
              variant: DoriButtonVariant.secondary,
              size: DoriButtonSize.sm,
              onPressed: _resetAll,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        DoriStatusFeedbackBanner(
          message: 'Your data may be outdated',
          variant: DoriStatusFeedbackBannerVariant.warning,
          actionLabel: 'Retry',
          onAction: () => context.showDoriToast(
            message: 'Retry action triggered',
            variant: DoriToastVariant.info,
          ),
        ),
        const SizedBox(height: DoriSpacing.xxs),
        DoriStatusFeedbackBanner(
          message: 'You are offline',
          variant: DoriStatusFeedbackBannerVariant.info,
          actionLabel: 'Try Again',
          onAction: () => context.showDoriToast(
            message: 'Try again action triggered',
            variant: DoriToastVariant.info,
          ),
        ),
      ],
    );
  }

  Widget _buildUseCasesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DoriSpacing.xs),
      decoration: BoxDecoration(
        color: context.dori.colors.surface.two,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Offline Mode',
            variant: DoriTypographyVariant.captionBold,
            color: context.dori.colors.content.two,
          ),
          const SizedBox(height: DoriSpacing.xxs),
          const DoriStatusFeedbackBanner(
            message: 'Você está offline',
            variant: DoriStatusFeedbackBannerVariant.info,
          ),
          const SizedBox(height: DoriSpacing.sm),
          DoriText(
            label: 'Stale Data',
            variant: DoriTypographyVariant.captionBold,
            color: context.dori.colors.content.two,
          ),
          const SizedBox(height: DoriSpacing.xxs),
          DoriStatusFeedbackBanner(
            message: 'Seus dados podem estar desatualizados',
            variant: DoriStatusFeedbackBannerVariant.warning,
            isDismissible: true,
            onDismiss: () => context.showDoriToast(
              message: 'Banner dismissed',
              variant: DoriToastVariant.neutral,
            ),
            actionLabel: 'Tentar novamente',
            onAction: () => context.showDoriToast(
              message: 'Refreshing...',
              variant: DoriToastVariant.info,
            ),
          ),
        ],
      ),
    );
  }
}
