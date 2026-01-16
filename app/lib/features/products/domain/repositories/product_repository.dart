import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import '../entities/product.dart';

/// Contract for product data operations with remote-first strategy.
abstract interface class ProductRepository {
  /// Fetches products with pagination. Page is 1-based.
  Future<Result<List<Product>, NetworkFailure>> getProducts({int page = 1});
}
