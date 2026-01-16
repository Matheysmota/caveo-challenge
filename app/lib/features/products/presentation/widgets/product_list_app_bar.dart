import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../../../app/di/modules/theme_module.dart';
import '../../product_list_strings.dart';

class ProductListAppBar extends ConsumerWidget {
  const ProductListAppBar({this.onSearch, super.key});

  final ValueChanged<String>? onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dori = context.dori;

    return Container(
      color: dori.colors.surface.one,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Logo + Theme Toggle
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DoriSpacing.sm,
              vertical: DoriSpacing.xs,
            ),
            child: Row(
              children: [
                DoriSvg.fishLogo(size: DoriLogoSize.md),
                const Spacer(),
                const _ThemeToggle(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DoriSpacing.sm),
            child: DoriSearchBar(
              hintText: ProductListStrings.searchHint,
              onSearch: onSearch ?? (_) {},
              semanticLabel: ProductListStrings.searchSemanticLabel,
            ),
          ),

          const SizedBox(height: DoriSpacing.xs),
        ],
      ),
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  static const lightSemanticLabel = 'Mudar para tema claro';
  static const darkSemanticLabel = 'Mudar para tema escuro';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return DoriIconButton(
      icon: isDark ? DoriIconData.lightMode : DoriIconData.darkMode,
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggle();
      },
      semanticLabel: isDark ? lightSemanticLabel : darkSemanticLabel,
    );
  }
}
