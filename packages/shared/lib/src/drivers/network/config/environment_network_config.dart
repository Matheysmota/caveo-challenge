/// Implementation of [NetworkConfigProvider] using [EnvironmentReader].
///
/// ## Configuration
///
/// This class reads network configuration from environment variables.
/// In development, use VS Code's launch.json with `--dart-define`:
///
/// ```json
/// "toolArgs": [
///   "--dart-define=BASE_URL=https://fakestoreapi.com"
/// ]
/// ```
///
/// In CI/CD, pass the same flags to `flutter build`.
///
/// ## Security Note
///
/// For public APIs (like Fake Store API), the URL is not sensitive.
/// For APIs requiring authentication, use backend-for-frontend pattern
/// instead of embedding secrets in the mobile app.
library;

import '../../../../drivers/env/environment_reader.dart';
import '../../../../drivers/network/network_config_provider.dart';

class EnvironmentNetworkConfig implements NetworkConfigProvider {
  final EnvironmentReader _reader;

  static const _defaultTimeout = Duration(seconds: 30);

  const EnvironmentNetworkConfig(this._reader);

  @override
  String get baseUrl {
    final url = _reader.get(EnvKey.baseUrl.key);
    if (url == null || url.isEmpty) {
      throw StateError(
        'BASE_URL not configured. '
        'Run with --dart-define=BASE_URL=https://your-api.com '
        'or use VS Code launch.json configuration.',
      );
    }
    return url;
  }

  @override
  Duration get connectTimeout => _reader.getDuration(
    EnvKey.connectTimeout.key,
    defaultValue: _defaultTimeout,
  );

  @override
  Duration get receiveTimeout => _reader.getDuration(
    EnvKey.receiveTimeout.key,
    defaultValue: _defaultTimeout,
  );

  @override
  Duration get sendTimeout => _reader.getDuration(
    EnvKey.sendTimeout.key,
    defaultValue: _defaultTimeout,
  );
}
