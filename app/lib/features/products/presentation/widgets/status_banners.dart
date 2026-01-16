import 'package:dori/dori.dart';
import 'package:flutter/material.dart';

import '../../product_list_strings.dart';

class StatusBanners extends StatelessWidget {
  const StatusBanners({
    required this.isOffline,
    required this.isDataStale,
    this.onDismissStale,
    super.key,
  });

  final bool isOffline;
  final bool isDataStale;
  final VoidCallback? onDismissStale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isOffline)
          DoriStatusFeedbackBanner(
            message: ProductListStrings.offlineBanner,
            variant: DoriStatusFeedbackBannerVariant.info,
          ),
        if (isDataStale)
          DoriStatusFeedbackBanner(
            message: ProductListStrings.staleDataBanner,
            variant: DoriStatusFeedbackBannerVariant.warning,
            isDismissible: true,
            onDismiss: onDismissStale,
          ),
      ],
    );
  }
}
