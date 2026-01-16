import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('RequestParams', () {
    test('GET factory creates correct params', () {
      const params = RequestParams.get('/products');
      expect(params.endpoint, equals('/products'));
      expect(params.method, equals(HttpMethod.get));
      expect(params.body, isNull);
    });

    test('GET with query params', () {
      const params = RequestParams.get(
        '/products',
        queryParams: {'category': 'electronics'},
      );
      expect(params.queryParams, equals({'category': 'electronics'}));
    });

    test('POST factory creates correct params', () {
      const params = RequestParams.post('/cart', body: {'id': 1});
      expect(params.endpoint, equals('/cart'));
      expect(params.method, equals(HttpMethod.post));
      expect(params.body, equals({'id': 1}));
    });

    test('equality', () {
      const p1 = RequestParams.get('/products');
      const p2 = RequestParams.get('/products');
      const p3 = RequestParams.get('/users');
      expect(p1, equals(p2));
      expect(p1, isNot(equals(p3)));
    });

    test('hashCode consistency', () {
      const p1 = RequestParams.get('/products');
      const p2 = RequestParams.get('/products');
      expect(p1.hashCode, equals(p2.hashCode));
    });
  });
}
