import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Story for visualizing the DoriSearchBar molecule
@widgetbook.UseCase(
  name: 'Search Bar Showcase',
  type: DoriSearchBarShowcase,
  path: '[Molecules]',
)
Widget buildDoriSearchBarShowcase(BuildContext context) {
  return const DoriSearchBarShowcase();
}

/// Widget showcase for DoriSearchBar - displays all configurations and states
class DoriSearchBarShowcase extends StatefulWidget {
  const DoriSearchBarShowcase({super.key});

  @override
  State<DoriSearchBarShowcase> createState() => _DoriSearchBarShowcaseState();
}

class _DoriSearchBarShowcaseState extends State<DoriSearchBarShowcase> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  String _searchedQuery = '';
  String _changedText = '';

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.dori.colors;
    final isDark = context.dori.isDark;

    return Container(
      color: colors.surface.pure,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DoriSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DoriText(
              label: 'DoriSearchBar',
              variant: DoriTypographyVariant.title5,
              color: colors.content.one,
            ),
            SizedBox(height: DoriSpacing.xxxs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DoriSpacing.xxs,
                vertical: DoriSpacing.xxxs,
              ),
              decoration: BoxDecoration(
                color: isDark ? colors.brand.two : colors.brand.pure,
                borderRadius: DoriRadius.sm,
              ),
              child: DoriText(
                label: isDark ? 'Dark Mode' : 'Light Mode',
                variant: DoriTypographyVariant.captionBold,
                color: isDark ? colors.brand.pure : Colors.white,
              ),
            ),
            SizedBox(height: DoriSpacing.md),

            // Interactive Demo Section
            _buildSectionHeader('Interactive Demo', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildInteractiveDemoSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Default Section
            _buildSectionHeader('Default Configuration', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildDefaultSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Custom Hint Text Section
            _buildSectionHeader('Custom Hint Text', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildCustomHintTextSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Disabled State Section
            _buildSectionHeader('Disabled State', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildDisabledSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Focus Control Section
            _buildSectionHeader('Focus Control', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildFocusControlSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Tap Outside Behavior Section
            _buildSectionHeader('Tap Outside Behavior', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildTapOutsideBehaviorSection(colors),

            SizedBox(height: DoriSpacing.md),

            // Custom Debounce Section
            _buildSectionHeader('Custom Debounce Settings', colors),
            SizedBox(height: DoriSpacing.xs),
            _buildCustomDebounceSection(colors),

            SizedBox(height: DoriSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, DoriColorScheme colors) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: colors.brand.pure,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: DoriSpacing.xxs),
        DoriText(
          label: title,
          variant: DoriTypographyVariant.descriptionBold,
          color: colors.content.one,
        ),
      ],
    );
  }

  Widget _buildInteractiveDemoSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
        boxShadow: DoriShadows.light.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Type to test debounce behavior (3+ chars, 400ms delay)',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            controller: _controller,
            focusNode: _focusNode,
            hintText: 'Search products...',
            onSearch: (query) {
              setState(() {
                _searchedQuery = query;
              });
            },
            onChanged: (text) {
              setState(() {
                _changedText = text;
              });
            },
          ),
          SizedBox(height: DoriSpacing.xs),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(DoriSpacing.xxs),
            decoration: BoxDecoration(
              color: colors.surface.two,
              borderRadius: DoriRadius.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DoriText(
                      label: 'onChange: ',
                      variant: DoriTypographyVariant.captionBold,
                      color: colors.content.two,
                    ),
                    Expanded(
                      child: DoriText(
                        label: _changedText.isEmpty
                            ? '(empty)'
                            : '"$_changedText"',
                        variant: DoriTypographyVariant.caption,
                        color: colors.content.one,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DoriSpacing.xxxs),
                Row(
                  children: [
                    DoriText(
                      label: 'onSearch: ',
                      variant: DoriTypographyVariant.captionBold,
                      color: colors.content.two,
                    ),
                    Expanded(
                      child: DoriText(
                        label: _searchedQuery.isEmpty
                            ? '(waiting for 3+ chars...)'
                            : '"$_searchedQuery"',
                        variant: DoriTypographyVariant.caption,
                        color: _searchedQuery.isEmpty
                            ? colors.content.two
                            : colors.feedback.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: DoriSpacing.xs),
          Row(
            children: [
              DoriButton(
                label: 'Focus',
                variant: DoriButtonVariant.secondary,
                size: DoriButtonSize.sm,
                onPressed: () => _focusNode.requestFocus(),
              ),
              SizedBox(width: DoriSpacing.xxs),
              DoriButton(
                label: 'Unfocus',
                variant: DoriButtonVariant.secondary,
                size: DoriButtonSize.sm,
                onPressed: () => _focusNode.unfocus(),
              ),
              SizedBox(width: DoriSpacing.xxs),
              DoriButton(
                label: 'Clear',
                variant: DoriButtonVariant.tertiary,
                size: DoriButtonSize.sm,
                onPressed: () {
                  _controller.clear();
                  setState(() {
                    _searchedQuery = '';
                    _changedText = '';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Default hintText: "Search"',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(onSearch: (_) {}),
        ],
      ),
    );
  }

  Widget _buildCustomHintTextSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriSearchBar(hintText: 'Search for products...', onSearch: (_) {}),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Filter by name or category...',
            onSearch: (_) {},
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Digite o código do produto...',
            onSearch: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Disabled search bars cannot receive input',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            enabled: false,
            hintText: 'Search disabled...',
            onSearch: (_) {},
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            enabled: false,
            controller: TextEditingController(text: 'Pre-filled disabled'),
            onSearch: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildFocusControlSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Auto-focus example (autofocus: true)',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriText(
            label:
                'Note: autoFocus should be used sparingly, only when search is the primary action',
            variant: DoriTypographyVariant.caption,
            color: colors.feedback.info,
          ),
          SizedBox(height: DoriSpacing.xs),
          // Note: We don't actually enable autofocus here to not steal focus
          // in the showcase, but the property is available
          DoriSearchBar(
            hintText: 'Would auto-focus if enabled...',
            // autofocus: true, // Commented to not steal focus in showcase
            onSearch: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDebounceSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'Custom debounce: 500ms delay, minimum 2 characters',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Fast debounce (500ms, 2+ chars)...',
            debounceDuration: const Duration(milliseconds: 500),
            minCharacters: 2,
            onSearch: (_) {},
          ),
          SizedBox(height: DoriSpacing.md),
          DoriText(
            label: 'Custom debounce: 1000ms delay, minimum 5 characters',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Slow debounce (1s, 5+ chars)...',
            debounceDuration: const Duration(milliseconds: 1000),
            minCharacters: 5,
            onSearch: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildTapOutsideBehaviorSection(DoriColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DoriSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface.one,
        borderRadius: DoriRadius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoriText(
            label: 'unfocusOnTapOutside: true (default)',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: 'Focus this field and tap outside to dismiss keyboard',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Tap outside to unfocus...',
            unfocusOnTapOutside: true,
            onSearch: (_) {},
          ),
          SizedBox(height: DoriSpacing.md),
          DoriText(
            label: 'unfocusOnTapOutside: false',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xxxs),
          DoriText(
            label: 'Focus stays when tapping outside (manual control)',
            variant: DoriTypographyVariant.caption,
            color: colors.content.two,
          ),
          SizedBox(height: DoriSpacing.xs),
          DoriSearchBar(
            hintText: 'Keeps focus when tapping outside...',
            unfocusOnTapOutside: false,
            onSearch: (_) {},
          ),
        ],
      ),
    );
  }
}
