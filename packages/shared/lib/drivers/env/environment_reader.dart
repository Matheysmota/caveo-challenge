/// Environment variable reader abstraction for dependency injection.
library;

/// Contract for reading environment variables.
abstract class EnvironmentReader {
  String? get(String key);
  String require(String key);
  int getInt(String key, {int defaultValue = 0});
  Duration getDuration(String key, {Duration defaultValue = Duration.zero});
}
