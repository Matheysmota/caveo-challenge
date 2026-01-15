/// Dio-based implementation of [NetworkClient].
library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/client_exception.dart';
import 'network_client.dart';
import 'network_response.dart';

class DioNetworkClient implements NetworkClient {
  static Dio? _dioInstance;

  static Dio get _dio {
    _dioInstance ??= Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null,
        responseType: ResponseType.json,
      ),
    );
    return _dioInstance!;
  }

  @visibleForTesting
  static void setDioInstanceForTesting(Dio dio) {
    _dioInstance = dio;
  }

  @visibleForTesting
  static void resetDioInstance() {
    _dioInstance = null;
  }

  @override
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers, receiveTimeout: receiveTimeout),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse> post(
    String url, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        ),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  NetworkResponse _mapResponse(Response<dynamic> response) {
    final headers = <String, String>{};
    response.headers.forEach((name, values) {
      if (values.isNotEmpty) headers[name.toLowerCase()] = values.join(', ');
    });
    return NetworkResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
      headers: headers,
    );
  }

  ClientException _mapDioException(DioException e) {
    final type = switch (e.type) {
      DioExceptionType.connectionError => ClientExceptionType.connectionError,
      DioExceptionType.connectionTimeout =>
        ClientExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout => ClientExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout => ClientExceptionType.receiveTimeout,
      DioExceptionType.badResponse => ClientExceptionType.badResponse,
      DioExceptionType.cancel => ClientExceptionType.cancel,
      DioExceptionType.badCertificate => ClientExceptionType.badCertificate,
      DioExceptionType.unknown =>
        _isConnectionError(e)
            ? ClientExceptionType.connectionError
            : ClientExceptionType.unknown,
    };

    return ClientException(
      type: type,
      statusCode: e.response?.statusCode,
      responseData: e.response?.data,
      message: e.message,
      originalError: e,
    );
  }

  bool _isConnectionError(DioException e) {
    final message = e.message?.toLowerCase() ?? '';
    return message.contains('connection refused') ||
        message.contains('network is unreachable') ||
        message.contains('no internet') ||
        message.contains('failed host lookup');
  }
}
