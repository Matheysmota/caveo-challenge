import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../app/router/app_routes.dart';
import 'presentation/splash_state.dart';
import 'presentation/splash_view_model.dart';
import 'presentation/widgets/splash_content.dart';
import 'presentation/widgets/splash_error_content.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);

    ref.listen<SplashState>(splashViewModelProvider, (_, next) {
      if (next is SplashSuccess) context.go(AppRoutes.products);
    });

    return Scaffold(
      backgroundColor: context.dori.colors.surface.one,
      body: SafeArea(
        child: switch (state) {
          SplashLoading() => SplashContent(
            fadeAnimation: _fade,
            scaleAnimation: _scale,
          ),
          SplashSuccess() => SplashContent(
            fadeAnimation: _fade,
            scaleAnimation: _scale,
          ),
          SplashError(:final failure) => SplashErrorContent(
            failure: failure,
            onRetry: ref.read(splashViewModelProvider.notifier).retry,
          ),
        },
      ),
    );
  }
}
