// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_caveo/stories/colors_story.dart'
    as _widgetbook_caveo_stories_colors_story;
import 'package:widgetbook_caveo/stories/radius_story.dart'
    as _widgetbook_caveo_stories_radius_story;
import 'package:widgetbook_caveo/stories/spacing_story.dart'
    as _widgetbook_caveo_stories_spacing_story;
import 'package:widgetbook_caveo/stories/text_story.dart'
    as _widgetbook_caveo_stories_text_story;
import 'package:widgetbook_caveo/stories/typography_story.dart'
    as _widgetbook_caveo_stories_typography_story;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Atoms',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'DoriTextShowcase',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Text Variants',
            builder: _widgetbook_caveo_stories_text_story.buildDoriTextShowcase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Tokens',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ColorPaletteShowcase',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Color Palette',
            builder: _widgetbook_caveo_stories_colors_story
                .buildColorPaletteShowcase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RadiusShowcase',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Border Radius',
            builder: _widgetbook_caveo_stories_radius_story.buildRadiusShowcase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SpacingShowcase',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Spacing Scale',
            builder:
                _widgetbook_caveo_stories_spacing_story.buildSpacingShowcase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'TypographyShowcase',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Typography',
            builder: _widgetbook_caveo_stories_typography_story
                .buildTypographyShowcase,
          ),
        ],
      ),
    ],
  ),
];
