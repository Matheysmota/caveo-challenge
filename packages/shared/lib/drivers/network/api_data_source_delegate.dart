/// Contract for HTTP API communication.
library;

import '../../libraries/result_export/result_export.dart';
import 'network_failure.dart';
import 'request_params.dart';

/// Abstract interface for HTTP API data source operations.
abstract class ApiDataSourceDelegate {
  /// Executes an HTTP request and maps the response.
  ///
  /// Returns [Success] with mapped data or [Failure] with [NetworkFailure].
  Future<Result<T, NetworkFailure>> request<T>({
    required RequestParams params,
    required T Function(Map<String, dynamic> json) mapper,
  });
}
