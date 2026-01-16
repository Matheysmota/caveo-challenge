import 'package:flutter_test/flutter_test.dart';
import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/drivers/sync_store/sync_store_export.dart';
import 'package:shared/libraries/result_export/result_export.dart';
import 'package:shared/src/drivers/sync_store/sync_store_impl.dart';

void main() {
  group('SyncStoreImpl', () {
    late SyncStoreImpl syncStore;

    setUp(() {
      syncStore = SyncStoreImpl();
    });

    tearDown(() async {
      await syncStore.clear();
    });

    group('registerSyncer', () {
      test('should register a syncer successfully', () {
        // Act
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Assert
        expect(syncStore.hasKey(SyncStoreKey.products), isTrue);
      });

      test('should throw StateError when registering duplicate key', () {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act & Assert
        expect(
          () => syncStore.registerSyncer<String>(
            SyncStoreKey.products,
            fetcher: () async => const Success('other'),
          ),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('sync', () {
      test('should return SyncStateSuccess when fetcher succeeds', () async {
        // Arrange
        const expectedData = ['item1', 'item2'];
        syncStore.registerSyncer<List<String>>(
          SyncStoreKey.products,
          fetcher: () async => const Success(expectedData),
        );

        // Act
        final result = await syncStore.sync<List<String>>(
          SyncStoreKey.products,
        );

        // Assert
        expect(result, isA<SyncStateSuccess<List<String>>>());
        expect((result as SyncStateSuccess).data, expectedData);
      });

      test('should return SyncStateError when fetcher fails', () async {
        // Arrange
        const failure = ConnectionFailure(message: 'No connection');
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Failure(failure),
        );

        // Act
        final result = await syncStore.sync<String>(SyncStoreKey.products);

        // Assert
        expect(result, isA<SyncStateError<String>>());
        expect((result as SyncStateError).failure, failure);
      });

      test('should preserve previous data on error', () async {
        // Arrange
        const initialData = 'initial';
        const failure = ConnectionFailure(message: 'No connection');
        var callCount = 0;

        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async {
            callCount++;
            return callCount == 1
                ? const Success(initialData)
                : const Failure(failure);
          },
        );

        // Act - First sync succeeds
        await syncStore.sync<String>(SyncStoreKey.products);

        // Act - Second sync fails
        final result = await syncStore.sync<String>(SyncStoreKey.products);

        // Assert
        expect(result, isA<SyncStateError<String>>());
        expect((result as SyncStateError).previousData, initialData);
      });

      test('should throw StateError when key not registered', () {
        // Act & Assert
        expect(
          () => syncStore.sync<String>(SyncStoreKey.products),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('watch', () {
      test('should emit current state immediately', () async {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act
        final states = <SyncState<String>>[];
        syncStore.watch<String>(SyncStoreKey.products).listen(states.add);

        // Allow stream to emit
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states.length, 1);
        expect(states.first, isA<SyncStateIdle<String>>());
      });

      test('should emit loading then success during sync', () async {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        final states = <SyncState<String>>[];
        final subscription = syncStore
            .watch<String>(SyncStoreKey.products)
            .listen(states.add);

        // Allow initial state to emit
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Act
        await syncStore.sync<String>(SyncStoreKey.products);

        // Allow all states to emit
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await subscription.cancel();

        // Assert - Should have: Idle, Loading, Success
        expect(states.length, 3);
        expect(states[0], isA<SyncStateIdle<String>>());
        expect(states[1], isA<SyncStateLoading<String>>());
        expect(states[2], isA<SyncStateSuccess<String>>());
      });

      test('should throw StateError when key not registered', () {
        // Act & Assert
        expect(
          () => syncStore.watch<String>(SyncStoreKey.products),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('get', () {
      test('should return current state', () {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act
        final state = syncStore.get<String>(SyncStoreKey.products);

        // Assert
        expect(state, isA<SyncStateIdle<String>>());
      });

      test('should return updated state after sync', () async {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act
        await syncStore.sync<String>(SyncStoreKey.products);
        final state = syncStore.get<String>(SyncStoreKey.products);

        // Assert
        expect(state, isA<SyncStateSuccess<String>>());
        expect((state as SyncStateSuccess).data, 'data');
      });

      test('should throw StateError when key not registered', () {
        // Act & Assert
        expect(
          () => syncStore.get<String>(SyncStoreKey.products),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('getDataOrNull', () {
      test('should return null when key not registered', () {
        // Act
        final data = syncStore.getDataOrNull<String>(SyncStoreKey.products);

        // Assert
        expect(data, isNull);
      });

      test('should return null when in idle state', () {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act
        final data = syncStore.getDataOrNull<String>(SyncStoreKey.products);

        // Assert
        expect(data, isNull);
      });

      test('should return data when in success state', () async {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );
        await syncStore.sync<String>(SyncStoreKey.products);

        // Act
        final data = syncStore.getDataOrNull<String>(SyncStoreKey.products);

        // Assert
        expect(data, 'data');
      });
    });

    group('clear', () {
      test('should remove all registered syncers', () async {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );
        expect(syncStore.hasKey(SyncStoreKey.products), isTrue);

        // Act
        await syncStore.clear();

        // Assert
        expect(syncStore.hasKey(SyncStoreKey.products), isFalse);
      });
    });

    group('hasKey', () {
      test('should return false for unregistered key', () {
        // Act & Assert
        expect(syncStore.hasKey(SyncStoreKey.products), isFalse);
      });

      test('should return true for registered key', () {
        // Arrange
        syncStore.registerSyncer<String>(
          SyncStoreKey.products,
          fetcher: () async => const Success('data'),
        );

        // Act & Assert
        expect(syncStore.hasKey(SyncStoreKey.products), isTrue);
      });
    });
  });

  group('SyncState', () {
    test('isSuccess should return correct value', () {
      expect(const SyncStateIdle<String>().isSuccess, isFalse);
      expect(const SyncStateLoading<String>().isSuccess, isFalse);
      expect(const SyncStateSuccess<String>('').isSuccess, isTrue);
      expect(
        const SyncStateError<String>(ConnectionFailure()).isSuccess,
        isFalse,
      );
    });

    test('isError should return correct value', () {
      expect(const SyncStateIdle<String>().isError, isFalse);
      expect(const SyncStateLoading<String>().isError, isFalse);
      expect(const SyncStateSuccess<String>('').isError, isFalse);
      expect(const SyncStateError<String>(ConnectionFailure()).isError, isTrue);
    });

    test('isLoading should return correct value', () {
      expect(const SyncStateIdle<String>().isLoading, isFalse);
      expect(const SyncStateLoading<String>().isLoading, isTrue);
      expect(const SyncStateSuccess<String>('').isLoading, isFalse);
      expect(
        const SyncStateError<String>(ConnectionFailure()).isLoading,
        isFalse,
      );
    });

    test('isIdle should return correct value', () {
      expect(const SyncStateIdle<String>().isIdle, isTrue);
      expect(const SyncStateLoading<String>().isIdle, isFalse);
      expect(const SyncStateSuccess<String>('').isIdle, isFalse);
      expect(const SyncStateError<String>(ConnectionFailure()).isIdle, isFalse);
    });

    test('dataOrNull should return data only for success state', () {
      expect(const SyncStateIdle<String>().dataOrNull, isNull);
      expect(const SyncStateLoading<String>().dataOrNull, isNull);
      expect(const SyncStateSuccess<String>('data').dataOrNull, 'data');
      expect(
        const SyncStateError<String>(ConnectionFailure()).dataOrNull,
        isNull,
      );
    });

    test('failureOrNull should return failure only for error state', () {
      const failure = ConnectionFailure();
      expect(const SyncStateIdle<String>().failureOrNull, isNull);
      expect(const SyncStateLoading<String>().failureOrNull, isNull);
      expect(const SyncStateSuccess<String>('').failureOrNull, isNull);
      expect(const SyncStateError<String>(failure).failureOrNull, failure);
    });
  });
}
