/// DotEnv implementation of [EnvironmentReader].
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../drivers/env/environment_reader.dart';

class DotEnvReader implements EnvironmentReader {
  final Map<String, String> _env;

  DotEnvReader._(this._env);

  static Future<DotEnvReader> load({String fileName = '.devEnv'}) async {
    await dotenv.load(fileName: fileName);
    return DotEnvReader._(Map.unmodifiable(dotenv.env));
  }

  factory DotEnvReader.fromMap(Map<String, String> env) {
    return DotEnvReader._(Map.unmodifiable(env));
  }

  @override
  String? get(String key) => _env[key];

  @override
  String require(String key) {
    final value = _env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Required environment variable "$key" not found.');
    }
    return value;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    final value = _env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  @override
  Duration getDuration(String key, {Duration defaultValue = Duration.zero}) {
    final ms = getInt(key, defaultValue: defaultValue.inMilliseconds);
    return Duration(milliseconds: ms);
  }
}
