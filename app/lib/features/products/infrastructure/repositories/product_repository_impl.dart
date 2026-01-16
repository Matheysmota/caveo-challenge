import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';

/// Remote-first repository. Falls back to cache only for page 1 failures.
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<Result<List<Product>, NetworkFailure>> getProducts({
    int page = 1,
  }) async {
    final remoteResult = await _remote.getProducts(page: page);

    return remoteResult.fold((products) async {
      if (page == 1) await _local.saveProducts(products);
      return Success(products);
    }, (failure) => _handleRemoteFailure(failure, page));
  }

  Future<Result<List<Product>, NetworkFailure>> _handleRemoteFailure(
    NetworkFailure failure,
    int page,
  ) async {
    if (page > 1) return Failure(failure);

    final cached = await _local.getProducts();
    if (cached != null && cached.isNotEmpty) return Success(cached);

    return Failure(failure);
  }
}
