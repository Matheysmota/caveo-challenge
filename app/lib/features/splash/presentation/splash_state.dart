import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/equatable_export/equatable_export.dart';

/// States for the splash screen.
///
/// State flow:
/// ```
/// SplashLoading ──► SplashSuccess (navigate to products)
///               └──► SplashError (show retry)
///                        │
///                        └──► SplashError(isRetrying: true) ──► SplashLoading...
/// ```
sealed class SplashState extends Equatable {
  const SplashState();
}

/// Initial state while syncing data.
///
/// Shows loading animation and branding.
final class SplashLoading extends SplashState {
  const SplashLoading();

  @override
  List<Object?> get props => [];
}

/// Sync completed successfully, ready to navigate.
///
/// This state triggers navigation to products page.
final class SplashSuccess extends SplashState {
  const SplashSuccess();

  @override
  List<Object?> get props => [];
}

/// Sync failed with an error.
///
/// Shows error message and retry button.
/// When [isRetrying] is true, the retry button shows a loading indicator.
final class SplashError extends SplashState {
  const SplashError({required this.failure, this.isRetrying = false});

  final NetworkFailure failure;

  /// Whether a retry is in progress.
  /// When true, the retry button should show a loading state.
  final bool isRetrying;

  @override
  List<Object?> get props => [failure, isRetrying];
}
