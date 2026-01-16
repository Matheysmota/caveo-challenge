/// Network failure types for API communication.
library;

import '../../libraries/equatable_export/equatable_export.dart';

sealed class NetworkFailure extends Equatable {
  String get message;
  Object? get originalError;

  const NetworkFailure();
}

final class HttpFailure extends NetworkFailure {
  @override
  final String message;
  final int statusCode;
  final Map<String, dynamic>? responseBody;
  @override
  final Object? originalError;

  const HttpFailure({
    required this.statusCode,
    String? message,
    this.responseBody,
    this.originalError,
  }) : message = message ?? 'Request failed with status $statusCode';

  @override
  List<Object?> get props => [statusCode, message];
}

final class ConnectionFailure extends NetworkFailure {
  @override
  final String message;
  @override
  final Object? originalError;

  const ConnectionFailure({
    this.message = 'Unable to connect. Check your internet connection.',
    this.originalError,
  });

  @override
  List<Object?> get props => [message];
}

final class TimeoutFailure extends NetworkFailure {
  @override
  final String message;
  @override
  final Object? originalError;

  const TimeoutFailure({
    this.message = 'Request timed out. Please try again.',
    this.originalError,
  });

  @override
  List<Object?> get props => [message];
}

final class ParseFailure extends NetworkFailure {
  @override
  final String message;
  @override
  final Object? originalError;

  const ParseFailure({
    this.message = 'Invalid response format.',
    this.originalError,
  });

  @override
  List<Object?> get props => [message];
}

final class CancelledFailure extends NetworkFailure {
  @override
  final String message;
  @override
  final Object? originalError;

  const CancelledFailure({
    this.message = 'Request was cancelled.',
    this.originalError,
  });

  @override
  List<Object?> get props => [message];
}

final class UnknownNetworkFailure extends NetworkFailure {
  @override
  final String message;
  @override
  final Object? originalError;

  const UnknownNetworkFailure({
    this.message = 'An unexpected error occurred.',
    this.originalError,
  });

  @override
  List<Object?> get props => [message];
}
