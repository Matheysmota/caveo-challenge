/// Internal contract for low-level HTTP operations.
library;

import 'network_response.dart';

abstract class NetworkClient {
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  });

  Future<NetworkResponse> post(
    String url, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  });
}
