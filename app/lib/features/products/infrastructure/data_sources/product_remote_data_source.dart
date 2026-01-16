import 'package:shared/drivers/network/api_data_source_delegate.dart';
import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/drivers/network/request_params.dart';
import 'package:shared/libraries/result_export/result_export.dart';

import '../../domain/entities/product.dart';

/// Contract for fetching products from remote API.
abstract interface class ProductRemoteDataSource {
  Future<Result<List<Product>, NetworkFailure>> getProducts({int page = 1});
}

/// Implementation using FakeStore API with limit/offset pagination.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required ApiDataSourceDelegate api})
    : _api = api;

  final ApiDataSourceDelegate _api;

  static const _pageSize = 20;

  @override
  Future<Result<List<Product>, NetworkFailure>> getProducts({
    int page = 1,
  }) async {
    return _api.request<List<Product>>(
      params: RequestParams.get(
        '/products',
        queryParams: {
          'limit': '$_pageSize',
          'offset': '${(page - 1) * _pageSize}',
        },
      ),
      mapper: _parseProducts,
    );
  }

  List<Product> _parseProducts(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>;
    return list
        .map((e) => _productFromJson(e as Map<String, dynamic>))
        .toList();
  }

  Product _productFromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['image'] as String,
      rating: ProductRating(
        rate: (json['rating']['rate'] as num).toDouble(),
        count: json['rating']['count'] as int,
      ),
    );
  }
}
