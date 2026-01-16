import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/equatable_export/equatable_export.dart';

/// Splash screen states: Loading → Success | Error (with retry support).
sealed class SplashState extends Equatable {
  const SplashState();
}

final class SplashLoading extends SplashState {
  const SplashLoading();

  @override
  List<Object?> get props => [];
}

final class SplashSuccess extends SplashState {
  const SplashSuccess();

  @override
  List<Object?> get props => [];
}

/// Error state. When [isRetrying] is true, retry button shows loading.
final class SplashError extends SplashState {
  const SplashError({required this.failure, this.isRetrying = false});

  final NetworkFailure failure;
  final bool isRetrying;

  @override
  List<Object?> get props => [failure, isRetrying];
}
