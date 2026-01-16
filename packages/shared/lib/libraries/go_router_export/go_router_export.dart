/// Governed export for go_router declarative routing.
///
/// Use this export instead of importing `package:go_router` directly.
///
/// ```dart
/// import 'package:shared/libraries/go_router_export.dart';
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
