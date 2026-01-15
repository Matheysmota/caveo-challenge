/// Optional timeout configurations for individual HTTP requests.
library;

class RequestOptions {
  final Duration? connectTimeout;
  final Duration? receiveTimeout;
  final Duration? sendTimeout;

  const RequestOptions({
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
  });

  RequestOptions copyWith({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    return RequestOptions(
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
    );
  }
}
