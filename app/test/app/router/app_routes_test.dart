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
    });
  });
}
