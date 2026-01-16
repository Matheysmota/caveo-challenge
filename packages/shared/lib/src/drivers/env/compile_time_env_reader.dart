/// Compile-time environment reader using String.fromEnvironment.
library;

import '../../../drivers/env/environment_reader.dart';

class CompileTimeEnvReader implements EnvironmentReader {
  const CompileTimeEnvReader();

  @override
  String? get(String key) {
    final value = _getByKey(key);
    return value.isEmpty ? null : value;
  }

  @override
  String require(String key) {
    final value = _getByKey(key);
    if (value.isEmpty) {
      throw StateError('Required compile-time variable "$key" not defined.');
    }
    return value;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    final value = _getByKey(key);
    if (value.isEmpty) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  @override
  Duration getDuration(String key, {Duration defaultValue = Duration.zero}) {
    final ms = getInt(key, defaultValue: defaultValue.inMilliseconds);
    return Duration(milliseconds: ms);
  }

  // Note: String.fromEnvironment requires compile-time constant strings,
  // so we cannot use EnvKey.*.key directly in the switch expression.
  String _getByKey(String key) {
    return switch (key) {
      'BASE_URL' => const String.fromEnvironment('BASE_URL'),
      'CONNECT_TIMEOUT' => const String.fromEnvironment('CONNECT_TIMEOUT'),
      'RECEIVE_TIMEOUT' => const String.fromEnvironment('RECEIVE_TIMEOUT'),
      'SEND_TIMEOUT' => const String.fromEnvironment('SEND_TIMEOUT'),
      _ => '',
    };
  }
}
