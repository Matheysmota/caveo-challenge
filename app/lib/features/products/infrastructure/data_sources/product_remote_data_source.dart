import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import '../../domain/entities/product.dart';

abstract interface class ProductRemoteDataSource {
  Future<Result<List<Product>, NetworkFailure>> getProducts({int page = 1});
}
