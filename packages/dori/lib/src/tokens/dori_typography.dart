import 'package:flutter/material.dart';

/// 🔤 Dori Design System typography tokens
///
/// Typography variants based on Plus Jakarta Sans font.
///
/// ## Variants
/// - **title5**: 24px ExtraBold (800) — Main titles
/// - **description**: 14px Medium (500) — Default text
/// - **descriptionBold**: 14px Bold (700) — Emphasized default text
/// - **caption**: 12px Medium (500) — Small text, labels
/// - **captionBold**: 12px Bold (700) — Emphasized small text
///
/// {@category Tokens}
class DoriTypography {
  const DoriTypography._();

  /// Dori default font family
  static const String fontFamily = 'PlusJakartaSans';

  /// Package containing the font (null if in main app)
  ///
  /// When the font is in the dori package, use 'dori'.
  /// When the font is in the main app, leave null.
  static const String? fontPackage = 'dori';

  // ─────────────────────────────────────────────────────────────────────────
  // Font Sizes
  // ─────────────────────────────────────────────────────────────────────────

  /// 24px — Title size
  static const double sizeTitle = 24;

  /// 14px — Description size
  static const double sizeDescription = 14;

  /// 12px — Caption size
  static const double sizeCaption = 12;

  // ─────────────────────────────────────────────────────────────────────────
  // Font Weights
  // ─────────────────────────────────────────────────────────────────────────

  /// Medium (500)
  static const FontWeight weightMedium = FontWeight.w500;

  /// Bold (700)
  static const FontWeight weightBold = FontWeight.w700;

  /// ExtraBold (800)
  static const FontWeight weightExtraBold = FontWeight.w800;

  // ─────────────────────────────────────────────────────────────────────────
  // TextStyles
  // ─────────────────────────────────────────────────────────────────────────

  /// 24px ExtraBold — Main titles
  static TextStyle get title5 => const TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: sizeTitle,
    fontWeight: weightExtraBold,
    height: 1.3,
  );

  /// 14px Medium — Default text
  static TextStyle get description => const TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: sizeDescription,
    fontWeight: weightMedium,
    height: 1.5,
  );

  /// 14px Bold — Emphasized default text
  static TextStyle get descriptionBold => const TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: sizeDescription,
    fontWeight: weightBold,
    height: 1.5,
  );

  /// 12px Medium — Small text, labels
  static TextStyle get caption => const TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: sizeCaption,
    fontWeight: weightMedium,
    height: 1.4,
  );

  /// 12px Bold — Emphasized small text
  static TextStyle get captionBold => const TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: sizeCaption,
    fontWeight: weightBold,
    height: 1.4,
  );
}

/// Enum for easy typography variant selection
enum DoriTypographyVariant {
  /// 24px ExtraBold — Main titles
  title5,

  /// 14px Medium — Default text
  description,

  /// 14px Bold — Emphasized default text
  descriptionBold,

  /// 12px Medium — Small text, labels
  caption,

  /// 12px Bold — Emphasized small text
  captionBold,
}

/// Extension to get TextStyle from enum
extension DoriTypographyVariantX on DoriTypographyVariant {
  /// Returns the TextStyle corresponding to the variant
  TextStyle get style {
    switch (this) {
      case DoriTypographyVariant.title5:
        return DoriTypography.title5;
      case DoriTypographyVariant.description:
        return DoriTypography.description;
      case DoriTypographyVariant.descriptionBold:
        return DoriTypography.descriptionBold;
      case DoriTypographyVariant.caption:
        return DoriTypography.caption;
      case DoriTypographyVariant.captionBold:
        return DoriTypography.captionBold;
    }
  }
}
