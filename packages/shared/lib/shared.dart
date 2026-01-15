/// Shared package for Caveo Challenge.
///
/// Provides utilities, drivers, and library exports for the app.
///
/// ## Drivers
///
/// Abstraction layers for external services:
/// - [LocalCacheSource] - Local storage with TTL support
/// - [ConnectivityObserver] - Network connectivity monitoring
///
/// ## Libraries
///
/// Controlled re-exports of third-party packages:
/// - `mocktail_export.dart` - Mocking for tests
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/shared.dart';
///
/// // Or import specific modules:
/// import 'package:shared/drivers/local_cache/local_cache_export.dart';
/// import 'package:shared/drivers/connectivity/connectivity_export.dart';
/// ```
library;

// Drivers
export 'drivers/connectivity/connectivity_export.dart';
export 'drivers/local_cache/local_cache_export.dart';
