import 'package:dori/dori.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/drivers/network/network_failure.dart';

import '../../splash_strings.dart';

class SplashErrorContent extends StatelessWidget {
  const SplashErrorContent({
    required this.failure,
    required this.onRetry,
    this.isRetrying = false,
    super.key,
  });

  final NetworkFailure failure;
  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dori.spacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: EdgeInsets.all(dori.spacing.xs),
            decoration: BoxDecoration(
              color: dori.colors.feedback.errorSoft,
              shape: BoxShape.circle,
            ),
            child: DoriIcon(
              icon: DoriIconData.error,
              size: DoriIconSize.lg,
              color: dori.colors.feedback.errorLight,
            ),
          ),
          SizedBox(height: dori.spacing.sm),
          DoriText(
            label: SplashStrings.errorTitle,
            variant: DoriTypographyVariant.title5,
            color: dori.colors.content.one,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: dori.spacing.xxs),
          DoriText(
            label: SplashStrings.errorDescription,
            variant: DoriTypographyVariant.description,
            color: dori.colors.content.two,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          DoriButton(
            label: SplashStrings.retryButton,
            isExpanded: true,
            onPressed: isRetrying ? null : onRetry,
            variant: DoriButtonVariant.primary,
            size: DoriButtonSize.md,
            isLoading: isRetrying,
          ),
        ],
      ),
    );
  }
}
