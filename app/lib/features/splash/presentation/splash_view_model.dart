import 'dart:async';

import 'package:shared/drivers/network/network_failure.dart';
import 'package:shared/libraries/result_export/result_export.dart';
import 'package:shared/libraries/riverpod_export/riverpod_export.dart';

import '../../../app/app_strings.dart';
import 'splash_state.dart';

abstract final class SplashConfig {
  static const minimumDisplayDuration = Duration(seconds: 1);
  static const timeoutDuration = Duration(seconds: 10);
}

final splashViewModelProvider = NotifierProvider<SplashViewModel, SplashState>(
  SplashViewModel.new,
);

class SplashViewModel extends Notifier<SplashState> {
  Timer? _minimumDisplayTimer;
  Timer? _timeoutTimer;
  bool _initComplete = false;
  bool _minTimeElapsed = false;
  Result<void, NetworkFailure>? _result;

  @override
  SplashState build() {
    ref.onDispose(_cancelTimers);
    _startInitialization();
    return const SplashReady();
  }

  void retry() {
    _reset();
    state = const SplashReady();
    _startInitialization();
  }

  void _reset() {
    _cancelTimers();
    _initComplete = false;
    _minTimeElapsed = false;
    _result = null;
  }

  void _startInitialization() {
    _minimumDisplayTimer = Timer(SplashConfig.minimumDisplayDuration, () {
      _minTimeElapsed = true;
      _tryFinalize();
    });

    _timeoutTimer = Timer(SplashConfig.timeoutDuration, _handleTimeout);

    _executeInit();
  }

  Future<void> _executeInit() async {
    // TODO(PR3): Call ProductRepository.getProducts()
    await Future<void>.delayed(const Duration(milliseconds: 100));

    _initComplete = true;
    _result = const Success(null);
    _timeoutTimer?.cancel();
    _tryFinalize();
  }

  void _tryFinalize() {
    if (!_minTimeElapsed || !_initComplete) return;

    final result = _result;
    if (result == null) return;

    state = result.fold(
      (_) => const SplashReady(),
      (failure) => SplashError(failure: failure),
    );
  }

  void _handleTimeout() {
    _initComplete = true;
    _result = const Failure(TimeoutFailure(message: SplashStrings.timeout));
    _tryFinalize();
  }

  void _cancelTimers() {
    _minimumDisplayTimer?.cancel();
    _minimumDisplayTimer = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }
}
