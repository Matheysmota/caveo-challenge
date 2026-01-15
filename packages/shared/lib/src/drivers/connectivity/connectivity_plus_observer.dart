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
/// - Lazy initialization (only subscribes when first observer connects)
///
/// ## Singleton Pattern
///
/// This class should be instantiated ONCE and provided via DI (Riverpod).
/// The [Connectivity] instance from connectivity_plus is internally a singleton,
/// but this wrapper manages its own stream transformation and state.
///
/// ```dart
/// // In your providers file:
/// final connectivityObserverProvider = Provider<ConnectivityObserver>((ref) {
///   final observer = ConnectivityPlusObserver();
///   ref.onDispose(() => observer.dispose());
///   return observer;
/// });
/// ```
class ConnectivityPlusObserver implements ConnectivityObserver {
  /// Creates an instance using the default [Connectivity] singleton.
  ///
  /// This is the recommended constructor for production use.
  /// The [Connectivity] class from connectivity_plus is already a singleton
  /// internally, so multiple calls to this constructor are safe but wasteful.
  ///
  /// Prefer creating a single instance via DI (Riverpod Provider).
  ConnectivityPlusObserver() : _connectivity = Connectivity();

  /// Creates an instance with a custom [Connectivity] instance.
  ///
  /// Useful for testing with mocked Connectivity.
  ConnectivityPlusObserver.withConnectivity(this._connectivity);

  final Connectivity _connectivity;

  StreamController<ConnectivityStatus>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  ConnectivityStatus? _lastStatus;
  bool _isInitialized = false;

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
    // Guard against multiple initializations
    // (can happen if all listeners cancel then a new one subscribes)
    if (_isInitialized) {
      // Re-emit last known status for new subscribers
      if (_lastStatus != null) {
        _controller?.add(_lastStatus!);
      }
      return;
    }
    _isInitialized = true;

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
    // Keep subscription alive even without listeners.
    //
    // Resource implications:
    // - The underlying connectivity_plus stream subscription remains active
    //   even when there are no external listeners to this observer.
    // - Cleanup (subscription cancel + controller close) happens only in
    //   [dispose], so this instance should be scoped and disposed properly
    //   by the DI container (e.g., Riverpod provider).
    //
    // Trade-off:
    // - Pros: avoids re-checking connectivity and re-subscribing to the
    //   connectivity_plus stream every time a new listener subscribes.
    // - Cons: keeps the connectivity_plus stream active in the background,
    //   which may use a small amount of memory and processing even with
    //   zero listeners.
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
    _isInitialized = false;
  }
}
