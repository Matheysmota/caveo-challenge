/// Splash screen state management with minimum display time and timeout.
library;

import 'dart:async';

import 'package:shared/shared.dart';

import '../../../app/di/modules/products_module.dart';
import '../../../main.dart';
import '../../products/domain/entities/product.dart';
import '../splash_strings.dart';
import 'splash_state.dart';

abstract final class SplashConfig {
  static const minimumDisplayDuration = Duration(seconds: 1);
  static const timeoutDuration = Duration(seconds: 10);
  static const cacheRetryDelay = Duration(milliseconds: 50);
}

final splashViewModelProvider = NotifierProvider<SplashViewModel, SplashState>(
  SplashViewModel.new,
);

/// Manages splash initialization by watching SyncStore and coordinating timers.
class SplashViewModel extends Notifier<SplashState> {
  Timer? _minimumDisplayTimer;
  Timer? _timeoutTimer;
  Timer? _cacheRetryTimer;
  StreamSubscription<SyncState<List<Product>>>? _syncSubscription;

  bool _syncComplete = false;
  bool _minTimeElapsed = false;
  SyncState<List<Product>>? _lastSyncState;
  bool _isDisposed = false;

  @override
  SplashState build() {
    ref.onDispose(_dispose);
    _startInitialization();
    return const SplashLoading();
  }

  void retry() {
    final currentState = state;
    if (currentState is! SplashError) return;

    state = SplashError(failure: currentState.failure, isRetrying: true);
    _reset();
    _startInitialization();
  }

  void _reset() {
    _cancelTimers();
    _syncSubscription?.cancel();
    _syncSubscription = null;
    _syncComplete = false;
    _minTimeElapsed = false;
    _lastSyncState = null;
    _isDisposed = false;
  }

  void _startInitialization() {
    _minimumDisplayTimer = Timer(SplashConfig.minimumDisplayDuration, () {
      _minTimeElapsed = true;
      _tryFinalize();
    });

    _timeoutTimer = Timer(SplashConfig.timeoutDuration, _handleTimeout);
    _startSync();
  }

  void _startSync() {
    if (_isDisposed) return;

    final isRegistered = ref.read(productSyncRegistrarProvider);

    if (!isRegistered) {
      _cacheRetryTimer?.cancel();
      _cacheRetryTimer = Timer(SplashConfig.cacheRetryDelay, () {
        if (!_syncComplete && !_isDisposed) {
          _startSync();
        }
      });
      return;
    }

    final syncStore = ref.read(syncStoreProvider);

    _syncSubscription = syncStore
        .watch<List<Product>>(SyncStoreKey.products)
        .listen((syncState) {
          _lastSyncState = syncState;

          if (syncState.isSuccess || syncState.isError) {
            _syncComplete = true;
            _timeoutTimer?.cancel();
            _tryFinalize();
          }
        });

    syncStore.sync<List<Product>>(SyncStoreKey.products);
  }

  void _tryFinalize() {
    if (!_minTimeElapsed || !_syncComplete) return;

    final syncState = _lastSyncState;
    if (syncState == null) return;

    state = switch (syncState) {
      SyncStateSuccess() => const SplashSuccess(),
      SyncStateError(:final failure) => SplashError(failure: failure),
      _ => const SplashLoading(),
    };
  }

  void _handleTimeout() {
    _syncComplete = true;
    _lastSyncState = const SyncStateError(
      TimeoutFailure(message: SplashStrings.timeout),
    );
    _tryFinalize();
  }

  void _cancelTimers() {
    _minimumDisplayTimer?.cancel();
    _minimumDisplayTimer = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _cacheRetryTimer?.cancel();
    _cacheRetryTimer = null;
  }

  void _dispose() {
    _isDisposed = true;
    _cancelTimers();
    _syncSubscription?.cancel();
    _syncSubscription = null;
  }
}
