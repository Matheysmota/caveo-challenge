import 'package:flutter/material.dart';

/// Extension to convert Color to hex string
extension ColorToHex on Color {
  /// Converts color to hex string format (#RRGGBB)
  ///
  /// ```dart
  /// Colors.blue.toHex() // Returns '#2196F3'
  /// ```
  String toHex() {
    return '#${toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
