import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dori/src/atoms/circular_progress/morphing_shape_painter.dart';

void main() {
  group('MorphingShapePainter', () {
    group('shouldRepaint', () {
      test('should return true when rotation changes', () {
        // Arrange
        final oldPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
        );
        final newPainter = MorphingShapePainter(
          rotation: 1.5,
          morphProgress: 0,
          color: Colors.blue,
        );

        // Act & Assert
        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('should return true when morphProgress changes', () {
        // Arrange
        final oldPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
        );
        final newPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 1.5,
          color: Colors.blue,
        );

        // Act & Assert
        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('should return true when color changes', () {
        // Arrange
        final oldPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
        );
        final newPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.red,
        );

        // Act & Assert
        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('should return true when backgroundColor changes', () {
        // Arrange
        final oldPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
          backgroundColor: null,
        );
        final newPainter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
          backgroundColor: Colors.white,
        );

        // Act & Assert
        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('should return false when nothing changes', () {
        // Arrange
        final oldPainter = MorphingShapePainter(
          rotation: 1.5,
          morphProgress: 2.0,
          color: Colors.blue,
          backgroundColor: Colors.white,
        );
        final newPainter = MorphingShapePainter(
          rotation: 1.5,
          morphProgress: 2.0,
          color: Colors.blue,
          backgroundColor: Colors.white,
        );

        // Act & Assert
        expect(newPainter.shouldRepaint(oldPainter), isFalse);
      });
    });

    group('paint', () {
      test('should paint without errors', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 100);

        // Act & Assert - should not throw
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('should paint with background', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
          backgroundColor: Colors.white,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 100);

        // Act & Assert - should not throw
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('should handle morphProgress at shape boundaries', () {
        // Test at shape transition points (0, 1, 2, 3)
        for (var progress = 0.0; progress <= 3.0; progress += 1.0) {
          final painter = MorphingShapePainter(
            rotation: 0,
            morphProgress: progress,
            color: Colors.blue,
          );
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          const size = Size(100, 100);

          // Act & Assert
          expect(() => painter.paint(canvas, size), returnsNormally);
        }
      });

      test('should handle full rotation cycle', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 6.28, // 2 * pi (full rotation)
          morphProgress: 0,
          color: Colors.blue,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 100);

        // Act & Assert
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('should handle different sizes', () {
        final sizes = [
          const Size(16, 16),
          const Size(24, 24),
          const Size(32, 32),
          const Size(100, 100),
        ];

        for (final size in sizes) {
          final painter = MorphingShapePainter(
            rotation: 0,
            morphProgress: 1.5,
            color: Colors.blue,
          );
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          // Act & Assert
          expect(() => painter.paint(canvas, size), returnsNormally);
        }
      });

      test('should handle zero size gracefully', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 0,
          color: Colors.blue,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(0, 0);

        // Act & Assert - should not throw
        expect(() => painter.paint(canvas, size), returnsNormally);
      });
    });

    group('morphProgress edge cases', () {
      test('should handle negative morphProgress', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 0,
          morphProgress: -0.5,
          color: Colors.blue,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 100);

        // Act & Assert - should handle gracefully
        expect(() => painter.paint(canvas, size), returnsNormally);
      });

      test('should handle morphProgress greater than 3', () {
        // Arrange
        final painter = MorphingShapePainter(
          rotation: 0,
          morphProgress: 5.5,
          color: Colors.blue,
        );
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 100);

        // Act & Assert - should wrap around (modulo 3)
        expect(() => painter.paint(canvas, size), returnsNormally);
      });
    });
  });
}
