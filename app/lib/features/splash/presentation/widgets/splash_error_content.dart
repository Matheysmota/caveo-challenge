import 'package:dori/dori.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/drivers/network/network_failure.dart';

import '../../../../app/app_strings.dart';

class SplashErrorContent extends StatelessWidget {
  const SplashErrorContent({
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final NetworkFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dori.spacing.xs),
      child: Column(
        children: [
          SizedBox(height: dori.spacing.sm),
          DoriIcon(
            icon: DoriIconData.error,
            size: DoriIconSize.lg,
            color: dori.colors.feedback.error,
          ),
          SizedBox(height: dori.spacing.sm),
          DoriText(
            label: failure.message,
            variant: DoriTypographyVariant.description,
            color: dori.colors.content.two,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          DoriButton(
            label: SplashStrings.retryButton,
            isExpanded: true,
            onPressed: onRetry,
            variant: DoriButtonVariant.primary,
            size: DoriButtonSize.md,
          ),
        ],
      ),
    );
  }
}
