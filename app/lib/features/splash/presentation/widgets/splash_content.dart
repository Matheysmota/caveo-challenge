import 'package:dori/dori.dart';
import 'package:flutter/widgets.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    required this.fadeAnimation,
    required this.scaleAnimation,
    super.key,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return Stack(
      children: [
        Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: DoriSvg.fishLogo(size: DoriLogoSize.lg),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: dori.spacing.md,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Center(
              child: DoriCircularProgress(
                size: DoriCircularProgressSize.lg,
                showBackground: true,
                color: dori.colors.brand.pure,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
