import 'package:flutter/material.dart';

/// 🔘 Dori Design System border radius tokens
///
/// Scale of radii for rounded corners.
///
/// ## Scale
/// - **sm**: 8dp — Small elements (inputs, small buttons)
/// - **md**: 16dp — Medium elements (badges, chips, buttons)
/// - **lg**: 24dp — Large elements (cards, modals, containers)
///
/// {@category Tokens}
class DoriRadius {
  const DoriRadius._();

  /// 8dp — Small elements (inputs, small buttons)
  static const double smValue = 8;

  /// 16dp — Medium elements (badges, chips, buttons)
  static const double mdValue = 16;

  /// 24dp — Large elements (cards, modals, containers)
  static const double lgValue = 24;

  /// Circular BorderRadius of 8dp
  static BorderRadius get sm => BorderRadius.circular(smValue);

  /// Circular BorderRadius of 16dp
  static BorderRadius get md => BorderRadius.circular(mdValue);

  /// Circular BorderRadius of 24dp
  static BorderRadius get lg => BorderRadius.circular(lgValue);
}
