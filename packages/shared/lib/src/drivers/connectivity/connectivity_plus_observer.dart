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
/// - Uses a BehaviorSubject-like pattern (emits current/last known value on subscription)
/// - Deduplicates consecutive identical status updates
/// - Handles multiple connectivity results (e.g., WiFi + Mobile simultaneously)
/// - Lazy initialization (only subscribes when first observer connects)
/// - Resource-efficient (releases subscription when no listeners)
///
/// ## Resource Management
///
/// When all listeners cancel, the underlying connectivity_plus subscription
/// is released. When a new listener subscribes:
/// 1. Last known status is emitted immediately (if available)
/// 2. Current connectivity is checked asynchronously
/// 3. A new subscription to connectivity_plus is created
///
/// This approach prioritizes resource efficiency. The cost of re-checking
/// connectivity is minimal (single platform call).
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
    // Emit last known status immediately for BehaviorSubject-like behavior
    if (_lastStatus != null) {
      _controller?.add(_lastStatus!);
      _startSubscription();
      return;
    }

    // First time: check current connectivity BEFORE starting subscription
    // to avoid race condition where stream emits during async check
    final currentResults = await _connectivity.checkConnectivity();
    final currentStatus = _mapToStatus(currentResults);
    _emitIfChanged(currentStatus);

    // Only start listening to changes AFTER initial state is emitted
    _startSubscription();
  }

  void _startSubscription() {
    _subscription ??= _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapToStatus(results);
      _emitIfChanged(status);
    });
  }

  void _onLastListenerCanceled() {
    _subscription?.cancel();
    _subscription = null;
    _lastStatus = null;
  }

  void _emitIfChanged(ConnectivityStatus status) {
    if (_lastStatus != status) {
      _lastStatus = status;
      _controller?.add(status);
    }
  }

  /// Connection types that provide internet access.
  ///
  /// These are the connection types we consider as "online":
  /// - wifi: Wi-Fi network
  /// - mobile: Cellular data (3G, 4G, 5G)
  /// - ethernet: Wired network connection
  /// - vpn: VPN tunnel (requires underlying wifi/mobile/ethernet)
  /// - other: Unknown network type (conservative approach: assume it has internet)
  ///
  /// Excluded:
  /// - bluetooth: Does not provide internet access by itself
  /// - none: Explicitly offline
  static const _internetConnectionTypes = {
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.ethernet,
    ConnectivityResult.vpn,
    ConnectivityResult.other,
  };

  /// Maps connectivity_plus results to our domain enum.
  ///
  /// Returns [ConnectivityStatus.online] if any internet-capable connection
  /// is available (WiFi, Mobile, Ethernet, VPN).
  ///
  /// Returns [ConnectivityStatus.offline] when:
  /// - The result list is empty
  /// - Only non-internet connections exist (e.g., Bluetooth only)
  /// - Explicitly disconnected (ConnectivityResult.none)
  ///
  /// Note: Bluetooth is NOT considered as online because it doesn't
  /// provide internet access by itself.
  ConnectivityStatus _mapToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return ConnectivityStatus.offline;
    }

    final hasInternetConnection = results.any(
      (result) => _internetConnectionTypes.contains(result),
    );

    return hasInternetConnection
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
