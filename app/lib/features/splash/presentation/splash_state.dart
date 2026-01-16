import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/equatable_export/equatable_export.dart';

sealed class SplashState extends Equatable {
  const SplashState();
}

final class SplashReady extends SplashState {
  const SplashReady();

  @override
  List<Object?> get props => [];
}

final class SplashError extends SplashState {
  const SplashError({required this.failure});

  final NetworkFailure failure;

  @override
  List<Object?> get props => [failure];
}
