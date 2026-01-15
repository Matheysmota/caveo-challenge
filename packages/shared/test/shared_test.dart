import 'package:flutter_test/flutter_test.dart';

import 'package:shared/shared.dart';

void main() {
  group('shared package', () {
    test('should export LocalCacheSource', () {
      // This test validates that the barrel export works correctly.
      // LocalCacheSource is an abstract class, we just check it's accessible.
      expect(LocalCacheSource, isNotNull);
    });

    test('should export LocalStorageKey', () {
      expect(LocalStorageKey.products, isNotNull);
      expect(LocalStorageKey.themeMode, isNotNull);
    });

    test('should export LocalStorageTTL', () {
      const ttl = LocalStorageTTL.withoutExpiration();
      expect(ttl.expires, isFalse);
    });
  });
}
