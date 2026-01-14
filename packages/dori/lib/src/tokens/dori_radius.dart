import 'package:flutter/material.dart';

/// 🔘 Dori Design System border radius tokens
///
/// Scale of radii for rounded corners.
///
/// ## Scale
/// - **sm**: 8dp — Buttons, inputs, badges
/// - **md**: 12dp — Small cards, chips
/// - **lg**: 16dp — Main cards, modals
///
/// {@category Tokens}
class DoriRadius {
  const DoriRadius._();

  /// 8dp — Buttons, inputs, badges
  static const double smValue = 8;

  /// 12dp — Small cards, chips
  static const double mdValue = 12;

  /// 16dp — Main cards, modals
  static const double lgValue = 16;

  /// Circular BorderRadius of 8dp
  static BorderRadius get sm => BorderRadius.circular(smValue);

  /// Circular BorderRadius of 12dp
  static BorderRadius get md => BorderRadius.circular(mdValue);

  /// Circular BorderRadius of 16dp
  static BorderRadius get lg => BorderRadius.circular(lgValue);
}
