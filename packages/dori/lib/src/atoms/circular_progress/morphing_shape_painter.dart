import 'package:flutter/rendering.dart';

import 'shape_generators.dart';

/// Custom painter that draws morphing shapes with rotation.
///
/// This painter is optimized for performance by:
/// - Pre-computing shape points when size changes
/// - Caching computed paths
/// - Using efficient shouldRepaint checks
///
/// The shapes morph through the Material 3 indeterminate loading sequence:
/// SOFT_BURST → COOKIE_9 → PENTAGON → PILL → SUNNY → COOKIE_4 → OVAL → (repeat)
class MorphingShapePainter extends CustomPainter {
  /// Creates a morphing shape painter.
  ///
  /// - [rotation]: Current rotation angle in radians.
  /// - [morphProgress]: Progress through shape cycle (0-[kShapeCount]).
  /// - [color]: Color of the shape.
  /// - [backgroundColor]: Optional background halo color.
  MorphingShapePainter({
    required this.rotation,
    required this.morphProgress,
    required this.color,
    this.backgroundColor,
  });

  /// Current rotation angle in radians.
  final double rotation;

  /// Progress through the morph cycle (0-[kShapeCount]).
  ///
  /// Material 3 sequence (7 shapes):
  /// - 0-1: SOFT_BURST → COOKIE_9
  /// - 1-2: COOKIE_9 → PENTAGON
  /// - 2-3: PENTAGON → PILL
  /// - 3-4: PILL → SUNNY
  /// - 4-5: SUNNY → COOKIE_4
  /// - 5-6: COOKIE_4 → OVAL
  /// - 6-7: OVAL → SOFT_BURST
  final double morphProgress;

  /// Color of the morphing shape.
  final Color color;

  /// Optional background circle color.
  final Color? backgroundColor;

  // Cached values for optimization
  static Size? _cachedSize;
  static Offset? _cachedCenter;
  static double? _cachedRadius;
  static List<List<Offset>>? _cachedShapes;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Update cached shape points if size changed
    _updateCacheIfNeeded(size, center, radius);

    // Draw background halo if enabled
    if (backgroundColor != null) {
      canvas.drawCircle(
        center,
        size.width / 2,
        Paint()
          ..color = backgroundColor!
          ..style = PaintingStyle.fill,
      );
    }

    // Apply rotation transform
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    // Draw the morphing shape
    final path = _createMorphingPath();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  /// Updates the cached shape points if the size has changed.
  void _updateCacheIfNeeded(Size size, Offset center, double radius) {
    if (_cachedSize == size &&
        _cachedCenter == center &&
        _cachedRadius == radius &&
        _cachedShapes != null) {
      return;
    }

    _cachedSize = size;
    _cachedCenter = center;
    _cachedRadius = radius;

    // Generate all 7 shapes in Material 3 sequence order
    _cachedShapes = [
      generateSoftBurstPoints(center, radius), // 0: SOFT_BURST
      generateCookie9Points(center, radius), // 1: COOKIE_9
      generatePentagonPoints(center, radius), // 2: PENTAGON
      generatePillPoints(center, radius), // 3: PILL
      generateSunnyPoints(center, radius), // 4: SUNNY
      generateCookie4Points(center, radius), // 5: COOKIE_4
      generateOvalPoints(center, radius), // 6: OVAL
    ];
  }

  /// Creates the morphing path based on current progress.
  Path _createMorphingPath() {
    final shapeIndex = morphProgress.floor() % kShapeCount;
    final t = morphProgress - morphProgress.floor();

    final currentPoints = _cachedShapes![shapeIndex];
    final nextPoints = _cachedShapes![(shapeIndex + 1) % kShapeCount];

    return interpolateShapesToPath(currentPoints, nextPoints, t);
  }

  @override
  bool shouldRepaint(MorphingShapePainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.morphProgress != morphProgress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
