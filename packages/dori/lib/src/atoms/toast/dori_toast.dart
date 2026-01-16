import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_colors.dart';
import '../../tokens/dori_radius.dart';
import '../../tokens/dori_shadows.dart';
import '../../tokens/dori_spacing.dart';
import '../icon/dori_icon.dart';
import '../text/dori_text.dart';
import 'dori_toast_variant.dart';

export 'dori_toast_variant.dart';

/// A toast notification component for displaying brief messages.
///
/// Toasts are lightweight, non-blocking notifications that appear temporarily
/// to provide feedback about an operation. They automatically dismiss after
/// a duration or can be manually dismissed.
///
/// ## Example
///
/// ```dart
/// // Show a toast using the extension method
/// context.showDoriToast(
///   message: 'Operation successful!',
///   variant: DoriToastVariant.success,
/// );
///
/// // Show an error toast
/// context.showDoriToast(
///   message: 'Failed to update data',
///   variant: DoriToastVariant.error,
/// );
/// ```
///
/// ## Accessibility
///
/// The toast is announced by screen readers via [Semantics.liveRegion].
/// The announcement is polite by default (won't interrupt current speech).
///
/// {@category Atoms}
class DoriToast extends StatelessWidget {
  /// Creates a toast notification.
  const DoriToast({
    required this.message,
    this.variant = DoriToastVariant.neutral,
    this.onDismiss,
    super.key,
  });

  /// The message to display in the toast.
  final String message;

  /// Visual variant determining colors and icon.
  ///
  /// Defaults to [DoriToastVariant.neutral].
  final DoriToastVariant variant;

  /// Callback when toast is dismissed.
  ///
  /// Called when the user taps the close button or toast auto-dismisses.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final (backgroundColor, textColor, icon) = _getStyle(colors);

    return Semantics(
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(
          horizontal: DoriSpacing.sm,
          vertical: DoriSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: DoriRadius.md,
          boxShadow: DoriShadows.of(context).md,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              DoriIcon(icon: icon, color: textColor, size: DoriIconSize.sm),
              const SizedBox(width: DoriSpacing.xxs),
            ],
            Flexible(
              child: DoriText(
                label: message,
                color: textColor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: DoriSpacing.xxs),
              GestureDetector(
                onTap: onDismiss,
                child: DoriIcon(
                  icon: DoriIconData.close,
                  color: textColor,
                  size: DoriIconSize.sm,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns background color, text color, and optional icon based on variant.
  (Color backgroundColor, Color textColor, DoriIconData? icon) _getStyle(
    DoriColorScheme colors,
  ) {
    return switch (variant) {
      DoriToastVariant.neutral => (
        colors.surface.three,
        colors.content.one,
        null,
      ),
      DoriToastVariant.success => (
        colors.feedback.successSoft,
        colors.feedback.successLight,
        DoriIconData.check,
      ),
      DoriToastVariant.error => (
        colors.feedback.errorSoft,
        colors.feedback.errorLight,
        DoriIconData.error,
      ),
      DoriToastVariant.info => (
        colors.feedback.infoSoft,
        colors.feedback.infoLight,
        DoriIconData.info,
      ),
    };
  }
}

/// Duration presets for toast display.
enum DoriToastDuration {
  /// Short duration (2 seconds).
  short(Duration(seconds: 2)),

  /// Normal duration (3 seconds).
  normal(Duration(seconds: 3)),

  /// Long duration (5 seconds).
  long(Duration(seconds: 5));

  const DoriToastDuration(this.duration);

  /// The actual duration value.
  final Duration duration;
}

/// Extension on [BuildContext] for showing toasts.
extension DoriToastExtension on BuildContext {
  /// Shows a toast notification at the bottom of the screen.
  ///
  /// The toast will automatically dismiss after [duration].
  ///
  /// ## Example
  ///
  /// ```dart
  /// context.showDoriToast(
  ///   message: 'Item added to cart',
  ///   variant: DoriToastVariant.success,
  /// );
  /// ```
  void showDoriToast({
    required String message,
    DoriToastVariant variant = DoriToastVariant.neutral,
    DoriToastDuration duration = DoriToastDuration.normal,
  }) {
    final overlay = Overlay.of(this);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        variant: variant,
        duration: duration.duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

/// Internal widget that handles toast positioning and animation.
class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.variant,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final DoriToastVariant variant;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _scheduleAutoDismiss();
  }

  void _scheduleAutoDismiss() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: DoriSpacing.sm,
      right: DoriSpacing.sm,
      bottom: MediaQuery.of(context).padding.bottom + DoriSpacing.lg,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: DoriToast(
                message: widget.message,
                variant: widget.variant,
                onDismiss: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
