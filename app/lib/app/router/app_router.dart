library;

import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../features/products/presentation/product_list_page.dart';
import '../../features/splash/splash_page.dart';
import 'app_routes.dart';
import 'route_transitions.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
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
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProductListPage(),
          transitionsBuilder: RouteTransitions.fade,
          transitionDuration: RouteTransitions.defaultDuration,
        ),
      ),
    ],
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
