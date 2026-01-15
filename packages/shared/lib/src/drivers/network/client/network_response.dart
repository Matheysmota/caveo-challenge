/// Internal DTO for HTTP responses.
library;

class NetworkResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;

  const NetworkResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
