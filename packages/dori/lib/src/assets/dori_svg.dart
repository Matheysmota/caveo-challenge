import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/dori_provider.dart';
import 'dori_assets.dart';
import 'dori_logo_size.dart';

class DoriSvg extends StatelessWidget {
  const DoriSvg({
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
    super.key,
  }) : _useBrandColor = false;

  DoriSvg.fishLogo({
    required DoriLogoSize size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel = 'Fish logo',
    super.key,
  }) : assetPath = DoriAssets.fishLogo,
       width = size.dimension,
       height = size.dimension,
       color = null,
       _useBrandColor = true;

  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;
  final String? semanticLabel;
  final bool _useBrandColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _useBrandColor
        ? context.dori.colors.content.pure
        : color;

    return SvgPicture.asset(
      assetPath,
      package: 'dori',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticsLabel: semanticLabel,
      colorFilter: effectiveColor != null
          ? ColorFilter.mode(effectiveColor, BlendMode.srcIn)
          : null,
    );
  }
}
