import 'package:caveo_challenge/app/app_strings.dart';
import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'di/app_providers.dart';
import 'router/app_router.dart';

/// Root widget of the Fish application.
///
/// Configures:
/// - Theme (light/dark with Dori Design System)
/// - Router (go_router for declarative navigation)
/// - Global providers
///
/// ## Theme
///
/// Uses Dori Design System themes with persistence.
/// Theme preference is automatically saved and restored.
///
/// ## Navigation
///
/// Uses go_router for declarative routing. See [appRouterProvider]
/// for route configuration.
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      // App Info
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: DoriTheme.light,
      darkTheme: DoriTheme.dark,
      themeMode: themeMode,

      // Router Configuration
      routerConfig: router,
    );
  }
}
