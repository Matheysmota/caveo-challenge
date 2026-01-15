/// Connectivity monitoring driver exports.
///
/// Provides an abstraction layer for monitoring network connectivity
/// status in real-time using a reactive stream-based API.
///
/// See ADR 010 (documents/adrs/010-connectivity-observer.md)
/// for architecture decisions.
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/drivers/connectivity/connectivity_export.dart';
///
/// class MyWidget extends StatelessWidget {
///   final ConnectivityObserver connectivityObserver;
///
///   @override
///   Widget build(BuildContext context) {
///     return StreamBuilder<ConnectivityStatus>(
///       stream: connectivityObserver.observe(),
///       builder: (context, snapshot) {
///         final isOffline = snapshot.data == ConnectivityStatus.offline;
///         return isOffline
///             ? DoriBanner.warning("Você está offline")
///             : const SizedBox.shrink();
///       },
///     );
///   }
/// }
/// ```
library;

export 'connectivity_observer.dart';
export 'connectivity_status.dart';
