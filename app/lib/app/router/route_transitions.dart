/// Custom route transitions for the app.
///
/// Provides consistent, performant animations for route changes.
/// All transitions are implemented with Flutter native animations
/// (no external dependencies like Lottie/Rive).
///
/// ## Available Transitions
///
/// - [fade]: Smooth opacity transition (Splash → Products)
/// - [slideUp]: Bottom-to-top slide (Products → Details)
/// - [none]: Instant transition, no animation
///
/// ## Performance Notes
///
/// All transitions:
/// - Use hardware-accelerated properties (opacity, transform)
/// - Respect `MediaQuery.disableAnimations` for accessibility
/// - Are optimized for 60fps+
library;

import 'package:flutter/material.dart';

/// Custom route transitions for the application.
///
/// These transitions are designed to be smooth and consistent
/// across the app while maintaining 60fps performance.
abstract final class RouteTransitions {
  RouteTransitions._();

  /// Default transition duration used across the app.
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Fade transition (opacity from 0 to 1).
  ///
  /// Used for: Splash → Products
  ///
  /// This is a subtle, professional transition that doesn't
  /// distract from the content.
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Respect accessibility settings
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return child;
    }

    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );
  }

  /// Slide up transition (from bottom to top).
  ///
  /// Used for: Products → Product Details
  ///
  /// Creates a modal-like feeling for detail screens.
  static Widget slideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Respect accessibility settings
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return child;
    }

    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation));

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// Slide from right transition.
  ///
  /// Standard iOS-like push animation.
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Respect accessibility settings
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return child;
    }

    final offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation));

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// No transition (instant).
  ///
  /// Used when animations should be skipped entirely.
  static Widget none(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
