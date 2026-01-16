import 'package:shared/drivers/local_cache/local_cache_source.dart';
import 'package:shared/drivers/local_cache/local_storage_key.dart';
import 'package:shared/drivers/local_cache/local_storage_ttl.dart';

import '../../domain/entities/product.dart';
import '../models/product_list_cache.dart';

/// Contract for local product caching with TTL support.
abstract interface class ProductLocalDataSource {
  Future<List<Product>?> getProducts();
  Future<void> saveProducts(List<Product> products);
  Future<void> clear();
}

/// Implementation using SharedPreferences with 1h TTL.
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl({required LocalCacheSource cache})
    : _cache = cache;

  final LocalCacheSource _cache;

  static const _ttl = LocalStorageTTL.withExpiration(Duration(hours: 1));

  @override
  Future<List<Product>?> getProducts() async {
    final response = await _cache.getModel(
      LocalStorageKey.products,
      ProductListCache.fromMap,
    );
    return response?.data.products;
  }

  @override
  Future<void> saveProducts(List<Product> products) async {
    await _cache.setModel(
      LocalStorageKey.products,
      ProductListCache(products),
      ttl: _ttl,
    );
  }

  @override
  Future<void> clear() => _cache.delete(LocalStorageKey.products);
}
