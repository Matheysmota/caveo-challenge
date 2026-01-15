/// Implementation of [ConnectivityObserver] using connectivity_plus.
///
/// This file is PRIVATE and should not be exported directly.
/// Use dependency injection to provide this implementation.
///
/// See ADR 010 (documents/adrs/010-connectivity-observer.md)
/// for architecture decisions.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../drivers/connectivity/connectivity_observer.dart';
import '../../../drivers/connectivity/connectivity_status.dart';

/// Implementation of [ConnectivityObserver] using the connectivity_plus package.
///
/// This implementation:
/// - Uses a BehaviorSubject-like pattern (emits current value on subscription)
/// - Deduplicates consecutive identical status updates
/// - Handles multiple connectivity results (e.g., WiFi + Mobile simultaneously)
class ConnectivityPlusObserver implements ConnectivityObserver {
    ConnectivityPlusObserver() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  StreamController<ConnectivityStatus>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  ConnectivityStatus? _lastStatus;

  /// Creates an instance with the default [Connectivity] instance.

  /// Creates an instance with a custom [Connectivity] instance.
  ///
  /// Useful for testing with mocked Connectivity.
  ConnectivityPlusObserver.withConnectivity(this._connectivity);

  @override
  Stream<ConnectivityStatus> observe() {
    _controller ??= _createController();
    return _controller!.stream;
  }

  StreamController<ConnectivityStatus> _createController() {
    final controller = StreamController<ConnectivityStatus>.broadcast(
      onListen: _onFirstListener,
      onCancel: _onLastListenerCanceled,
    );
    return controller;
  }

  Future<void> _onFirstListener() async {
    // Emit current status immediately
    final currentResults = await _connectivity.checkConnectivity();
    final currentStatus = _mapToStatus(currentResults);
    _emitIfChanged(currentStatus);

    // Subscribe to future changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapToStatus(results);
      _emitIfChanged(status);
    });
  }

  void _onLastListenerCanceled() {
    // Keep subscription alive even without listeners
    // This prevents re-checking connectivity on each new subscription
  }

  void _emitIfChanged(ConnectivityStatus status) {
    if (_lastStatus != status) {
      _lastStatus = status;
      _controller?.add(status);
    }
  }

  /// Maps connectivity_plus results to our domain enum.
  ///
  /// Returns [ConnectivityStatus.online] if ANY connection type is available
  /// (e.g., WiFi, Mobile, Ethernet, VPN, etc.)
  ///
  /// Returns [ConnectivityStatus.offline] only when explicitly disconnected
  /// or when the result list is empty.
  ConnectivityStatus _mapToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return ConnectivityStatus.offline;
    }

    // Check if we have any actual connectivity
    // ConnectivityResult.none means explicitly offline
    final hasConnectivity = results.any(
      (result) => result != ConnectivityResult.none,
    );

    return hasConnectivity
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    _controller = null;
    _lastStatus = null;
  }
}
