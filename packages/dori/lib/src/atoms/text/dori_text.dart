import 'package:flutter/material.dart';

import '../../tokens/dori_typography.dart';

/// A text widget that uses Dori typography tokens.
///
/// Encapsulates [Text] with Dori's standardized typography variants,
/// ensuring consistent text styling across the app.
///
/// ## Example
///
/// ```dart
/// // Basic usage (defaults to description style)
/// DoriText(label: 'Hello, World!')
///
/// // With typography variant
/// DoriText(
///   label: 'Products',
///   variant: DoriTypographyVariant.title5,
/// )
///
/// // With custom color
/// DoriText(
///   label: 'Subtitle',
///   variant: DoriTypographyVariant.caption,
///   color: context.dori.colors.content.two,
/// )
///
/// // With overflow handling
/// DoriText(
///   label: 'Very long text that might overflow...',
///   maxLines: 2,
///   overflow: TextOverflow.ellipsis,
/// )
/// ```
///
/// {@category Atoms}
class DoriText extends StatelessWidget {
  /// Creates a Dori text widget.
  ///
  /// The [label] parameter is required and specifies the text to display.
  const DoriText({
    required this.label,
    this.variant = DoriTypographyVariant.description,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    super.key,
  });

  /// The text to display.
  final String label;

  /// Typography variant to use.
  ///
  /// Defaults to [DoriTypographyVariant.description] (14px Medium).
  ///
  /// Available variants:
  /// - [DoriTypographyVariant.title5]: 24px ExtraBold
  /// - [DoriTypographyVariant.description]: 14px Medium
  /// - [DoriTypographyVariant.descriptionBold]: 14px Bold
  /// - [DoriTypographyVariant.caption]: 12px Medium
  /// - [DoriTypographyVariant.captionBold]: 12px Bold
  final DoriTypographyVariant variant;

  /// Text color.
  ///
  /// If null, the color from the typography style is used.
  /// Typically you should use `context.dori.colors.content.one` or similar.
  final Color? color;

  /// Maximum number of lines for the text.
  ///
  /// If null, the text will wrap to as many lines as needed.
  final int? maxLines;

  /// How to handle text overflow.
  ///
  /// Common values:
  /// - [TextOverflow.ellipsis]: Show "..." at the end
  /// - [TextOverflow.fade]: Fade out the text
  /// - [TextOverflow.clip]: Clip the text
  final TextOverflow? overflow;

  /// How to align the text horizontally.
  ///
  /// Defaults to the ambient [DefaultTextStyle]'s alignment.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: variant.style.copyWith(color: color),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
