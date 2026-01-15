import 'dart:async';

import 'package:flutter/material.dart';

import '../../atoms/badge/dori_badge.dart';
import '../../atoms/text/dori_text.dart';
import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_typography.dart';
import 'dori_product_card_size.dart';
import 'product_card_image.dart';

export 'dori_product_card_size.dart';

/// A product card component following Pinterest-style clean design.
///
/// The card displays an image prominently, followed by optional badge,
/// primary text, and secondary text in a clean, minimal layout.
/// The image is the protagonist, making it ideal for visual-first experiences.
///
/// When [onTap] is provided, the card shows a subtle press feedback animation
/// (scale down + slight opacity change) to indicate interactivity.
///
/// ## Example
///
/// ```dart
/// DoriProductCard(
///   imageUrl: 'https://example.com/headphones.jpg',
///   primaryText: 'Wireless Headphones Pro',
///   secondaryText: 'R\$ 1.200',
///   badgeText: 'Audio',
///   onTap: () => navigateToProduct(),
/// )
/// ```
///
/// ## Accessibility
///
/// The card includes comprehensive semantic labels for screen readers,
/// combining all text information.
///
/// {@category Organisms}
class DoriProductCard extends StatefulWidget {
  /// Creates a product card with the specified properties.
  const DoriProductCard({
    required this.imageUrl,
    required this.primaryText,
    this.secondaryText,
    this.badgeText,
    this.size = DoriProductCardSize.md,
    this.onTap,
    this.semanticLabel,
    this.imageBuilder,
    super.key,
  });

  /// URL of the product image.
  final String imageUrl;

  /// Primary text displayed below the image (e.g., product name, title).
  final String primaryText;

  /// Secondary text displayed below primary text (e.g., price, subtitle).
  ///
  /// Displayed with caption style and secondary color.
  final String? secondaryText;

  /// Optional badge text displayed above the primary text.
  ///
  /// When provided, displays as a subtle neutral badge in uppercase.
  final String? badgeText;

  /// Size variant of the card.
  ///
  /// Affects the image aspect ratio. Defaults to [DoriProductCardSize.md].
  final DoriProductCardSize size;

  /// Callback when the card is tapped.
  ///
  /// When provided, the card shows a press feedback animation.
  final VoidCallback? onTap;

  /// Custom semantic label for accessibility.
  ///
  /// If not provided, generates a label combining all text elements.
  final String? semanticLabel;

  /// Optional custom image builder.
  ///
  /// Use this to provide custom loading/error states or image caching.
  /// If not provided, uses default [Image.network] with shimmer loading.
  final Widget Function(BuildContext context, String url)? imageBuilder;

  @override
  State<DoriProductCard> createState() => _DoriProductCardState();
}

class _DoriProductCardState extends State<DoriProductCard>
    with SingleTickerProviderStateMixin {
  /// Scale factor when pressed (noticeable shrink effect).
  static const _pressedScale = 0.95;

  /// Opacity when pressed.
  static const _pressedOpacity = 0.85;

  /// Duration of the press animation.
  static const _animationDuration = Duration(milliseconds: 100);

  /// Minimum duration to hold the pressed state for visual feedback.
  static const _minimumPressDuration = Duration(milliseconds: 80);

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  /// Timer for scheduled release animation.
  Timer? _releaseTimer;

  /// Tracks when the press started to ensure minimum press duration.
  DateTime? _pressStartTime;

  /// Whether we're waiting for minimum press duration before reversing.
  ///
  /// Starts as `false` because there are no pending release operations initially.
  bool _pendingRelease = false;

  bool get _isInteractive => widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: _pressedScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: _pressedOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _releaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isInteractive) {
      _releaseTimer?.cancel();
      _pressStartTime = DateTime.now();
      _pendingRelease = false;
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isInteractive) {
      _scheduleRelease();
    }
  }

  void _handleTapCancel() {
    if (_isInteractive) {
      _scheduleRelease();
    }
  }

  /// Schedules the release animation, ensuring minimum press duration.
  void _scheduleRelease() {
    if (_pressStartTime == null) {
      _controller.reverse();
      return;
    }

    final elapsed = DateTime.now().difference(_pressStartTime!);
    final remaining = _minimumPressDuration - elapsed;

    if (remaining.isNegative || remaining == Duration.zero) {
      // Minimum duration already passed, reverse immediately
      _controller.reverse();
    } else {
      // Wait for remaining time before reversing
      _pendingRelease = true;
      _releaseTimer = Timer(remaining, () {
        if (_pendingRelease && mounted) {
          _controller.reverse();
          _pendingRelease = false;
        }
      });
    }
    _pressStartTime = null;
  }

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image Container
        ProductCardImage(
          imageUrl: widget.imageUrl,
          aspectRatio: widget.size.imageAspectRatio,
          imageBuilder: widget.imageBuilder,
        ),

        SizedBox(height: dori.spacing.xxs),

        // Badge (if provided)
        if (widget.badgeText != null) ...[
          DoriBadge(
            label: widget.badgeText!.toUpperCase(),
            variant: DoriBadgeVariant.neutral,
            size: DoriBadgeSize.sm,
          ),
          SizedBox(height: dori.spacing.xxxs),
        ],

        // Primary Text
        DoriText(
          label: widget.primaryText,
          variant: DoriTypographyVariant.description,
          color: dori.colors.content.one,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Secondary Text (if provided)
        if (widget.secondaryText != null) ...[
          SizedBox(height: dori.spacing.xxxs),
          DoriText(
            label: widget.secondaryText!,
            variant: DoriTypographyVariant.caption,
            color: dori.colors.content.two,
          ),
        ],
      ],
    );

    // Wrap with animation only if interactive and motion is allowed
    if (_isInteractive && !reduceMotion) {
      content = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: content,
      );
    }

    return Semantics(
      label: widget.semanticLabel ?? _buildSemanticLabel(),
      button: _isInteractive,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );
  }

  /// Builds the semantic label for accessibility.
  String _buildSemanticLabel() {
    final parts = <String>[widget.primaryText];
    if (widget.badgeText != null) {
      parts.add(widget.badgeText!);
    }
    if (widget.secondaryText != null) {
      parts.add(widget.secondaryText!);
    }
    return parts.join(', ');
  }
}
