import 'package:flutter/material.dart';

import '../../theme/dori_theme.barrel.dart';

/// A shimmer loading placeholder widget.
///
/// Displays an animated gradient that moves horizontally to indicate
/// loading state. Uses semantic colors from the Dori theme.
///
/// ## Performance Considerations
///
/// The shimmer uses a single [AnimationController] with `repeat()`.
/// When not visible, consider removing from the widget tree to stop the animation.
///
/// ## Example
///
/// ```dart
/// // As a loading placeholder
/// if (isLoading)
///   DoriShimmer()
/// else
///   ActualContent()
/// ```
///
/// {@category Atoms}
class DoriShimmer extends StatefulWidget {
  /// Creates a shimmer loading placeholder.
  const DoriShimmer({
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  /// Duration of one complete shimmer cycle.
  ///
  /// Defaults to 1500ms for a smooth, non-distracting effect.
  final Duration duration;

  @override
  State<DoriShimmer> createState() => _DoriShimmerState();
}

class _DoriShimmerState extends State<DoriShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                dori.colors.surface.two,
                dori.colors.surface.three,
                dori.colors.surface.two,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
