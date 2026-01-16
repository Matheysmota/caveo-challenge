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
      three: Color(
        0xFFCBD5E1,
      ), // Slate 300 - tertiary surface for badges, buttons, and overlays with guaranteed contrast
    ),
    content: DoriContentColors(
      pure: Color(0xFF020617), // Slate 950
      one: Color(0xFF0F172A), // Slate 900
      two: Color(0xFF64748B), // Slate 500
    ),
    feedback: DoriFeedbackColors(
      success: Color(0xFF16A34A), // Green 600
      successSoft: Color(0xFFDCFCE7), // Green 100
      successLight: Color(0xFF16A34A), // Green 600 (same in light mode)
      error: Color(0xFFDC2626), // Red 600
      errorSoft: Color(0xFFFEE2E2), // Red 100
      errorLight: Color(0xFFDC2626), // Red 600 (same in light mode)
      info: Color(0xFF2563EB), // Blue 600
      infoSoft: Color(0xFFDBEAFE), // Blue 100
      infoLight: Color(0xFF2563EB), // Blue 600 (same in light mode)
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
      three: Color(
        0xFF334155,
      ), // Slate 700 - tertiary surface for badges, buttons, and overlays with guaranteed contrast
    ),
    content: DoriContentColors(
      pure: Color(0xFFFFFFFF), // White
      one: Color(0xFFF8FAFC), // Slate 50
      two: Color(0xFF94A3B8), // Slate 400
    ),
    feedback: DoriFeedbackColors(
      success: Color(0xFF16A34A), // Green 600
      successSoft: Color(0xFF14532D), // Green 900
      successLight: Color(0xFF86EFAC), // Green 300
      error: Color(0xFFDC2626), // Red 600
      errorSoft: Color(0xFF7F1D1D), // Red 900
      errorLight: Color(0xFFFCA5A5), // Red 300
      info: Color(0xFF2563EB), // Blue 600
      infoSoft: Color(0xFF1E3A8A), // Blue 900
      infoLight: Color(0xFF93C5FD), // Blue 300
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
/// - **three**: Tertiary surface (higher contrast, badges neutral)
@immutable
class DoriSurfaceColors {
  /// Maximum contrast surface
  final Color pure;

  /// Primary surface (card backgrounds)
  final Color one;

  /// Secondary surface (alternative backgrounds)
  final Color two;

  /// Tertiary surface (higher contrast for badges, chips)
  final Color three;

  const DoriSurfaceColors({
    required this.pure,
    required this.one,
    required this.two,
    required this.three,
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
/// - **success/error/info**: Primary feedback colors (Green/Red/Blue 600)
/// - **successSoft/errorSoft/infoSoft**: Soft backgrounds (100 in light, 900 in dark)
/// - **successLight/errorLight/infoLight**: Light text for dark backgrounds (300 variants)
@immutable
class DoriFeedbackColors {
  /// Success, confirmation (Green 600)
  final Color success;

  /// Success soft background (Green 100 light / Green 900 dark)
  final Color successSoft;

  /// Success light text for dark backgrounds (Green 300)
  final Color successLight;

  /// Error, destructive action (Red 600)
  final Color error;

  /// Error soft background (Red 100 light / Red 900 dark)
  final Color errorSoft;

  /// Error light text for dark backgrounds (Red 300)
  final Color errorLight;

  /// Information, neutral highlight (Blue 600)
  final Color info;

  /// Info soft background (Blue 100 light / Blue 900 dark)
  final Color infoSoft;

  /// Info light text for dark backgrounds (Blue 300)
  final Color infoLight;

  const DoriFeedbackColors({
    required this.success,
    required this.successSoft,
    required this.successLight,
    required this.error,
    required this.errorSoft,
    required this.errorLight,
    required this.info,
    required this.infoSoft,
    required this.infoLight,
  });
}
