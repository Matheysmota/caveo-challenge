/// Splash screen state management.
///
/// Handles the initialization flow by watching SyncStore state
/// and coordinating minimum display time requirements.
///
/// ## Responsibilities
///
/// 1. Register product syncer and trigger initial sync
/// 2. Wait for minimum display duration (branding requirements)
/// 3. Watch sync state and transition to appropriate state
/// 4. Handle timeout if sync takes too long
/// 5. Support retry on error
///
/// ## State Flow
///
/// ```
/// SplashLoading ──► (sync + min time) ──► SplashSuccess (navigate)
///                                     └──► SplashError (retry)
/// ```
library;

import 'dart:async';

import 'package:shared/shared.dart';

import '../../../app/app_strings.dart';
import '../../../app/di/modules/products_module.dart';
import '../../../main.dart';
import '../../products/domain/entities/product.dart';
import 'splash_state.dart';

/// Configuration constants for splash screen behavior.
abstract final class SplashConfig {
  /// Minimum time to display splash screen for branding.
  static const minimumDisplayDuration = Duration(seconds: 1);

  /// Maximum time to wait for sync before showing error.
  static const timeoutDuration = Duration(seconds: 10);
}

/// Provider for splash view model.
final splashViewModelProvider = NotifierProvider<SplashViewModel, SplashState>(
  SplashViewModel.new,
);

/// Manages splash screen state during app initialization.
///
/// Uses [SyncStore] to observe initial data synchronization state
/// while respecting minimum display duration requirements.
class SplashViewModel extends Notifier<SplashState> {
  Timer? _minimumDisplayTimer;
  Timer? _timeoutTimer;
  StreamSubscription<SyncState<List<Product>>>? _syncSubscription;

  bool _syncComplete = false;
  bool _minTimeElapsed = false;
  SyncState<List<Product>>? _lastSyncState;

  @override
  SplashState build() {
    ref.onDispose(_dispose);
    _startInitialization();
    return const SplashLoading();
  }

  /// Retries the sync operation after an error.
  ///
  /// Sets the button to loading state while keeping the error screen visible,
  /// then proceeds with sync. If sync fails again, updates the error.
  /// If sync succeeds, transitions to success state.
  void retry() {
    final currentState = state;
    if (currentState is! SplashError) return;

    // Show loading on the retry button, not full screen loading
    state = SplashError(failure: currentState.failure, isRetrying: true);

    _reset();
    _startInitialization();
  }

  void _reset() {
    _dispose();
    _syncComplete = false;
    _minTimeElapsed = false;
    _lastSyncState = null;
  }

  void _startInitialization() {
    // Start minimum display timer
    _minimumDisplayTimer = Timer(SplashConfig.minimumDisplayDuration, () {
      _minTimeElapsed = true;
      _tryFinalize();
    });

    // Start timeout timer
    _timeoutTimer = Timer(SplashConfig.timeoutDuration, _handleTimeout);

    // Register syncer and start sync
    _startSync();
  }

  void _startSync() {
    // Try to register syncer - it may return false if cache isn't ready yet
    final isRegistered = ref.read(productSyncRegistrarProvider);

    if (!isRegistered) {
      // Cache not ready yet, wait and retry
      Future.delayed(const Duration(milliseconds: 50), () {
        if (!_syncComplete) {
          _startSync();
        }
      });
      return;
    }

    final syncStore = ref.read(syncStoreProvider);

    // Watch sync state
    _syncSubscription = syncStore
        .watch<List<Product>>(SyncStoreKey.products)
        .listen((syncState) {
          _lastSyncState = syncState;

          // Mark complete when we get a terminal state
          if (syncState.isSuccess || syncState.isError) {
            _syncComplete = true;
            _timeoutTimer?.cancel();
            _tryFinalize();
          }
        });

    // Trigger sync
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

  void _dispose() {
    _minimumDisplayTimer?.cancel();
    _minimumDisplayTimer = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _syncSubscription?.cancel();
    _syncSubscription = null;
  }
}
