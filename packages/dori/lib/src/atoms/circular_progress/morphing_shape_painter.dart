import 'package:flutter/rendering.dart';

import 'shape_generators.dart';

/// Custom painter that draws morphing shapes with rotation.
///
/// This painter is optimized for performance by:
/// - Pre-computing shape points when size changes
/// - Caching computed paths
/// - Using efficient shouldRepaint checks
///
/// The shapes morph between ellipse → pentagon → starburst cyclically.
class MorphingShapePainter extends CustomPainter {
  /// Creates a morphing shape painter.
  ///
  /// - [rotation]: Current rotation angle in radians.
  /// - [morphProgress]: Progress through shape cycle (0-3).
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

  /// Progress through the morph cycle (0-3).
  ///
  /// - 0-1: ellipse → pentagon
  /// - 1-2: pentagon → starburst
  /// - 2-3: starburst → ellipse
  final double morphProgress;

  /// Color of the morphing shape.
  final Color color;

  /// Optional background circle color.
  final Color? backgroundColor;

  // Cached values for optimization
  static Size? _cachedSize;
  static Offset? _cachedCenter;
  static double? _cachedRadius;
  static List<Offset>? _ellipsePoints;
  static List<Offset>? _pentagonPoints;
  static List<Offset>? _starburstPoints;

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
        _cachedRadius == radius) {
      return;
    }

    _cachedSize = size;
    _cachedCenter = center;
    _cachedRadius = radius;
    _ellipsePoints = generateEllipsePoints(center, radius);
    _pentagonPoints = generatePentagonPoints(center, radius);
    _starburstPoints = generateStarburstPoints(center, radius);
  }

  /// Creates the morphing path based on current progress.
  Path _createMorphingPath() {
    final shapeIndex = morphProgress.floor() % 3;
    final t = morphProgress - morphProgress.floor();

    final currentPoints = _getShapePointsByIndex(shapeIndex);
    final nextPoints = _getShapePointsByIndex((shapeIndex + 1) % 3);

    return interpolateShapesToPath(currentPoints, nextPoints, t);
  }

  /// Returns cached points for the given shape index.
  List<Offset> _getShapePointsByIndex(int index) {
    switch (index) {
      case 0:
        return _ellipsePoints!;
      case 1:
        return _pentagonPoints!;
      case 2:
        return _starburstPoints!;
      default:
        return _ellipsePoints!;
    }
  }

  @override
  bool shouldRepaint(MorphingShapePainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.morphProgress != morphProgress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
