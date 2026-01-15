import 'package:flutter/material.dart';

import '../../atoms/icon/dori_icon.dart';
import '../../atoms/shimmer/dori_shimmer.dart';
import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_radius.dart';
import '../../tokens/dori_shadows.dart';

/// Internal image widget for DoriProductCard with shimmer loading state.
///
/// Displays the product image with rounded corners and shadow,
/// handling loading and error states gracefully.
///
/// The shimmer animation provides a modern loading experience
/// instead of a traditional spinner.
class ProductCardImage extends StatelessWidget {
  /// Creates a product card image widget.
  const ProductCardImage({
    required this.imageUrl,
    required this.aspectRatio,
    this.imageBuilder,
    super.key,
  });

  /// URL of the image to display.
  final String imageUrl;

  /// Aspect ratio for the image container (width / height).
  final double aspectRatio;

  /// Optional custom image builder.
  ///
  /// Use this to provide custom loading/error states or image caching.
  /// If not provided, uses default [Image.network] with shimmer loading.
  final Widget Function(BuildContext context, String url)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: DoriRadius.lg,
          boxShadow: DoriShadows.of(context).sm,
        ),
        child: ClipRRect(
          borderRadius: DoriRadius.lg,
          child:
              imageBuilder?.call(context, imageUrl) ??
              _DefaultProductImage(imageUrl: imageUrl),
        ),
      ),
    );
  }
}

/// Default image widget with shimmer loading and error handling.
///
/// Separated into its own StatefulWidget so the shimmer animation
/// is only created when actually needed (during loading state).
class _DefaultProductImage extends StatelessWidget {
  const _DefaultProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        // Shimmer is only instantiated during loading
        return const DoriShimmer();
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: dori.colors.surface.two,
          child: Center(
            child: DoriIcon(
              icon: DoriIconData.close,
              color: dori.colors.content.two,
              size: DoriIconSize.lg,
            ),
          ),
        );
      },
    );
  }
}
