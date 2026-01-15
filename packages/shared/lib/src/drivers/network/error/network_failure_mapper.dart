/// Maps [ClientException] to [NetworkFailure].
library;

import '../../../../drivers/network/network_failure.dart';
import 'client_exception.dart';

class NetworkFailureMapper {
  const NetworkFailureMapper();

  NetworkFailure map(ClientException exception) {
    return switch (exception.type) {
      ClientExceptionType.connectionError => ConnectionFailure(
        originalError: exception.originalError,
      ),
      ClientExceptionType.connectionTimeout ||
      ClientExceptionType.sendTimeout ||
      ClientExceptionType.receiveTimeout => TimeoutFailure(
        originalError: exception.originalError,
      ),
      ClientExceptionType.badResponse => HttpFailure(
        statusCode: exception.statusCode ?? 0,
        responseBody: exception.responseData is Map<String, dynamic>
            ? exception.responseData as Map<String, dynamic>
            : null,
        originalError: exception.originalError,
      ),
      ClientExceptionType.badCertificate => const ConnectionFailure(
        message: 'Security certificate error.',
      ),
      ClientExceptionType.cancel => const UnknownNetworkFailure(
        message: 'Request was cancelled.',
      ),
      ClientExceptionType.unknown => UnknownNetworkFailure(
        message: exception.message ?? 'An unexpected error occurred.',
        originalError: exception.originalError,
      ),
    };
  }
}
