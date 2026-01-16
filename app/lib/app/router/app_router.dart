/// App Router Configuration.
///
/// Configures go_router for declarative navigation throughout the app.
/// Uses Riverpod for dependency injection, allowing easy testing and mocking.
///
/// ## Route Structure
///
/// ```
/// /                    → SplashPage (initial)
/// /products            → ProductsPage
/// /products/:id        → ProductDetailsPage
/// ```
///
/// ## Usage
///
/// ```dart
/// // In AppWidget
/// final router = ref.watch(appRouterProvider);
/// return MaterialApp.router(routerConfig: router);
///
/// // Navigation
/// context.go(AppRoutes.products);
/// context.push(AppRoutes.productDetailsPath('123'));
/// context.pop();
/// ```
library;

import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../features/splash/splash_page.dart';
import 'app_routes.dart';
import 'route_transitions.dart';

/// Provider for the app router.
///
/// Using Riverpod allows:
/// - Dependency injection of the router
/// - Easy mocking in tests
/// - Access to other providers if needed for redirects
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true, // TODO: Disable in production
    routes: [
      // ─────────────────────────────────────────────────────────────────────
      // Splash (Initial Route)
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: RouteTransitions.fade,
          transitionDuration: RouteTransitions.defaultDuration,
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // Products
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child:
              const _ProductsPlaceholder(), // Will be replaced with ProductsPage
          transitionsBuilder: RouteTransitions.fade,
          transitionDuration: RouteTransitions.defaultDuration,
        ),
        routes: [
          // ─────────────────────────────────────────────────────────────────
          // Product Details (Nested)
          // ─────────────────────────────────────────────────────────────────
          GoRoute(
            path: ':id',
            name: 'productDetails',
            pageBuilder: (context, state) {
              final productId = state.pathParameters['id']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: _ProductDetailsPlaceholder(
                  id: productId,
                ), // Will be replaced with ProductDetailsPage
                transitionsBuilder: RouteTransitions.slideUp,
                transitionDuration: RouteTransitions.defaultDuration,
              );
            },
          ),
        ],
      ),
    ],

    // ─────────────────────────────────────────────────────────────────────────
    // Error Handler
    // ─────────────────────────────────────────────────────────────────────────
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Route not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder Widgets (to be replaced with actual pages)
// ─────────────────────────────────────────────────────────────────────────────

/// Placeholder for Products page.
/// TODO: Replace with actual ProductsPage in future PR.
class _ProductsPlaceholder extends StatelessWidget {
  const _ProductsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(child: Text('Products Page Placeholder')),
    );
  }
}

/// Placeholder for Product Details page.
/// TODO: Replace with actual ProductDetailsPage in future PR.
class _ProductDetailsPlaceholder extends StatelessWidget {
  final String id;

  const _ProductDetailsPlaceholder({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Center(child: Text('Product Details Placeholder\nID: $id')),
    );
  }
}
