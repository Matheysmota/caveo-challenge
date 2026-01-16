/// Governed export for go_router declarative routing.
///
/// This export is included in the main shared barrel, so use:
///
/// ```dart
/// import 'package:shared/shared.dart';
/// ```
///
/// ## Basic Usage
///
/// ```dart
/// final router = GoRouter(
///   routes: [
///     GoRoute(
///       path: '/',
///       builder: (context, state) => HomePage(),
///     ),
///   ],
/// );
///
/// MaterialApp.router(routerConfig: router);
/// ```
///
/// ## Navigation
///
/// ```dart
/// // Push a new route
/// context.push('/details');
///
/// // Replace current route (no back)
/// context.go('/home');
///
/// // Go back
/// context.pop();
/// ```
library;

export 'package:go_router/go_router.dart';
