/// Implementation of [NetworkConfigProvider] using [EnvironmentReader].
library;

import '../../../../drivers/env/environment_reader.dart';
import '../../../../drivers/network/network_config_provider.dart';

class EnvironmentNetworkConfig implements NetworkConfigProvider {
  final EnvironmentReader _reader;

  static const _defaultTimeout = Duration(seconds: 30);

  const EnvironmentNetworkConfig(this._reader);

  @override
  String get baseUrl => _reader.require('BASE_URL');

  @override
  Duration get connectTimeout =>
      _reader.getDuration('CONNECT_TIMEOUT', defaultValue: _defaultTimeout);

  @override
  Duration get receiveTimeout =>
      _reader.getDuration('RECEIVE_TIMEOUT', defaultValue: _defaultTimeout);

  @override
  Duration get sendTimeout =>
      _reader.getDuration('SEND_TIMEOUT', defaultValue: _defaultTimeout);
}
