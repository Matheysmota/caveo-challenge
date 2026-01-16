import '../../domain/entities/product.dart';

abstract interface class ProductLocalDataSource {
  Future<List<Product>?> getProducts();
  Future<void> saveProducts(List<Product> products);
  Future<void> clear();
}
