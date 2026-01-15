/// Abstract interface for monitoring network connectivity.
///
/// Provides a reactive stream-based API for observing network
/// connectivity changes in real-time.
///
/// Implementations should:
/// - Emit the current status immediately upon subscription (BehaviorSubject-like)
/// - Emit new values whenever connectivity status changes
/// - Handle platform-specific connectivity APIs internally
///
/// See ADR 010 (documents/adrs/010-connectivity-observer.md)
/// for architecture decisions.
library;

import 'connectivity_status.dart';

/// Abstract interface for monitoring network connectivity.
///
/// The stream follows a BehaviorSubject-like pattern:
/// - Emits current status immediately on subscription
/// - Emits new status whenever connectivity changes
///
/// ## Example
///
/// ```dart
/// final observer = ref.watch(connectivityObserverProvider);
///
/// StreamBuilder<ConnectivityStatus>(
///   stream: observer.observe(),
///   builder: (context, snapshot) {
///     final isOffline = snapshot.data == ConnectivityStatus.offline;
///     return isOffline
///         ? DoriBanner.warning("Você está offline")
///         : const SizedBox.shrink();
///   },
/// );
/// ```
abstract class ConnectivityObserver {
  /// Returns a stream that emits connectivity status.
  ///
  /// The stream:
  /// - Emits current status immediately on subscription
  /// - Emits new status whenever connectivity changes
  /// - Never completes (unless [dispose] is called)
  ///
  /// Multiple subscriptions share the same underlying stream.
  Stream<ConnectivityStatus> observe();

  /// Releases resources used by the observer.
  ///
  /// After calling dispose:
  /// - The stream will complete
  /// - No further status updates will be emitted
  /// - Calling [observe] may throw or return a closed stream
  void dispose();
}
