import 'dart:math' as math;
import 'dart:ui';

/// Number of points used for shape interpolation.
///
/// Using a consistent number simplifies morphing between shapes.
/// Higher values produce smoother curves but cost more performance.
const int kShapePointCount = 48;

/// Number of shapes in the Material 3 loading indicator sequence.
///
/// The sequence is: SOFT_BURST → COOKIE_9 → PENTAGON → PILL →
/// SUNNY → COOKIE_4 → OVAL → (repeat)
const int kShapeCount = 7;

// =============================================================================
// MATERIAL 3 SHAPE GENERATORS
// Based on: material-components-android/MaterialShapes.java
// Sequence from: LoadingIndicatorDrawingDelegate.INDETERMINATE_SHAPES
// =============================================================================

/// Index constants for shape lookup.
const int kShapeSoftBurst = 0;
const int kShapeCookie9 = 1;
const int kShapePentagon = 2;
const int kShapePill = 3;
const int kShapeSunny = 4;
const int kShapeCookie4 = 5;
const int kShapeOval = 6;

/// Generates points for SOFT_BURST shape (10-pointed soft star).
///
/// A gentle starburst with 10 soft points radiating outward.
/// Material 3 uses this as the first shape in the loading sequence.
List<Offset> generateSoftBurstPoints(Offset center, double radius) {
  const spokes = 10;
  const innerRadiusRatio = 0.7; // More subtle than regular burst
  final innerRadius = radius * innerRadiusRatio;
  const startAngle = -math.pi / 2;

  return _generateRoundedStarPoints(
    center: center,
    outerRadius: radius,
    innerRadius: innerRadius,
    spokes: spokes,
    startAngle: startAngle,
    cornerRounding: 0.3,
  );
}

/// Generates points for COOKIE_9 shape (9-pointed rounded star).
///
/// A star with 9 points and rounded corners (corner rounding 0.5).
/// Creates a softer, more organic look than a sharp star.
List<Offset> generateCookie9Points(Offset center, double radius) {
  const spokes = 9;
  const innerRadiusRatio = 0.75;
  final innerRadius = radius * innerRadiusRatio;
  const startAngle = -math.pi / 2;

  return _generateRoundedStarPoints(
    center: center,
    outerRadius: radius,
    innerRadius: innerRadius,
    spokes: spokes,
    startAngle: startAngle,
    cornerRounding: 0.5,
  );
}

/// Generates points for PENTAGON shape (5-sided rounded polygon).
///
/// A regular pentagon with rounded corners.
/// Uses corner rounding of approximately 0.17.
List<Offset> generatePentagonPoints(Offset center, double radius) {
  const sides = 5;
  const cornerRounding = 0.17;
  const startAngle = -math.pi / 2;

  return _generateRoundedPolygonPoints(
    center: center,
    radius: radius,
    sides: sides,
    startAngle: startAngle,
    cornerRounding: cornerRounding,
  );
}

/// Generates points for PILL shape (elongated capsule).
///
/// A horizontal pill/capsule shape, wider than tall.
/// Resembles a medicine pill or stadium shape.
List<Offset> generatePillPoints(Offset center, double radius) {
  const scaleX = 1.0;
  const scaleY = 0.5; // Half height creates pill aspect ratio
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

/// Generates points for SUNNY shape (8-pointed sun).
///
/// A sun shape with 8 subtle rays, using corner rounding of 0.15.
/// Inner radius is 0.8 of outer for subtle depth.
List<Offset> generateSunnyPoints(Offset center, double radius) {
  const spokes = 8;
  const innerRadiusRatio = 0.8;
  final innerRadius = radius * innerRadiusRatio;
  const startAngle = -math.pi / 2;

  return _generateRoundedStarPoints(
    center: center,
    outerRadius: radius,
    innerRadius: innerRadius,
    spokes: spokes,
    startAngle: startAngle,
    cornerRounding: 0.15,
  );
}

/// Generates points for COOKIE_4 shape (4-pointed rounded star).
///
/// A quatrefoil-like shape with 4 rounded lobes.
/// Corner rounding approximately 0.25.
List<Offset> generateCookie4Points(Offset center, double radius) {
  const spokes = 4;
  const innerRadiusRatio = 0.65;
  final innerRadius = radius * innerRadiusRatio;
  const startAngle = -math.pi / 4; // 45 degrees for X orientation

  return _generateRoundedStarPoints(
    center: center,
    outerRadius: radius,
    innerRadius: innerRadius,
    spokes: spokes,
    startAngle: startAngle,
    cornerRounding: 0.5,
  );
}

/// Generates points for OVAL shape (horizontal ellipse).
///
/// An oval/ellipse flattened vertically (scaleY: 0.64).
/// This is the final shape before the sequence repeats.
List<Offset> generateOvalPoints(Offset center, double radius) {
  const scaleX = 1.0;
  const scaleY = 0.64; // Material 3 uses 0.64 scale
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

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// Generates rounded star/burst shape points with smooth corners.
///
/// Creates alternating outer/inner points with bezier-smoothed transitions.
List<Offset> _generateRoundedStarPoints({
  required Offset center,
  required double outerRadius,
  required double innerRadius,
  required int spokes,
  required double startAngle,
  required double cornerRounding,
}) {
  const twoPi = 2 * math.pi;
  final anglePerSpoke = twoPi / spokes;
  final halfAngle = anglePerSpoke / 2;

  final rawPoints = <Offset>[];
  final pointsPerSpoke = kShapePointCount ~/ spokes;

  for (var spoke = 0; spoke < spokes; spoke++) {
    final outerAngle = startAngle + spoke * anglePerSpoke;
    final innerAngle1 = outerAngle - halfAngle;
    final innerAngle2 = outerAngle + halfAngle;

    final outerPoint = Offset(
      center.dx + outerRadius * math.cos(outerAngle),
      center.dy + outerRadius * math.sin(outerAngle),
    );
    final innerPoint1 = Offset(
      center.dx + innerRadius * math.cos(innerAngle1),
      center.dy + innerRadius * math.sin(innerAngle1),
    );
    final innerPoint2 = Offset(
      center.dx + innerRadius * math.cos(innerAngle2),
      center.dy + innerRadius * math.sin(innerAngle2),
    );

    // Generate points with bezier rounding
    final halfPoints = pointsPerSpoke ~/ 2;

    // First half: inner1 → outer (with rounding)
    for (var i = 0; i < halfPoints; i++) {
      final t = i / halfPoints;
      final smoothT = _smoothstep(t, cornerRounding);
      rawPoints.add(_lerp(innerPoint1, outerPoint, smoothT));
    }

    // Second half: outer → inner2 (with rounding)
    for (var i = 0; i < halfPoints; i++) {
      final t = i / halfPoints;
      final smoothT = _smoothstep(t, cornerRounding);
      rawPoints.add(_lerp(outerPoint, innerPoint2, smoothT));
    }
  }

  return _normalizeToCount(rawPoints, kShapePointCount);
}

/// Generates rounded polygon points (e.g., pentagon with soft corners).
List<Offset> _generateRoundedPolygonPoints({
  required Offset center,
  required double radius,
  required int sides,
  required double startAngle,
  required double cornerRounding,
}) {
  const twoPi = 2 * math.pi;
  final anglePerSide = twoPi / sides;

  final rawPoints = <Offset>[];
  final pointsPerSide = kShapePointCount ~/ sides;

  for (var side = 0; side < sides; side++) {
    final angle1 = startAngle + side * anglePerSide;
    final angle2 = startAngle + (side + 1) * anglePerSide;
    final midAngle = (angle1 + angle2) / 2;

    final vertex1 = Offset(
      center.dx + radius * math.cos(angle1),
      center.dy + radius * math.sin(angle1),
    );
    final vertex2 = Offset(
      center.dx + radius * math.cos(angle2),
      center.dy + radius * math.sin(angle2),
    );
    final midPoint = Offset(
      center.dx + radius * math.cos(midAngle),
      center.dy + radius * math.sin(midAngle),
    );

    // Generate bezier-curved edge with corner rounding
    for (var i = 0; i < pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final p = _quadraticBezier(vertex1, midPoint, vertex2, t, cornerRounding);
      rawPoints.add(p);
    }
  }

  return _normalizeToCount(rawPoints, kShapePointCount);
}

/// Linear interpolation between two offsets.
Offset _lerp(Offset a, Offset b, double t) {
  return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
}

/// Smoothstep function for corner rounding.
double _smoothstep(double t, double rounding) {
  // Apply smoothstep at edges based on rounding amount
  if (rounding <= 0) return t;

  final edgeWidth = rounding * 0.5;
  if (t < edgeWidth) {
    final x = t / edgeWidth;
    return edgeWidth * (x * x * (3 - 2 * x));
  } else if (t > 1 - edgeWidth) {
    final x = (t - (1 - edgeWidth)) / edgeWidth;
    return (1 - edgeWidth) + edgeWidth * (x * x * (3 - 2 * x));
  }
  return t;
}

/// Quadratic bezier interpolation with corner rounding.
Offset _quadraticBezier(
  Offset p0,
  Offset p1,
  Offset p2,
  double t,
  double rounding,
) {
  // Apply rounding to control point influence
  final controlInfluence = 1.0 - (rounding * 0.5);
  final adjustedP1 = Offset(
    p0.dx + (p1.dx - p0.dx) * controlInfluence + (p2.dx - p0.dx) * 0.5,
    p0.dy + (p1.dy - p0.dy) * controlInfluence + (p2.dy - p0.dy) * 0.5,
  );

  final oneMinusT = 1 - t;
  return Offset(
    oneMinusT * oneMinusT * p0.dx +
        2 * oneMinusT * t * adjustedP1.dx +
        t * t * p2.dx,
    oneMinusT * oneMinusT * p0.dy +
        2 * oneMinusT * t * adjustedP1.dy +
        t * t * p2.dy,
  );
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
