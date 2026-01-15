import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/libraries/mocktail_export/mocktail_export.dart';
import 'package:shared/shared.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConnectivity mockConnectivity;
  late ConnectivityPlusObserver observer;
  late StreamController<List<ConnectivityResult>> connectivityController;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityController =
        StreamController<List<ConnectivityResult>>.broadcast();

    when(
      () => mockConnectivity.onConnectivityChanged,
    ).thenAnswer((_) => connectivityController.stream);
  });

  tearDown(() {
    observer.dispose();
    connectivityController.close();
  });

  group('ConnectivityPlusObserver', () {
    group('observe', () {
      test('should emit online status when WiFi is connected', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit online status when Mobile is connected', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.mobile]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit online status when Ethernet is connected', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit offline status when none is returned', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.offline));
      });

      test('should emit offline status when empty list is returned', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => []);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.offline));
      });

      test('should emit offline when only Bluetooth is connected', () async {
        // Arrange - Bluetooth does not provide internet access
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.bluetooth]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.offline));
      });

      test('should emit online when WiFi + Bluetooth connected', () async {
        // Arrange - WiFi provides internet, Bluetooth doesn't matter
        when(() => mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.bluetooth, ConnectivityResult.wifi],
        );

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit online when VPN is connected', () async {
        // Arrange - VPN provides internet access
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.vpn]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit online when multiple connections exist', () async {
        // Arrange - WiFi + Mobile simultaneously
        when(() => mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
        );

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();

        // Assert
        await expectLater(stream, emits(ConnectivityStatus.online));
      });

      test('should emit current status immediately on subscription', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();
        final firstEmission = await stream.first;

        // Assert
        expect(firstEmission, equals(ConnectivityStatus.online));
        verify(() => mockConnectivity.checkConnectivity()).called(1);
      });

      test('should emit new status when connectivity changes', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final emissions = <ConnectivityStatus>[];
        final subscription = observer.observe().listen(emissions.add);

        // Wait for initial emission
        await Future.delayed(const Duration(milliseconds: 50));

        // Simulate connectivity change to offline
        connectivityController.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 50));

        // Simulate connectivity restored
        connectivityController.add([ConnectivityResult.mobile]);
        await Future.delayed(const Duration(milliseconds: 50));

        await subscription.cancel();

        // Assert
        expect(emissions, [
          ConnectivityStatus.online, // Initial
          ConnectivityStatus.offline, // After change to none
          ConnectivityStatus.online, // After change to mobile
        ]);
      });

      test('should deduplicate consecutive identical status updates', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final emissions = <ConnectivityStatus>[];
        final subscription = observer.observe().listen(emissions.add);

        // Wait for initial emission
        await Future.delayed(const Duration(milliseconds: 50));

        // Emit same status multiple times (WiFi -> Mobile, still online)
        connectivityController.add([ConnectivityResult.mobile]);
        await Future.delayed(const Duration(milliseconds: 50));

        connectivityController.add([ConnectivityResult.ethernet]);
        await Future.delayed(const Duration(milliseconds: 50));

        await subscription.cancel();

        // Assert - should only have one emission (initial online)
        // because WiFi -> Mobile -> Ethernet are all online
        expect(emissions, [ConnectivityStatus.online]);
      });

      test('should allow multiple subscriptions to same stream', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final emissions1 = <ConnectivityStatus>[];
        final emissions2 = <ConnectivityStatus>[];

        final sub1 = observer.observe().listen(emissions1.add);
        final sub2 = observer.observe().listen(emissions2.add);

        await Future.delayed(const Duration(milliseconds: 50));

        connectivityController.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 50));

        await sub1.cancel();
        await sub2.cancel();

        // Assert - both subscriptions should receive same events
        expect(emissions1, [
          ConnectivityStatus.online,
          ConnectivityStatus.offline,
        ]);
        expect(emissions2, [
          ConnectivityStatus.online,
          ConnectivityStatus.offline,
        ]);
      });
    });

    group('dispose', () {
      test('should close stream after dispose', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final stream = observer.observe();
        final completer = Completer<void>();

        stream.listen((_) {}, onDone: () => completer.complete());

        await Future.delayed(const Duration(milliseconds: 50));
        observer.dispose();

        // Assert
        await expectLater(
          completer.future.timeout(const Duration(seconds: 1)),
          completes,
        );
      });

      test('should not emit after dispose', () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        observer = ConnectivityPlusObserver.withConnectivity(mockConnectivity);

        // Act
        final emissions = <ConnectivityStatus>[];
        observer.observe().listen(emissions.add);

        await Future.delayed(const Duration(milliseconds: 50));
        observer.dispose();

        // Try to emit after dispose
        connectivityController.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - should only have initial emission
        expect(emissions, [ConnectivityStatus.online]);
      });
    });

    group('re-subscription', () {
      test(
        'should wait for fresh check after subscription was disposed',
        () async {
          // Arrange - connectivity changes between subscriptions
          var checkCount = 0;
          when(() => mockConnectivity.checkConnectivity()).thenAnswer((
            _,
          ) async {
            checkCount++;
            // Both checks return online
            return [ConnectivityResult.wifi];
          });

          observer = ConnectivityPlusObserver.withConnectivity(
            mockConnectivity,
          );

          // Act - first subscription
          final emissions1 = <ConnectivityStatus>[];
          final sub1 = observer.observe().listen(emissions1.add);

          await Future.delayed(const Duration(milliseconds: 50));

          // Change to offline while subscribed
          connectivityController.add([ConnectivityResult.none]);
          await Future.delayed(const Duration(milliseconds: 50));

          // Cancel first subscription (releases connectivity_plus subscription)
          await sub1.cancel();

          // New subscription after dispose:
          // Should NOT emit stale "offline" status
          // Should wait for fresh checkConnectivity() which returns "online"
          final emissions2 = <ConnectivityStatus>[];
          final sub2 = observer.observe().listen(emissions2.add);

          await Future.delayed(const Duration(milliseconds: 50));

          await sub2.cancel();

          // Assert
          expect(emissions1, [
            ConnectivityStatus.online, // Initial check
            ConnectivityStatus.offline, // Stream event
          ]);
          // After re-subscribe, waits for fresh data (not stale offline)
          expect(emissions2, [
            ConnectivityStatus.online, // Fresh check result
          ]);
          expect(checkCount, equals(2)); // Proves re-check happened
        },
      );

      test(
        'should emit current status on re-check even if different from last known',
        () async {
          // Arrange - first check online, second check offline
          var checkCount = 0;
          when(() => mockConnectivity.checkConnectivity()).thenAnswer((
            _,
          ) async {
            checkCount++;
            if (checkCount == 1) {
              return [ConnectivityResult.wifi]; // First: online
            }
            return [ConnectivityResult.none]; // Second: offline
          });

          observer = ConnectivityPlusObserver.withConnectivity(
            mockConnectivity,
          );

          // First subscription
          final emissions1 = <ConnectivityStatus>[];
          final sub1 = observer.observe().listen(emissions1.add);
          await Future.delayed(const Duration(milliseconds: 50));
          await sub1.cancel();

          // Second subscription - connectivity changed to offline
          final emissions2 = <ConnectivityStatus>[];
          final sub2 = observer.observe().listen(emissions2.add);
          await Future.delayed(const Duration(milliseconds: 50));
          await sub2.cancel();

          // Assert
          expect(emissions1, [ConnectivityStatus.online]);
          expect(emissions2, [ConnectivityStatus.offline]); // Fresh check
          expect(checkCount, equals(2));
        },
      );

      test(
        'should not duplicate emission if status unchanged after re-check',
        () async {
          // Arrange - connectivity stays the same
          when(
            () => mockConnectivity.checkConnectivity(),
          ).thenAnswer((_) async => [ConnectivityResult.wifi]);

          observer = ConnectivityPlusObserver.withConnectivity(
            mockConnectivity,
          );

          // Act - first subscription
          final emissions1 = <ConnectivityStatus>[];
          final sub1 = observer.observe().listen(emissions1.add);

          await Future.delayed(const Duration(milliseconds: 50));

          // Cancel first subscription
          await sub1.cancel();

          // New subscription - status hasn't changed (still online)
          final emissions2 = <ConnectivityStatus>[];
          final sub2 = observer.observe().listen(emissions2.add);

          await Future.delayed(const Duration(milliseconds: 50));

          await sub2.cancel();

          // Assert - both get online (fresh check each time)
          expect(emissions1, [ConnectivityStatus.online]);
          expect(emissions2, [ConnectivityStatus.online]);
        },
      );
    });
  });

  group('ConnectivityStatus', () {
    test('should have online and offline values', () {
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.online));
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.offline));
      expect(ConnectivityStatus.values.length, equals(2));
    });
  });
}
