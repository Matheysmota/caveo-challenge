import 'dart:async';

import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';

import 'package:caveo_challenge/app/di/app_providers.dart';
import 'package:caveo_challenge/features/products/domain/entities/product.dart';
import 'package:caveo_challenge/features/products/domain/repositories/product_repository.dart';
import 'package:caveo_challenge/features/products/presentation/product_list_page.dart';
import 'package:caveo_challenge/features/products/presentation/widgets/product_grid.dart';
import 'package:caveo_challenge/features/products/presentation/widgets/product_list_app_bar.dart';
import 'package:caveo_challenge/main.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockSyncStore extends Mock implements SyncStore {}

void main() {
  late MockProductRepository mockRepository;
  late MockSyncStore mockSyncStore;
  late StreamController<ConnectivityStatus> connectivityController;

  final testProducts = List.generate(
    5,
    (i) => Product(
      id: i + 1,
      title: 'Product ${i + 1}',
      price: (i + 1) * 10.0,
      description: 'Description ${i + 1}',
      category: 'Category',
      imageUrl: 'https://example.com/image$i.png',
      rating: const ProductRating(rate: 4.5, count: 100),
    ),
  );

  setUp(() {
    mockRepository = MockProductRepository();
    mockSyncStore = MockSyncStore();
    connectivityController = StreamController<ConnectivityStatus>.broadcast();
  });

  tearDown(() {
    connectivityController.close();
  });

  group('ProductListPage', () {
    testWidgets('should render ProductListAppBar', (tester) async {
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(mockRepository),
            syncStoreProvider.overrideWithValue(mockSyncStore),
            connectivityStreamProvider.overrideWith(
              (ref) => connectivityController.stream,
            ),
          ],
          child: MaterialApp(
            theme: DoriTheme.light,
            home: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ProductListAppBar), findsOneWidget);
    });

    testWidgets('should show ProductGrid when state is loaded', (tester) async {
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(mockRepository),
            syncStoreProvider.overrideWithValue(mockSyncStore),
            connectivityStreamProvider.overrideWith(
              (ref) => connectivityController.stream,
            ),
          ],
          child: MaterialApp(
            theme: DoriTheme.light,
            home: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ProductGrid), findsOneWidget);
    });

    testWidgets('should show error state with retry button', (tester) async {
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(const SyncStateError(ConnectionFailure()));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(mockRepository),
            syncStoreProvider.overrideWithValue(mockSyncStore),
            connectivityStreamProvider.overrideWith(
              (ref) => connectivityController.stream,
            ),
          ],
          child: MaterialApp(
            theme: DoriTheme.light,
            home: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      // Error state should show a button
      expect(find.byType(DoriButton), findsOneWidget);
    });

    testWidgets('should have safe area', (tester) async {
      when(
        () => mockSyncStore.get<List<Product>>(SyncStoreKey.products),
      ).thenReturn(SyncStateSuccess(testProducts));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(mockRepository),
            syncStoreProvider.overrideWithValue(mockSyncStore),
            connectivityStreamProvider.overrideWith(
              (ref) => connectivityController.stream,
            ),
          ],
          child: MaterialApp(
            theme: DoriTheme.light,
            home: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
