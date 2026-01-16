import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import '../entities/product.dart';

/// Contract for product data operations.
///
/// Implementations handle the complexity of data source selection
/// (remote vs local cache) transparently to consumers.
abstract interface class ProductRepository {
  /// Fetches a page of products.
  ///
  /// [page] - 1-based page number for pagination.
  ///
  /// Returns [Success] with product list or [Failure] with network error.
  Future<Result<List<Product>, NetworkFailure>> getProducts({int page = 1});
}
