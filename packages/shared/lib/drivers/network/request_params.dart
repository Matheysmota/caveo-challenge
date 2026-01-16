/// Immutable configuration for an HTTP request.
library;

import '../../libraries/equatable_export/equatable_export.dart';
import 'http_method.dart';

class RequestParams extends Equatable {
  final String endpoint;
  final HttpMethod method;
  final Map<String, String>? queryParams;
  final Object? body;
  final Map<String, String>? headers;

  const RequestParams._({
    required this.endpoint,
    required this.method,
    this.queryParams,
    this.body,
    this.headers,
  });

  const factory RequestParams.get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) = _GetRequestParams;

  const factory RequestParams.post(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) = _PostRequestParams;

  @override
  List<Object?> get props => [endpoint, method, queryParams, body, headers];
}

// ignore_for_file: use_super_parameters

class _GetRequestParams extends RequestParams {
  const _GetRequestParams(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) : super._(
         endpoint: endpoint,
         method: HttpMethod.get,
         queryParams: queryParams,
         headers: headers,
         body: null,
       );
}

class _PostRequestParams extends RequestParams {
  const _PostRequestParams(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) : super._(
         endpoint: endpoint,
         method: HttpMethod.post,
         queryParams: queryParams,
         body: body,
         headers: headers,
       );
}
