/// Variants for [DoriToast] component.
///
/// Each variant maps to a semantic color from the feedback palette.
///
/// {@category Atoms}
enum DoriToastVariant {
  /// Neutral toast for general messages.
  ///
  /// Uses surface colors for background.
  neutral,

  /// Success toast for confirmations.
  ///
  /// Uses success feedback colors (green).
  success,

  /// Error toast for failures.
  ///
  /// Uses error feedback colors (red).
  error,

  /// Info toast for informational messages.
  ///
  /// Uses info feedback colors (blue).
  info,
}
