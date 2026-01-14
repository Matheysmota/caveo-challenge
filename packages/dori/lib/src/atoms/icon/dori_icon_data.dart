import 'package:flutter/material.dart';

/// Allowed icons in the Dori Design System.
///
/// This enum restricts the available icons to only those approved
/// for use in the app, ensuring visual consistency and preventing
/// the use of icons that don't exist in the design system.
///
/// ## Usage
///
/// ```dart
/// // Get the IconData directly
/// DoriIconData.search.icon // Returns Icons.search
///
/// // Use with DoriIcon widget
/// DoriIcon(icon: DoriIconData.search)
/// ```
///
/// {@category Atoms}
enum DoriIconData {
  /// Search icon (magnifying glass)
  /// Used in: AppBar search button
  search(Icons.search, 'Search'),

  /// Close icon (X)
  /// Used in: Close buttons, clear search
  close(Icons.close, 'Close'),

  /// Light mode icon (sun)
  /// Used in: Theme toggle when in dark mode
  lightMode(Icons.light_mode_outlined, 'Light mode'),

  /// Dark mode icon (moon)
  /// Used in: Theme toggle when in light mode
  darkMode(Icons.dark_mode_outlined, 'Dark mode'),

  /// Back arrow icon
  /// Used in: Navigation back button
  arrowBack(Icons.arrow_back_ios_new, 'Go back'),

  /// Error icon
  /// Used in: Error screens, error states
  error(Icons.error_outline, 'Error'),

  /// Refresh icon
  /// Used in: Pull to refresh, retry actions
  refresh(Icons.refresh, 'Refresh'),

  /// Chevron right icon
  /// Used in: List items, navigation hints
  chevronRight(Icons.chevron_right, 'Navigate'),

  /// Info icon
  /// Used in: Information tooltips, help
  info(Icons.info_outline, 'Information'),

  /// Check icon
  /// Used in: Success states, confirmations
  check(Icons.check, 'Success'),

  /// Warning icon
  /// Used in: Warning states, alerts
  warning(Icons.warning_amber_outlined, 'Warning');

  /// Creates a DoriIconData with the associated Material icon and semantic label.
  const DoriIconData(this.icon, this.semanticLabel);

  /// The Material Design icon data.
  final IconData icon;

  /// Default semantic label for accessibility.
  ///
  /// This is used by screen readers to describe the icon.
  /// Can be overridden when using [DoriIcon] widget.
  final String semanticLabel;
}
