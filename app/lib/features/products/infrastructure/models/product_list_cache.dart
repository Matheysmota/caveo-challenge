import 'package:shared/drivers/local_cache/serializable.dart';

import '../../domain/entities/product.dart';

class ProductListCache implements Serializable {
  ProductListCache(this.products);

  factory ProductListCache.fromMap(Map<String, dynamic> map) {
    final list = map['products'] as List<dynamic>;
    return ProductListCache(
      list.map((e) => _productFromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  final List<Product> products;

  @override
  Map<String, dynamic> toMap() => {
    'products': products.map(_productToMap).toList(),
  };

  static Product _productFromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      rating: ProductRating(
        rate: (map['rating']['rate'] as num).toDouble(),
        count: map['rating']['count'] as int,
      ),
    );
  }

  static Map<String, dynamic> _productToMap(Product product) => {
    'id': product.id,
    'title': product.title,
    'price': product.price,
    'description': product.description,
    'category': product.category,
    'imageUrl': product.imageUrl,
    'rating': {'rate': product.rating.rate, 'count': product.rating.count},
  };
}
