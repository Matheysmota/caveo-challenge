/// Immutable configuration for an HTTP request.
library;

import '../../libraries/equatable_export/equatable_export.dart';
import 'http_method.dart';
import 'request_options.dart';

class RequestParams extends Equatable {
  final String endpoint;
  final HttpMethod method;
  final Map<String, String>? queryParams;
  final Object? body;
  final Map<String, String>? headers;
  final RequestOptions? options;

  const RequestParams._({
    required this.endpoint,
    required this.method,
    this.queryParams,
    this.body,
    this.headers,
    this.options,
  });

  const factory RequestParams.get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    RequestOptions? options,
  }) = _GetRequestParams;

  const factory RequestParams.post(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    RequestOptions? options,
  }) = _PostRequestParams;

  @override
  List<Object?> get props => [
    endpoint,
    method,
    queryParams,
    body,
    headers,
    options,
  ];
}

// ignore_for_file: use_super_parameters

class _GetRequestParams extends RequestParams {
  const _GetRequestParams(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    RequestOptions? options,
  }) : super._(
         endpoint: endpoint,
         method: HttpMethod.get,
         queryParams: queryParams,
         headers: headers,
         options: options,
         body: null,
       );
}

class _PostRequestParams extends RequestParams {
  const _PostRequestParams(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    RequestOptions? options,
  }) : super._(
         endpoint: endpoint,
         method: HttpMethod.post,
         queryParams: queryParams,
         body: body,
         headers: headers,
         options: options,
       );
}
