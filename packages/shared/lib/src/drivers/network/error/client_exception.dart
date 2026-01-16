/// Client exception wrapper for network errors.
library;

enum ClientExceptionType {
  connectionError,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badResponse,
  cancel,
  badCertificate,
  unknown,
}

class ClientException implements Exception {
  final ClientExceptionType type;
  final int? statusCode;
  final dynamic responseData;
  final String? message;
  final Object? originalError;

  const ClientException({
    required this.type,
    this.statusCode,
    this.responseData,
    this.message,
    this.originalError,
  });
}
