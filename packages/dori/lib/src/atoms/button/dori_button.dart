import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_radius.dart';
import '../../tokens/dori_spacing.dart';
import '../circular_progress/dori_circular_progress.dart';
import '../icon/dori_icon.dart';
import '../text/dori_text.dart';
import 'dori_button_size.dart';
import 'dori_button_style.dart';
import 'dori_button_variant.dart';

export 'dori_button_size.dart';
export 'dori_button_style.dart';
export 'dori_button_variant.dart';

/// A button component following Dori Design System.
///
/// Buttons allow users to take actions with a single tap.
/// They support different variants for visual hierarchy,
/// multiple sizes, icons, and loading states.
///
/// ## Example
///
/// ```dart
/// // Primary button
/// DoriButton(
///   label: 'Continue',
///   onPressed: () => print('Pressed'),
/// )
///
/// // Secondary button with icon
/// DoriButton(
///   label: 'Add to cart',
///   variant: DoriButtonVariant.secondary,
///   leadingIcon: DoriIconData.check,
///   onPressed: () {},
/// )
///
/// // Loading state
/// DoriButton(
///   label: 'Saving...',
///   isLoading: true,
///   onPressed: () {},
/// )
///
/// // Collapsed (compact) button
/// DoriButton(
///   label: 'Apply',
///   isCollapsed: true,
///   onPressed: () {},
/// )
///
/// // Disabled button
/// DoriButton(
///   label: 'Disabled',
///   onPressed: null,
/// )
/// ```
///
/// ## Accessibility
///
/// The button uses the [label] as semantic label by default.
/// For icon-only buttons or custom accessibility text,
/// provide [semanticLabel].
///
/// {@category Atoms}
class DoriButton extends StatefulWidget {
  /// Creates a Dori button.
  const DoriButton({
    required this.label,
    required this.onPressed,
    this.variant = DoriButtonVariant.primary,
    this.size = DoriButtonSize.md,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.isCollapsed = false,
    this.semanticLabel,
    super.key,
  });

  /// The button label text.
  final String label;

  /// Callback when the button is pressed.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Visual variant of the button.
  ///
  /// Defaults to [DoriButtonVariant.primary].
  final DoriButtonVariant variant;

  /// Size of the button.
  ///
  /// Defaults to [DoriButtonSize.md].
  final DoriButtonSize size;

  /// Optional icon displayed before the label.
  final DoriIconData? leadingIcon;

  /// Optional icon displayed after the label.
  final DoriIconData? trailingIcon;

  /// Whether the button is in loading state.
  ///
  /// When true, displays a loading indicator and disables interaction.
  final bool isLoading;

  /// Whether the button should expand to fill available width.
  ///
  /// Defaults to false.
  final bool isExpanded;

  /// Whether the button should use compact sizing.
  ///
  /// When true, reduces padding for a more compact appearance.
  /// Useful for inline actions or tight layouts.
  /// Defaults to false.
  final bool isCollapsed;

  /// Semantic label for accessibility.
  ///
  /// If null, uses [label].
  final String? semanticLabel;

  @override
  State<DoriButton> createState() => _DoriButtonState();
}

class _DoriButtonState extends State<DoriButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  /// Tracks whether the button is currently pressed for highlight effect.
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onPressed == null;
  bool get _isInteractable => widget.onPressed != null && !widget.isLoading;

  void _handleTapDown(TapDownDetails details) {
    if (!_isInteractable) return;
    _pressController.forward();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _pressController.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final semanticLabel = widget.semanticLabel ?? widget.label;

    final (backgroundColor, foregroundColor, _) = DoriButtonStyle.getColors(
      colors: colors,
      variant: widget.variant,
      isDisabled: _isDisabled,
      isPressed: _isPressed,
    );

    final effectiveHeight = DoriButtonStyle.getEffectiveHeight(
      size: widget.size,
      isCollapsed: widget.isCollapsed,
    );

    final horizontalPadding = DoriButtonStyle.getHorizontalPadding(
      size: widget.size,
      isCollapsed: widget.isCollapsed,
    );

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: _isInteractable,
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _isInteractable ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            height: effectiveHeight,
            constraints: BoxConstraints(minWidth: effectiveHeight),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: DoriRadius.lg,
            ),
            child: widget.isExpanded
                ? Center(child: _buildContent(foregroundColor))
                : IntrinsicWidth(
                    child: Center(child: _buildContent(foregroundColor)),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor) {
    if (widget.isLoading) {
      return DoriCircularProgress(
        size: widget.size.loaderSize,
        color: foregroundColor,
      );
    }

    final iconSize = DoriButtonStyle.getIconSize(widget.size);
    final children = <Widget>[];

    // Leading icon
    if (widget.leadingIcon != null) {
      children.add(
        DoriIcon(
          icon: widget.leadingIcon!,
          size: iconSize,
          color: foregroundColor,
        ),
      );
      children.add(const SizedBox(width: DoriSpacing.xxs));
    }

    // Label
    children.add(
      DoriText(
        label: widget.label,
        variant: widget.size.typography,
        color: foregroundColor,
      ),
    );

    // Trailing icon
    if (widget.trailingIcon != null) {
      children.add(const SizedBox(width: DoriSpacing.xxs));
      children.add(
        DoriIcon(
          icon: widget.trailingIcon!,
          size: iconSize,
          color: foregroundColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
