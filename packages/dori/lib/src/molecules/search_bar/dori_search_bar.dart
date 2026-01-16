import 'dart:async';

import 'package:flutter/material.dart';

import '../../atoms/icon/dori_icon.dart';
import '../../atoms/icon_button/dori_icon_button.dart';
import '../../theme/dori_theme.barrel.dart';
import '../../tokens/dori_radius.dart';
import '../../tokens/dori_spacing.dart';
import '../../tokens/dori_typography.dart';

/// 🔍 Dori Search Bar molecule.
///
/// A search input field following Dori Design System tokens with built-in
/// debounce logic for optimized search performance.
///
/// ## Features
///
/// - **Debounce Logic:** Only triggers search after user stops typing
/// - **Minimum Characters:** Configurable minimum characters before searching
/// - **Focus Control:** External control via [FocusNode] for navigation integration
/// - **Accessibility:** Full semantic support for screen readers
/// - **Clear Button:** Appears when text is entered
///
/// ## Debounce Behavior
///
/// The search callback is triggered only when:
/// 1. User types at least [minCharacters] (default: 3)
/// 2. User stops typing for [debounceDuration] (default: 400ms)
///
/// Empty/cleared input triggers callback immediately with empty string.
///
/// ## Example
///
/// ```dart
/// DoriSearchBar(
///   hintText: 'Search products...',
///   onSearch: (query) {
///     // Called after debounce when query.length >= 3
///     print('Searching for: $query');
///   },
/// )
/// ```
///
/// {@category Molecules}
class DoriSearchBar extends StatefulWidget {
  /// Creates a Dori search bar.
  const DoriSearchBar({
    required this.onSearch,
    this.hintText = 'Search',
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.minCharacters = 3,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.semanticLabel,
    this.unfocusOnTapOutside = true,
    super.key,
  });

  /// Callback triggered after debounce when search criteria are met.
  ///
  /// Called when:
  /// - User types [minCharacters] or more and stops typing for [debounceDuration]
  /// - User clears the input (with empty string)
  /// - User submits via keyboard action
  final ValueChanged<String> onSearch;

  /// Placeholder text shown when the input is empty.
  ///
  /// Defaults to 'Search'.
  final String hintText;

  /// External text controller.
  ///
  /// If not provided, an internal controller is created.
  /// Use this to programmatically set or clear the search text.
  final TextEditingController? controller;

  /// External focus node for controlling focus state.
  ///
  /// If not provided, an internal focus node is created.
  /// Use this to programmatically focus/unfocus when navigating.
  final FocusNode? focusNode;

  /// Whether the search bar should autofocus when mounted.
  ///
  /// Defaults to `false`.
  final bool autofocus;

  /// Whether the search bar is enabled for input.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Minimum characters required before triggering search.
  ///
  /// Search callback is only invoked when text length >= this value.
  /// Defaults to 3 to prevent overly broad searches.
  final int minCharacters;

  /// Duration to wait after user stops typing before triggering search.
  ///
  /// Defaults to 400ms which provides a good balance between
  /// responsiveness and reducing unnecessary API calls.
  final Duration debounceDuration;

  /// Called immediately when text changes (before debounce).
  ///
  /// Use this for UI updates that should happen immediately,
  /// like showing a loading indicator.
  final ValueChanged<String>? onChanged;

  /// Called when user submits via keyboard action.
  ///
  /// Triggers search immediately, bypassing debounce.
  final ValueChanged<String>? onSubmitted;

  /// Called when user clears the input via clear button.
  final VoidCallback? onCleared;

  /// Custom semantic label for accessibility.
  ///
  /// If not provided, uses [hintText] as the semantic label.
  final String? semanticLabel;

  /// Whether to unfocus and dismiss keyboard when tapping outside the search bar.
  ///
  /// When `true` (default), tapping anywhere outside the search bar will:
  /// - Remove focus from the text field
  /// - Dismiss the keyboard
  /// - Hide the cursor
  ///
  /// Set to `false` if you want to manage focus manually.
  final bool unfocusOnTapOutside;

  @override
  State<DoriSearchBar> createState() => _DoriSearchBarState();
}

class _DoriSearchBarState extends State<DoriSearchBar> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  /// Timer for debounce logic.
  Timer? _debounceTimer;

  /// Last searched query to avoid duplicate searches.
  String _lastSearchedQuery = '';

  /// Tracks previous hasText state to optimize rebuilds.
  bool _previousHasText = false;

  @override
  void initState() {
    super.initState();

    // Initialize internal controller if no external one provided
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }

    // Initialize internal focus node if no external one provided
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }

    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(DoriSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change
    if (widget.controller != oldWidget.controller) {
      // Remove listener from old controller
      if (oldWidget.controller != null) {
        oldWidget.controller!.removeListener(_onTextChanged);
      } else {
        _internalController?.removeListener(_onTextChanged);
      }

      // Dispose internal controller if we had one and now have external
      if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }

      // Create internal controller if we had external and now have none
      if (oldWidget.controller != null && widget.controller == null) {
        _internalController = TextEditingController();
      }

      // Add listener to new controller
      _controller.addListener(_onTextChanged);
    }

    // Handle focus node change
    if (widget.focusNode != oldWidget.focusNode) {
      // Dispose internal focus node if we had one and now have external
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }

      // Create internal focus node if we had external and now have none
      if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);

    // Only dispose resources we own (internal ones)
    _internalController?.dispose();
    _internalFocusNode?.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;

    // Notify immediate change callback
    widget.onChanged?.call(text);

    // Cancel any pending debounce
    _debounceTimer?.cancel();

    // Handle empty input immediately
    if (text.isEmpty) {
      if (_lastSearchedQuery.isNotEmpty) {
        _lastSearchedQuery = '';
        widget.onSearch('');
      }
      return;
    }

    // Only debounce if we have minimum characters
    if (text.length >= widget.minCharacters) {
      _debounceTimer = Timer(widget.debounceDuration, () {
        if (text != _lastSearchedQuery && mounted) {
          _lastSearchedQuery = text;
          widget.onSearch(text);
        }
      });
    }

    // Trigger rebuild only when hasText state changes (to show/hide clear button)
    final hasText = text.isNotEmpty;
    if (hasText != _previousHasText) {
      _previousHasText = hasText;
      setState(() {});
    }
  }

  void _onSubmitted(String value) {
    // Cancel debounce and search immediately
    _debounceTimer?.cancel();

    if (value.isNotEmpty && value != _lastSearchedQuery) {
      _lastSearchedQuery = value;
      widget.onSearch(value);
    }

    widget.onSubmitted?.call(value);
  }

  void _onClear() {
    _controller.clear();
    _lastSearchedQuery = '';
    widget.onSearch('');
    widget.onCleared?.call();

    // Keep focus on the field after clearing
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final dori = context.dori;
    final colors = dori.colors;
    final hasText = _controller.text.isNotEmpty;

    return Semantics(
      label: widget.semanticLabel ?? widget.hintText,
      textField: true,
      enabled: widget.enabled,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface.two,
          borderRadius: DoriRadius.lg,
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          enableSuggestions: true,
          onSubmitted: _onSubmitted,
          onTapOutside: widget.unfocusOnTapOutside
              ? (_) => _focusNode.unfocus()
              : null,
          style: DoriTypography.description.copyWith(color: colors.content.one),
          cursorColor: colors.brand.pure,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: DoriTypography.description.copyWith(
              color: colors.content.two,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: DoriSpacing.xs,
                right: DoriSpacing.xxs,
              ),
              child: DoriIcon(
                icon: DoriIconData.search,
                size: DoriIconSize.md,
                color: colors.content.two,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: hasText
                ? Padding(
                    padding: EdgeInsets.only(right: DoriSpacing.xs),
                    child: DoriIconButton(
                      icon: DoriIconData.close,
                      size: DoriIconButtonSize.xs,
                      onPressed: widget.enabled ? _onClear : null,
                      iconColor: colors.content.two,
                      semanticLabel: 'Clear search',
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: DoriSpacing.xs,
              vertical: DoriSpacing.xs,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: false,
          ),
        ),
      ),
    );
  }
}
