/// Re-exports mocktail for use in tests.
///
/// Import this file instead of importing mocktail directly
/// to comply with the library governance policy (ADR 003).
///
/// Usage:
/// ```dart
/// import 'package:shared/libraries/mocktail_export.dart';
///
/// class MockRepository extends Mock implements IRepository {}
/// ```
library;

export 'package:mocktail/mocktail.dart';
