import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_colors.dart';
import '../../tokens/dori_spacing.dart';
import '../../tokens/dori_typography.dart';
import '../../atoms/icon/dori_icon.dart';
import '../../atoms/text/dori_text.dart';
import 'dori_status_feedback_banner_variant.dart';

export 'dori_status_feedback_banner_variant.dart';

/// A status feedback banner for displaying persistent status messages.
///
/// Banners are used to communicate important status information to users,
/// such as connectivity state or data staleness. They appear below the AppBar
/// and above the main content.
///
/// ## Example
///
/// ```dart
/// // Offline banner (non-dismissible)
/// DoriStatusFeedbackBanner(
///   message: 'Você está offline',
///   variant: DoriStatusFeedbackBannerVariant.info,
/// )
///
/// // Stale data banner (dismissible)
/// DoriStatusFeedbackBanner(
///   message: 'Seus dados podem estar desatualizados',
///   variant: DoriStatusFeedbackBannerVariant.warning,
///   isDismissible: true,
///   onDismiss: () => viewModel.dismissStaleBanner(),
/// )
///
/// // With action button
/// DoriStatusFeedbackBanner(
///   message: 'Seus dados podem estar desatualizados',
///   variant: DoriStatusFeedbackBannerVariant.warning,
///   actionLabel: 'Tentar novamente',
///   onAction: () => viewModel.refresh(),
/// )
/// ```
///
/// ## Accessibility
///
/// The banner is announced by screen readers via [Semantics.liveRegion].
/// The announcement includes the message and any available actions.
///
/// {@category Molecules}
class DoriStatusFeedbackBanner extends StatelessWidget {
  /// Creates a status feedback banner.
  const DoriStatusFeedbackBanner({
    required this.message,
    this.variant = DoriStatusFeedbackBannerVariant.info,
    this.isDismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert(
         !isDismissible || onDismiss != null,
         'onDismiss must be provided when isDismissible is true',
       );

  /// The message to display in the banner.
  final String message;

  /// Visual variant determining colors and icon.
  ///
  /// Defaults to [DoriStatusFeedbackBannerVariant.info].
  final DoriStatusFeedbackBannerVariant variant;

  /// Whether the banner can be dismissed by the user.
  ///
  /// Defaults to false. When true, a close button is shown.
  final bool isDismissible;

  /// Callback when banner is dismissed.
  ///
  /// Required when [isDismissible] is true.
  final VoidCallback? onDismiss;

  /// Optional action button label.
  ///
  /// When provided along with [onAction], shows an action button.
  final String? actionLabel;

  /// Callback when action button is pressed.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final (backgroundColor, contentColor, icon) = _getStyle(colors);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: DoriSpacing.sm,
          vertical: DoriSpacing.xs,
        ),
        color: backgroundColor,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              DoriIcon(icon: icon, color: contentColor, size: DoriIconSize.sm),
              const SizedBox(width: DoriSpacing.xxs),
              Expanded(
                child: DoriText(
                  label: message,
                  color: contentColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(width: DoriSpacing.xxs),
                _ActionButton(
                  label: actionLabel!,
                  onPressed: onAction!,
                  color: contentColor,
                ),
              ],
              if (isDismissible) ...[
                const SizedBox(width: DoriSpacing.xxs),
                GestureDetector(
                  onTap: onDismiss,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(DoriSpacing.xxxs),
                    child: DoriIcon(
                      icon: DoriIconData.close,
                      color: contentColor,
                      size: DoriIconSize.sm,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Returns background color, content color, and icon based on variant.
  (Color backgroundColor, Color contentColor, DoriIconData icon) _getStyle(
    DoriColorScheme colors,
  ) {
    return switch (variant) {
      DoriStatusFeedbackBannerVariant.success => (
        colors.feedback.successSoft,
        colors.feedback.successLight,
        DoriIconData.check,
      ),
      DoriStatusFeedbackBannerVariant.error => (
        colors.feedback.errorSoft,
        colors.feedback.errorLight,
        DoriIconData.error,
      ),
      DoriStatusFeedbackBannerVariant.info => (
        colors.feedback.infoSoft,
        colors.feedback.infoLight,
        DoriIconData.info,
      ),
      DoriStatusFeedbackBannerVariant.warning => (
        colors.feedback.infoSoft,
        colors.feedback.infoLight,
        DoriIconData.warning,
      ),
    };
  }
}

/// Internal action button for the banner.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DoriSpacing.xxs,
          vertical: DoriSpacing.xxxs,
        ),
        child: DoriText(
          label: label,
          variant: DoriTypographyVariant.captionBold,
          color: color,
        ),
      ),
    );
  }
}
