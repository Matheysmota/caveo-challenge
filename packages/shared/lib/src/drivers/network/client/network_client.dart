/// Internal contract for low-level HTTP operations.
library;

import 'network_response.dart';

/// HTTP client abstraction.
///
/// Timeouts are configured at client initialization level via
/// [NetworkConfigProvider], not per-request.
abstract class NetworkClient {
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });

  Future<NetworkResponse> post(
    String url, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });
}
