import 'package:flutter/material.dart';

/// 🎨 Dori Design System color tokens
///
/// Colors are organized in semantic categories:
/// - **brand**: Brand identity colors
/// - **surface**: Backgrounds and surfaces
/// - **content**: Texts and icons
/// - **feedback**: Feedback states (success, error, info)
///
/// {@category Tokens}
class DoriColors {
  const DoriColors._();

  /// Color palette for light mode
  static const light = DoriColorScheme(
    brand: DoriBrandColors(
      pure: Color(0xFF4F46E5), // Indigo 600
      one: Color(0xFF312E81), // Indigo 900
      two: Color(0xFFE0E7FF), // Indigo 100
    ),
    surface: DoriSurfaceColors(
      pure: Color(0xFFFFFFFF), // White
      one: Color(0xFFF8FAFC), // Slate 50
      two: Color(0xFFF1F5F9), // Slate 100
    ),
    content: DoriContentColors(
      pure: Color(0xFF020617), // Slate 950
      one: Color(0xFF0F172A), // Slate 900
      two: Color(0xFF64748B), // Slate 500
    ),
    feedback: DoriFeedbackColors(
      success: Color(0xFF16A34A), // Green 600
      error: Color(0xFFDC2626), // Red 600
      info: Color(0xFF2563EB), // Blue 600
    ),
  );

  /// Color palette for dark mode
  static const dark = DoriColorScheme(
    brand: DoriBrandColors(
      pure: Color(0xFF818CF8), // Indigo 400
      one: Color(0xFFA5B4FC), // Indigo 300
      two: Color(0xFF312E81), // Indigo 900
    ),
    surface: DoriSurfaceColors(
      pure: Color(0xFF020617), // Slate 950
      one: Color(0xFF0F172A), // Slate 900
      two: Color(0xFF1E293B), // Slate 800
    ),
    content: DoriContentColors(
      pure: Color(0xFFFFFFFF), // White
      one: Color(0xFFF8FAFC), // Slate 50
      two: Color(0xFF94A3B8), // Slate 400
    ),
    feedback: DoriFeedbackColors(
      success: Color(0xFF16A34A), // Green 600
      error: Color(0xFFDC2626), // Red 600
      info: Color(0xFF2563EB), // Blue 600
    ),
  );
}

/// Complete Dori color scheme
///
/// Contains all color categories: brand, surface, content and feedback.
@immutable
class DoriColorScheme {
  /// Brand identity colors
  final DoriBrandColors brand;

  /// Background and surface colors
  final DoriSurfaceColors surface;

  /// Text and icon colors
  final DoriContentColors content;

  /// Feedback state colors
  final DoriFeedbackColors feedback;

  const DoriColorScheme({
    required this.brand,
    required this.surface,
    required this.content,
    required this.feedback,
  });
}

/// Brand identity colors
///
/// - **pure**: Primary brand color
/// - **one**: Primary variation (darker in light, lighter in dark)
/// - **two**: Secondary variation (lighter in light, darker in dark)
@immutable
class DoriBrandColors {
  /// Pure brand color (Indigo 600 light / Indigo 400 dark)
  final Color pure;

  /// Primary brand variation
  final Color one;

  /// Secondary brand variation
  final Color two;

  const DoriBrandColors({
    required this.pure,
    required this.one,
    required this.two,
  });
}

/// Background and surface colors
///
/// - **pure**: Maximum contrast (white/black)
/// - **one**: Primary surface (cards, main containers)
/// - **two**: Secondary surface (alternative backgrounds)
@immutable
class DoriSurfaceColors {
  /// Maximum contrast surface
  final Color pure;

  /// Primary surface (card backgrounds)
  final Color one;

  /// Secondary surface (alternative backgrounds)
  final Color two;

  const DoriSurfaceColors({
    required this.pure,
    required this.one,
    required this.two,
  });
}

/// Text and icon colors
///
/// - **pure**: Maximum contrast (black/white)
/// - **one**: Primary text (default)
/// - **two**: Secondary text (less emphasis)
@immutable
class DoriContentColors {
  /// Maximum contrast text
  final Color pure;

  /// Primary text (default)
  final Color one;

  /// Secondary text
  final Color two;

  const DoriContentColors({
    required this.pure,
    required this.one,
    required this.two,
  });
}

/// Feedback state colors
///
/// Used to communicate states to the user:
/// - **success**: Successful actions, confirmations
/// - **error**: Errors, destructive actions, alerts
/// - **info**: Neutral information, highlights
@immutable
class DoriFeedbackColors {
  /// Success, confirmation (Green 600)
  final Color success;

  /// Error, destructive action (Red 600)
  final Color error;

  /// Information, neutral highlight (Blue 600)
  final Color info;

  const DoriFeedbackColors({
    required this.success,
    required this.error,
    required this.info,
  });
}
