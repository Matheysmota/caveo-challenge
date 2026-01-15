/// Enum representing network connectivity status.
///
/// Used by [ConnectivityObserver] to communicate the current
/// network state to the UI layer.
///
/// See ADR 010 (documents/adrs/010-connectivity-observer.md)
/// for architecture decisions.
library;

/// Represents the current network connectivity status.
enum ConnectivityStatus {
  /// Device has network connectivity (Wi-Fi, Mobile Data, Ethernet, etc.)
  ///
  /// Note: Being online does not guarantee API availability.
  /// The API might still be unreachable due to firewall, server issues, etc.
  online,

  /// Device has no network connectivity.
  ///
  /// When offline, the app should:
  /// - Display an "Você está offline" banner
  /// - Use cached data if available
  offline,
}
