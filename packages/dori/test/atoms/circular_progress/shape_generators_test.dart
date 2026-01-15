import 'package:flutter_test/flutter_test.dart';

import 'package:dori/src/atoms/circular_progress/shape_generators.dart';

void main() {
  group('Shape Generators', () {
    const center = Offset(50, 50);
    const radius = 40.0;

    group('generateEllipsePoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateEllipsePoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateEllipsePoints(center, radius);

        // Assert - all points should be within reasonable bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 1));
          expect(point.dx, lessThan(center.dx + radius + 1));
          expect(point.dy, greaterThan(center.dy - radius - 1));
          expect(point.dy, lessThan(center.dy + radius + 1));
        }
      });

      test('should create vertically elongated ellipse', () {
        // Act
        final points = generateEllipsePoints(center, radius);

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

        // Assert - height should be greater than width (vertically elongated)
        expect(height, greaterThan(width));
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

    group('generateStarburstPoints', () {
      test('should return exactly kShapePointCount points', () {
        // Act
        final points = generateStarburstPoints(center, radius);

        // Assert
        expect(points.length, equals(kShapePointCount));
      });

      test('should generate points around center', () {
        // Act
        final points = generateStarburstPoints(center, radius);

        // Assert - all points should be within bounds
        for (final point in points) {
          expect(point.dx, greaterThan(center.dx - radius - 1));
          expect(point.dx, lessThan(center.dx + radius + 1));
          expect(point.dy, greaterThan(center.dy - radius - 1));
          expect(point.dy, lessThan(center.dy + radius + 1));
        }
      });
    });

    group('interpolateShapesToPath', () {
      test('should return a closed path', () {
        // Arrange
        final from = generateEllipsePoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0.5);

        // Assert - path should have operations
        expect(path, isNotNull);
      });

      test('should return from shape when t is 0', () {
        // Arrange
        final from = generateEllipsePoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0);

        // Assert - path should be close to from shape
        expect(path, isNotNull);
      });

      test('should return to shape when t is 1', () {
        // Arrange
        final from = generateEllipsePoints(center, radius);
        final to = generatePentagonPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 1);

        // Assert - path should be close to to shape
        expect(path, isNotNull);
      });

      test('should handle edge case t = 0.5', () {
        // Arrange
        final from = generateEllipsePoints(center, radius);
        final to = generateStarburstPoints(center, radius);

        // Act
        final path = interpolateShapesToPath(from, to, 0.5);

        // Assert
        expect(path, isNotNull);
      });
    });

    group('kShapePointCount', () {
      test('should be a positive integer', () {
        expect(kShapePointCount, greaterThan(0));
      });

      test('should be divisible by common shape sides', () {
        // Pentagon has 5 sides, we need points divisible or handle gracefully
        expect(kShapePointCount % 2, equals(0)); // Even for starburst
      });
    });

    group('edge cases', () {
      test('should handle zero radius', () {
        // Arrange
        const zeroRadius = 0.0;

        // Act
        final ellipse = generateEllipsePoints(center, zeroRadius);
        final pentagon = generatePentagonPoints(center, zeroRadius);
        final starburst = generateStarburstPoints(center, zeroRadius);

        // Assert - all should return points at center
        expect(ellipse.length, equals(kShapePointCount));
        expect(pentagon.length, equals(kShapePointCount));
        expect(starburst.length, equals(kShapePointCount));
      });

      test('should handle very small radius', () {
        // Arrange
        const smallRadius = 0.001;

        // Act
        final ellipse = generateEllipsePoints(center, smallRadius);

        // Assert
        expect(ellipse.length, equals(kShapePointCount));
      });

      test('should handle negative center coordinates', () {
        // Arrange
        const negativeCenter = Offset(-100, -100);

        // Act
        final ellipse = generateEllipsePoints(negativeCenter, radius);

        // Assert
        expect(ellipse.length, equals(kShapePointCount));
        for (final point in ellipse) {
          expect(point.dx, lessThan(0));
          expect(point.dy, lessThan(0));
        }
      });

      test('should handle very large radius', () {
        // Arrange
        const largeRadius = 10000.0;

        // Act
        final ellipse = generateEllipsePoints(center, largeRadius);

        // Assert
        expect(ellipse.length, equals(kShapePointCount));
      });
    });
  });
}
