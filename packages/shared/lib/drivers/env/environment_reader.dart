/// Environment variable reader abstraction for dependency injection.
library;

/// Known environment variable keys.
enum EnvKey {
  baseUrl('BASE_URL'),
  connectTimeout('CONNECT_TIMEOUT'),
  receiveTimeout('RECEIVE_TIMEOUT'),
  sendTimeout('SEND_TIMEOUT');

  final String key;
  const EnvKey(this.key);
}

/// Contract for reading environment variables.
abstract class EnvironmentReader {
  String? get(String key);
  String require(String key);
  int getInt(String key, {int defaultValue = 0});
  Duration getDuration(String key, {Duration defaultValue = Duration.zero});
}
