import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';
import 'dori_circular_progress_size.dart';
import 'morphing_shape_painter.dart';

export 'dori_circular_progress_size.dart';

/// A morphing circular progress indicator inspired by Material 3.
///
/// Displays a loading animation that morphs between different shapes:
/// ellipse, pentagon, and starburst. The shapes transition smoothly
/// while rotating continuously.
///
/// ## Example
///
/// ```dart
/// // Basic usage
/// DoriCircularProgress()
///
/// // With custom size
/// DoriCircularProgress(size: DoriCircularProgressSize.lg)
///
/// // With custom color
/// DoriCircularProgress(color: context.dori.colors.feedback.success)
///
/// // With background halo
/// DoriCircularProgress(showBackground: true)
/// ```
///
/// ## Performance
///
/// This widget is optimized for performance:
/// - Uses [RepaintBoundary] to isolate repaints
/// - Caches shape points when size changes
/// - Uses [CustomPaint.isComplex] hint for rasterization
///
/// ## Accessibility
///
/// The widget includes semantic label for screen readers.
/// You can customize it with [semanticLabel].
///
/// {@category Atoms}
class DoriCircularProgress extends StatefulWidget {
  /// Creates a morphing circular progress indicator.
  const DoriCircularProgress({
    this.size = DoriCircularProgressSize.md,
    this.color,
    this.showBackground = false,
    this.semanticLabel = 'Loading',
    super.key,
  });

  /// Size of the indicator.
  ///
  /// Defaults to [DoriCircularProgressSize.md] (24dp).
  final DoriCircularProgressSize size;

  /// Color of the indicator.
  ///
  /// If null, uses the brand.pure color from the current theme.
  final Color? color;

  /// Whether to show a circular background (halo) behind the shape.
  ///
  /// Defaults to false.
  final bool showBackground;

  /// Semantic label for accessibility.
  ///
  /// Defaults to 'Loading'.
  final String semanticLabel;

  @override
  State<DoriCircularProgress> createState() => _DoriCircularProgressState();
}

class _DoriCircularProgressState extends State<DoriCircularProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _morphAnimation;

  /// Animation duration for one complete cycle.
  static const _animationDuration = Duration(milliseconds: 2400);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // Rotation: continuous 360° rotation with linear curve
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Morph: cycles through 3 shapes with easing
    _morphAnimation = Tween<double>(
      begin: 0,
      end: 3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final effectiveColor = widget.color ?? colors.brand.pure;
    final backgroundColor = widget.showBackground ? colors.brand.two : null;

    return Semantics(
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.square(widget.size.size),
              isComplex: true,
              willChange: true,
              painter: MorphingShapePainter(
                rotation: _rotationAnimation.value,
                morphProgress: _morphAnimation.value,
                color: effectiveColor,
                backgroundColor: backgroundColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
