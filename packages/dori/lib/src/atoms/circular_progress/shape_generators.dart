import 'dart:math' as math;
import 'dart:ui';

/// Number of points used for shape interpolation.
///
/// Using a consistent number simplifies morphing between shapes.
const int kShapePointCount = 24;

/// Generates normalized points for an ellipse shape.
///
/// The ellipse is vertically elongated (scaleX: 0.65, scaleY: 1.0).
/// Returns exactly [kShapePointCount] points.
List<Offset> generateEllipsePoints(Offset center, double radius) {
  const scaleX = 0.65;
  const scaleY = 1.0;
  const twoPi = 2 * math.pi;
  final angleStep = twoPi / kShapePointCount;

  return List.generate(kShapePointCount, (i) {
    final angle = i * angleStep;
    return Offset(
      center.dx + radius * scaleX * math.cos(angle),
      center.dy + radius * scaleY * math.sin(angle),
    );
  });
}

/// Generates normalized points for a rounded pentagon shape.
///
/// Uses quadratic bezier interpolation for rounded corners.
/// Returns exactly [kShapePointCount] points.
List<Offset> generatePentagonPoints(Offset center, double radius) {
  const sides = 5;
  const cornerRadius = 0.2;
  final innerRadius = radius * (1 - cornerRadius);
  const startAngle = -math.pi / 2; // Start from top
  const twoPi = 2 * math.pi;

  final result = <Offset>[];
  final pointsPerSide = kShapePointCount ~/ sides;

  for (var side = 0; side < sides; side++) {
    final angle1 = startAngle + (side / sides) * twoPi;
    final angle2 = startAngle + ((side + 1) / sides) * twoPi;
    final midAngle = (angle1 + angle2) / 2;

    final p1 = Offset(
      center.dx + innerRadius * math.cos(angle1),
      center.dy + innerRadius * math.sin(angle1),
    );
    final p2 = Offset(
      center.dx + innerRadius * math.cos(angle2),
      center.dy + innerRadius * math.sin(angle2),
    );
    final outerPoint = Offset(
      center.dx + radius * math.cos(midAngle),
      center.dy + radius * math.sin(midAngle),
    );

    // Generate points along quadratic bezier curve
    for (var i = 0; i < pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final oneMinusT = 1 - t;
      result.add(
        Offset(
          oneMinusT * oneMinusT * p1.dx +
              2 * oneMinusT * t * outerPoint.dx +
              t * t * p2.dx,
          oneMinusT * oneMinusT * p1.dy +
              2 * oneMinusT * t * outerPoint.dy +
              t * t * p2.dy,
        ),
      );
    }
  }

  // Ensure we have exactly kShapePointCount points
  return _normalizeToCount(result, kShapePointCount);
}

/// Generates normalized points for a starburst/gear shape.
///
/// Creates alternating outer and inner points for a star effect.
/// Returns exactly [kShapePointCount] points.
List<Offset> generateStarburstPoints(Offset center, double radius) {
  const spokes = 12;
  const innerRadiusRatio = 0.6;
  final innerRadius = radius * innerRadiusRatio;
  const startAngle = -math.pi / 2;
  const twoPi = 2 * math.pi;

  final rawPoints = <Offset>[];
  final totalRawPoints = spokes * 2;

  for (var i = 0; i < totalRawPoints; i++) {
    final angle = startAngle + (i / totalRawPoints) * twoPi;
    final r = i.isEven ? radius : innerRadius;
    rawPoints.add(
      Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle)),
    );
  }

  return _normalizeToCount(rawPoints, kShapePointCount);
}

/// Normalizes a list of points to a specific count by resampling.
List<Offset> _normalizeToCount(List<Offset> points, int targetCount) {
  if (points.length == targetCount) return points;

  final result = <Offset>[];
  final ratio = points.length / targetCount;

  for (var i = 0; i < targetCount; i++) {
    final exactIndex = i * ratio;
    final index = exactIndex.floor() % points.length;
    final nextIndex = (index + 1) % points.length;
    final localT = exactIndex - index;

    final p1 = points[index];
    final p2 = points[nextIndex];
    result.add(
      Offset(
        p1.dx + (p2.dx - p1.dx) * localT,
        p1.dy + (p2.dy - p1.dy) * localT,
      ),
    );
  }
  return result;
}

/// Interpolates between two lists of points with easing.
///
/// Both lists must have the same length ([kShapePointCount]).
/// Returns a [Path] representing the interpolated shape.
Path interpolateShapesToPath(List<Offset> from, List<Offset> to, double t) {
  final easedT = _easeInOutCubic(t);
  final path = Path();

  for (var i = 0; i < from.length; i++) {
    final x = from[i].dx + (to[i].dx - from[i].dx) * easedT;
    final y = from[i].dy + (to[i].dy - from[i].dy) * easedT;

    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }

  path.close();
  return path;
}

/// Cubic ease-in-out function for smooth transitions.
double _easeInOutCubic(double t) {
  return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
}
