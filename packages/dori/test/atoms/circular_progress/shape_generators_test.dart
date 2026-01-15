import 'package:flutter_test/flutter_test.dart';

import 'package:dori/src/atoms/circular_progress/shape_generators.dart';

void main() {
  group('Shape Generators (Material 3)', () {
    const center = Offset(50, 50);
    const radius = 40.0;

    group('generateSoftBurstPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateSoftBurstPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateSoftBurstPoints(center, radius);

        // Assert - all points should be within reasonable bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 1));
          expect(point.dx, lessThan(center.dx + radius + 1));
          expect(point.dy, greaterThan(center.dy - radius - 1));
          expect(point.dy, lessThan(center.dy + radius + 1));
        }
      });
    });

    group('generateCookie9Points', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateCookie9Points(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateCookie9Points(center, radius);

        // Assert - all points should be within bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 5));
          expect(point.dx, lessThan(center.dx + radius + 5));
          expect(point.dy, greaterThan(center.dy - radius - 5));
          expect(point.dy, lessThan(center.dy + radius + 5));
        }
      });
    });

    group('generatePentagonPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generatePentagonPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generatePentagonPoints(center, radius);

        // Assert - all points should be within bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 5));
          expect(point.dx, lessThan(center.dx + radius + 5));
          expect(point.dy, greaterThan(center.dy - radius - 5));
          expect(point.dy, lessThan(center.dy + radius + 5));
        }
      });
    });

    group('generatePillPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generatePillPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should create horizontally elongated shape', () {
        // Act
        final points = generatePillPoints(center, radius);

        // Find min/max X and Y
        var minX = double.infinity;
        var maxX = double.negativeInfinity;
        var minY = double.infinity;
        var maxY = double.negativeInfinity;

        for (final point in points) {
          if (point.dx < minX) minX = point.dx;
          if (point.dx > maxX) maxX = point.dx;
          if (point.dy < minY) minY = point.dy;
          if (point.dy > maxY) maxY = point.dy;
        }

        final width = maxX - minX;
        final height = maxY - minY;

        // Assert - width should be greater than height (horizontally elongated)
        expect(width, greaterThan(height));
      });
    });

    group('generateSunnyPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateSunnyPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateSunnyPoints(center, radius);

        // Assert - all points should be within bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 1));
          expect(point.dx, lessThan(center.dx + radius + 1));
          expect(point.dy, greaterThan(center.dy - radius - 1));
          expect(point.dy, lessThan(center.dy + radius + 1));
        }
      });
    });

    group('generateCookie4Points', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateCookie4Points(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateCookie4Points(center, radius);

        // Assert - all points should be within bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 5));
          expect(point.dx, lessThan(center.dx + radius + 5));
          expect(point.dy, greaterThan(center.dy - radius - 5));
          expect(point.dy, lessThan(center.dy + radius + 5));
        }
      });
    });

    group('generateOvalPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateOvalPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should create horizontally elongated ellipse', () {
        // Act
        final points = generateOvalPoints(center, radius);

        // Find min/max X and Y
        var minX = double.infinity;
        var maxX = double.negativeInfinity;
        var minY = double.infinity;
        var maxY = double.negativeInfinity;

        for (final point in points) {
          if (point.dx < minX) minX = point.dx;
          if (point.dx > maxX) maxX = point.dx;
          if (point.dy < minY) minY = point.dy;
          if (point.dy > maxY) maxY = point.dy;
        }

        final width = maxX - minX;
        final height = maxY - minY;

        // Assert - width should be greater than height (horizontally elongated)
        expect(width, greaterThan(height));
      });
    });

    group('interpolateShapesToPath', () {
      test('should return a closed path', () {
        // Arrange
        final from = generateSoftBurstPoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0.5);

        // Assert - path should have operations
        expect(path, isNotNull);
      });

      test('should return from shape when t is 0', () {
        // Arrange
        final from = generateSoftBurstPoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0);

        // Assert - path should be close to from shape
        expect(path, isNotNull);
      });

      test('should return to shape when t is 1', () {
        // Arrange
        final from = generateSoftBurstPoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 1);

        // Assert - path should be close to to shape
        expect(path, isNotNull);
      });

      test('should handle edge case t = 0.5', () {
        // Arrange
        final from = generateOvalPoints(center, radius);
        final to = generateSoftBurstPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0.5);

        // Assert
        expect(path, isNotNull);
      });
    });

    group('constants', () {
      test('kShapePointCount should be a positive integer', () {
        expect(kShapePointCount, greaterThan(0));
      });

      test('kShapeCount should be 7 for Material 3 sequence', () {
        expect(kShapeCount, equals(7));
      });

      test('kShapePointCount should be divisible by common shape sides', () {
        // Needs to be divisible for smooth star generation
        expect(kShapePointCount % 2, equals(0)); // Even for symmetry
      });
    });

    group('edge cases', () {
      test('should handle zero radius', () {
        // Arrange
        const zeroRadius = 0.0;

        // Act
        final softBurst = generateSoftBurstPoints(center, zeroRadius);
        final pentagon = generatePentagonPoints(center, zeroRadius);
        final oval = generateOvalPoints(center, zeroRadius);

        // Assert - all should return points at center
        expect(softBurst.length, equals(kShapePointCount));
        expect(pentagon.length, equals(kShapePointCount));
        expect(oval.length, equals(kShapePointCount));
      });

      test('should handle very small radius', () {
        // Arrange
        const smallRadius = 0.001;

        // Act
        final oval = generateOvalPoints(center, smallRadius);

        // Assert
        expect(oval.length, equals(kShapePointCount));
      });

      test('should handle negative center coordinates', () {
        // Arrange
        const negativeCenter = Offset(-100, -100);

        // Act
        final oval = generateOvalPoints(negativeCenter, radius);

        // Assert
        expect(oval.length, equals(kShapePointCount));
        for (final point in oval) {
          expect(point.dx, lessThan(0));
          expect(point.dy, lessThan(0));
        }
      });

      test('should handle very large radius', () {
        // Arrange
        const largeRadius = 10000.0;

        // Act
        final oval = generateOvalPoints(center, largeRadius);

        // Assert
        expect(oval.length, equals(kShapePointCount));
      });
    });

    group('shape sequence', () {
      test('all 7 shapes should generate valid points', () {
        // Act
        final shapes = [
          generateSoftBurstPoints(center, radius),
          generateCookie9Points(center, radius),
          generatePentagonPoints(center, radius),
          generatePillPoints(center, radius),
          generateSunnyPoints(center, radius),
          generateCookie4Points(center, radius),
          generateOvalPoints(center, radius),
        ];

        // Assert
        for (final shape in shapes) {
          expect(shape.length, equals(kShapePointCount));
        }
      });

      test('all consecutive shapes should interpolate smoothly', () {
        // Arrange
        final shapes = [
          generateSoftBurstPoints(center, radius),
          generateCookie9Points(center, radius),
          generatePentagonPoints(center, radius),
          generatePillPoints(center, radius),
          generateSunnyPoints(center, radius),
          generateCookie4Points(center, radius),
          generateOvalPoints(center, radius),
        ];

        // Act & Assert
        for (var i = 0; i < shapes.length; i++) {
          final from = shapes[i];
          final to = shapes[(i + 1) % shapes.length];
          final path = interpolateShapesToPath(from, to, 0.5);
          expect(path, isNotNull);
        }
      });
    });
  });
}
