/// Implementation of [ApiDataSourceDelegate].
library;

import '../../../../drivers/network/api_data_source_delegate.dart';
import '../../../../drivers/network/http_method.dart';
import '../../../../drivers/network/network_config_provider.dart';
import '../../../../drivers/network/network_failure.dart';
import '../../../../drivers/network/request_params.dart';
import '../../../../libraries/result_export/result_export.dart';
import '../client/network_client.dart';
import '../client/network_response.dart';
import '../error/client_exception.dart';
import '../error/network_failure_mapper.dart';

class ApiDataSourceDelegateImpl implements ApiDataSourceDelegate {
  final NetworkClient _client;
  final NetworkConfigProvider _config;
  final NetworkFailureMapper _failureMapper;

  ApiDataSourceDelegateImpl({
    required NetworkClient client,
    required NetworkConfigProvider config,
    NetworkFailureMapper failureMapper = const NetworkFailureMapper(),
  }) : _client = client,
       _config = config,
       _failureMapper = failureMapper;

  @override
  Future<Result<T, NetworkFailure>> request<T>({
    required RequestParams params,
    required T Function(Map<String, dynamic> json) mapper,
  }) async {
    try {
      final url = _buildUrl(params.endpoint);
      final response = await _executeRequest(url, params);

      if (!response.isSuccess) {
        return Failure(_mapHttpError(response));
      }

      final normalized = _normalizeResponse(response.data);
      return Success(mapper(normalized));
    } on ClientException catch (e) {
      return Failure(_failureMapper.map(e));
    } catch (e) {
      if (e is TypeError || e is FormatException) {
        return Failure(ParseFailure(originalError: e));
      }
      return Failure(UnknownNetworkFailure(originalError: e));
    }
  }

  String _buildUrl(String endpoint) {
    final base = _config.baseUrl.endsWith('/')
        ? _config.baseUrl.substring(0, _config.baseUrl.length - 1)
        : _config.baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }

  Future<NetworkResponse> _executeRequest(String url, RequestParams params) {
    final connectTimeout =
        params.options?.connectTimeout ?? _config.connectTimeout;
    final receiveTimeout =
        params.options?.receiveTimeout ?? _config.receiveTimeout;
    final sendTimeout = params.options?.sendTimeout ?? _config.sendTimeout;

    return switch (params.method) {
      HttpMethod.get => _client.get(
        url,
        queryParams: params.queryParams,
        headers: params.headers,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ),
      HttpMethod.post => _client.post(
        url,
        body: params.body,
        queryParams: params.queryParams,
        headers: params.headers,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
      ),
    };
  }

  Map<String, dynamic> _normalizeResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  HttpFailure _mapHttpError(NetworkResponse response) {
    return HttpFailure(
      statusCode: response.statusCode,
      responseBody: response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null,
    );
  }
}
