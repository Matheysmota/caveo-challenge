import 'package:caveo_challenge/app/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRoutes', () {
    group('static paths', () {
      test('splash should be root path', () {
        expect(AppRoutes.splash, '/');
      });

      test('products should be /products', () {
        expect(AppRoutes.products, '/products');
      });

      test('productDetails should be /products/:id pattern', () {
        expect(AppRoutes.productDetails, '/products/:id');
      });
    });

    group('productDetailsPath', () {
      test('should generate correct path for given id', () {
        expect(AppRoutes.productDetailsPath('123'), '/products/123');
      });

      test('should generate correct path for string id', () {
        expect(AppRoutes.productDetailsPath('abc-123'), '/products/abc-123');
      });

      test('should handle empty id', () {
        expect(AppRoutes.productDetailsPath(''), '/products/');
      });
    });
  });
}
