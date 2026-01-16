import 'package:caveo_challenge/app/app_strings.dart';
import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'di/app_providers.dart';
import 'router/app_router.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: DoriTheme.light,
      darkTheme: DoriTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
