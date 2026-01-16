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

import 'package:flutter/foundation.dart';

import '../../../../drivers/env/environment_reader.dart';
import '../../../../drivers/network/network_config_provider.dart';

/// Network configuration that reads from compile-time environment variables.
///
/// In debug mode, provides a fallback URL for easier development.
/// In release mode, throws if BASE_URL is not configured.
class EnvironmentNetworkConfig implements NetworkConfigProvider {
  const EnvironmentNetworkConfig(this._reader);

  final EnvironmentReader _reader;

  static const _defaultTimeout = Duration(seconds: 30);

  /// Fallback URL used only in debug mode for development convenience.
  @visibleForTesting
  static const devFallbackUrl = 'https://fakestoreapi.com';

  @override
  String get baseUrl {
    final url = _reader.get(EnvKey.baseUrl.key);

    if (url != null && url.isNotEmpty) return url;

    // In release mode, fail fast to catch configuration issues early.
    if (kReleaseMode) {
      throw StateError(
        'BASE_URL not configured. '
        'Build with --dart-define=BASE_URL=https://your-api.com',
      );
    }

    // In debug mode, use fallback for development convenience.
    return devFallbackUrl;
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
