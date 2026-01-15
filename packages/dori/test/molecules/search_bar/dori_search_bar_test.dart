import 'package:dori/dori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoriSearchBar', () {
    Widget buildTestWidget(DoriSearchBar searchBar, {ThemeData? theme}) {
      return MaterialApp(
        theme: theme ?? DoriTheme.light,
        home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(16), child: searchBar),
        ),
      );
    }

    group('rendering', () {
      testWidgets('should render with default properties', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert
        expect(find.byType(DoriSearchBar), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should display hint text', (tester) async {
        // Arrange
        const hintText = 'Search products...';

        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {}, hintText: hintText)),
        );

        // Assert
        expect(find.text(hintText), findsOneWidget);
      });

      testWidgets('should display search icon', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert
        expect(find.byType(DoriIcon), findsOneWidget);
      });

      testWidgets('should use surface.two as background color', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DoriSearchBar),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.light.surface.two));
      });

      testWidgets('should use lg radius for container', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DoriSearchBar),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(DoriRadius.lg));
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}),
            theme: DoriTheme.dark,
          ),
        );

        // Assert
        expect(find.byType(DoriSearchBar), findsOneWidget);

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DoriSearchBar),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(DoriColors.dark.surface.two));
      });
    });

    group('clear button', () {
      testWidgets('should not show clear button when empty', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert - only search icon should be visible (no DoriIconButton)
        expect(find.byType(DoriIconButton), findsNothing);
      });

      testWidgets('should show clear button when text is entered', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert - DoriIconButton (clear button) should appear
        expect(find.byType(DoriIconButton), findsOneWidget);
      });

      testWidgets('should use DoriIconButtonSize.xs for clear button', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert
        final iconButton = tester.widget<DoriIconButton>(
          find.byType(DoriIconButton),
        );
        expect(iconButton.size, equals(DoriIconButtonSize.xs));
      });

      testWidgets('should clear text and call onCleared when pressed', (
        tester,
      ) async {
        // Arrange
        var cleared = false;
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (_) {},
              controller: controller,
              onCleared: () => cleared = true,
            ),
          ),
        );

        // Act - enter text
        await tester.enterText(find.byType(TextField), 'test query');
        await tester.pump();
        expect(controller.text, equals('test query'));

        // Act - tap clear button (DoriIconButton)
        await tester.tap(find.byType(DoriIconButton));
        await tester.pump();

        // Assert
        expect(controller.text, isEmpty);
        expect(cleared, isTrue);
      });

      testWidgets('should keep focus after clearing', (tester) async {
        // Arrange
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, focusNode: focusNode),
          ),
        );

        // Act - enter text
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Act - tap clear button (DoriIconButton)
        await tester.tap(find.byType(DoriIconButton));
        await tester.pump();

        // Assert
        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });

      testWidgets('should have proper accessibility label on clear button', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert
        final iconButton = tester.widget<DoriIconButton>(
          find.byType(DoriIconButton),
        );
        expect(iconButton.semanticLabel, equals('Clear search'));
      });
    });

    group('debounce behavior', () {
      testWidgets('should not trigger onSearch before minCharacters', (
        tester,
      ) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              minCharacters: 3,
              debounceDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        // Act - type 2 characters (less than minimum)
        await tester.enterText(find.byType(TextField), 'ab');
        await tester.pump(const Duration(milliseconds: 200));

        // Assert - should not have searched
        expect(searches, isEmpty);
      });

      testWidgets('should trigger onSearch after minCharacters and debounce', (
        tester,
      ) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              minCharacters: 3,
              debounceDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        // Act - type 3 characters (meets minimum)
        await tester.enterText(find.byType(TextField), 'abc');
        await tester.pump(const Duration(milliseconds: 150));

        // Assert
        expect(searches, contains('abc'));
      });

      testWidgets('should debounce rapid typing', (tester) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              minCharacters: 3,
              debounceDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        // Act - rapid typing
        await tester.enterText(find.byType(TextField), 'hel');
        await tester.pump(const Duration(milliseconds: 50));
        await tester.enterText(find.byType(TextField), 'hell');
        await tester.pump(const Duration(milliseconds: 50));
        await tester.enterText(find.byType(TextField), 'hello');
        await tester.pump(const Duration(milliseconds: 150));

        // Assert - should only search once with final value
        expect(searches.length, equals(1));
        expect(searches.first, equals('hello'));
      });

      testWidgets('should trigger immediately when cleared', (tester) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              minCharacters: 3,
              debounceDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        // Act - type and wait for search
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump(const Duration(milliseconds: 150));
        expect(searches, contains('test'));

        // Act - clear text via clear button
        await tester.tap(find.byType(DoriIconButton));
        await tester.pump();

        // Assert - should immediately search with empty string
        expect(searches.last, equals(''));
      });

      testWidgets('should not duplicate searches for same query', (
        tester,
      ) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              minCharacters: 3,
              debounceDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        // Act - type same thing twice
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump(const Duration(milliseconds: 150));
        await tester.enterText(find.byType(TextField), ''); // clear
        await tester.pump();
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump(const Duration(milliseconds: 150));

        // Assert - should have: 'test', '', 'test'
        expect(searches, equals(['test', '', 'test']));
      });

      testWidgets('should call onChanged immediately without debounce', (
        tester,
      ) async {
        // Arrange
        final changes = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (_) {},
              onChanged: (text) => changes.add(text),
              debounceDuration: const Duration(milliseconds: 500),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'a');
        await tester.pump();

        // Assert - onChanged should fire immediately
        expect(changes, contains('a'));
      });
    });

    group('keyboard submission', () {
      testWidgets('should trigger onSearch immediately on submit', (
        tester,
      ) async {
        // Arrange
        final searches = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (query) => searches.add(query),
              debounceDuration: const Duration(milliseconds: 500),
            ),
          ),
        );

        // Act - type and submit immediately
        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();

        // Assert - should search immediately, bypassing debounce
        expect(searches, contains('test'));
      });

      testWidgets('should call onSubmitted callback', (tester) async {
        // Arrange
        String? submitted;

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (_) {},
              onSubmitted: (value) => submitted = value,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'search query');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();

        // Assert
        expect(submitted, equals('search query'));
      });
    });

    group('focus control', () {
      testWidgets('should autofocus when autofocus is true', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {}, autofocus: true)),
        );
        await tester.pumpAndSettle();

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autofocus, isTrue);
      });

      testWidgets('should not autofocus by default', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autofocus, isFalse);
      });

      testWidgets('should respect external focusNode', (tester) async {
        // Arrange
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, focusNode: focusNode),
          ),
        );

        // Act - programmatically focus
        focusNode.requestFocus();
        await tester.pump();

        // Assert
        expect(focusNode.hasFocus, isTrue);

        // Act - programmatically unfocus
        focusNode.unfocus();
        await tester.pump();

        // Assert
        expect(focusNode.hasFocus, isFalse);

        focusNode.dispose();
      });
    });

    group('external controller', () {
      testWidgets('should use external controller', (tester) async {
        // Arrange
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, controller: controller),
          ),
        );

        // Act - set text programmatically
        controller.text = 'programmatic text';
        await tester.pump();

        // Assert
        expect(find.text('programmatic text'), findsOneWidget);

        controller.dispose();
      });

      testWidgets('should clear via external controller', (tester) async {
        // Arrange
        final controller = TextEditingController(text: 'initial');

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, controller: controller),
          ),
        );

        // Act
        controller.clear();
        await tester.pump();

        // Assert
        expect(controller.text, isEmpty);

        controller.dispose();
      });
    });

    group('disabled state', () {
      testWidgets('should not accept input when disabled', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {}, enabled: false)),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isFalse);
      });
    });

    group('accessibility', () {
      testWidgets('should have semantic textField', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, hintText: 'Search products'),
          ),
        );

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriSearchBar));
        expect(semantics.label, equals('Search products'));
      });

      testWidgets('should use custom semantic label when provided', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (_) {},
              hintText: 'Search',
              semanticLabel: 'Search for products and categories',
            ),
          ),
        );

        // Assert
        final semantics = tester.getSemantics(find.byType(DoriSearchBar));
        expect(semantics.label, equals('Search for products and categories'));
      });

      testWidgets('clear button should have accessible label', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(DoriSearchBar(onSearch: (_) {})),
        );

        // Act - enter text to show clear button
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert
        expect(find.bySemanticsLabel('Clear search'), findsOneWidget);
      });
    });

    group('lifecycle', () {
      testWidgets('should dispose timer on widget disposal', (tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(
              onSearch: (_) {},
              debounceDuration: const Duration(seconds: 10),
            ),
          ),
        );

        // Act - enter text to start debounce timer
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Act - dispose widget
        await tester.pumpWidget(Container());

        // Assert - no exceptions means timer was properly cancelled
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle controller change', (tester) async {
        // Arrange
        final controller1 = TextEditingController(text: 'first');
        final controller2 = TextEditingController(text: 'second');

        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, controller: controller1),
          ),
        );

        expect(find.text('first'), findsOneWidget);

        // Act - change controller
        await tester.pumpWidget(
          buildTestWidget(
            DoriSearchBar(onSearch: (_) {}, controller: controller2),
          ),
        );

        // Assert
        expect(find.text('second'), findsOneWidget);

        controller1.dispose();
        controller2.dispose();
      });
    });

    group('unfocusOnTapOutside', () {
      testWidgets(
        'should unfocus when tapping outside with unfocusOnTapOutside true',
        (tester) async {
          // Arrange
          final focusNode = FocusNode();

          await tester.pumpWidget(
            MaterialApp(
              theme: DoriTheme.light,
              home: Scaffold(
                body: Column(
                  children: [
                    DoriSearchBar(
                      onSearch: (_) {},
                      focusNode: focusNode,
                      unfocusOnTapOutside: true,
                    ),
                    const Expanded(child: SizedBox(key: Key('outside'))),
                  ],
                ),
              ),
            ),
          );

          // Act - focus the search bar
          await tester.tap(find.byType(TextField));
          await tester.pump();
          expect(focusNode.hasFocus, isTrue);

          // Act - tap outside (on the expanded SizedBox)
          await tester.tapAt(const Offset(200, 400));
          await tester.pump();

          // Assert
          expect(focusNode.hasFocus, isFalse);

          focusNode.dispose();
        },
      );

      testWidgets(
        'should not unfocus when tapping outside with unfocusOnTapOutside false',
        (tester) async {
          // Arrange
          final focusNode = FocusNode();

          await tester.pumpWidget(
            MaterialApp(
              theme: DoriTheme.light,
              home: Scaffold(
                body: Column(
                  children: [
                    DoriSearchBar(
                      onSearch: (_) {},
                      focusNode: focusNode,
                      unfocusOnTapOutside: false,
                    ),
                    const Expanded(child: SizedBox(key: Key('outside'))),
                  ],
                ),
              ),
            ),
          );

          // Act - focus the search bar
          await tester.tap(find.byType(TextField));
          await tester.pump();
          expect(focusNode.hasFocus, isTrue);

          // Act - tap outside
          await tester.tapAt(const Offset(200, 400));
          await tester.pump();

          // Assert - should still have focus
          expect(focusNode.hasFocus, isTrue);

          focusNode.dispose();
        },
      );

      testWidgets('should default to unfocusOnTapOutside true', (tester) async {
        // Arrange
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            theme: DoriTheme.light,
            home: Scaffold(
              body: Column(
                children: [
                  DoriSearchBar(
                    onSearch: (_) {},
                    focusNode: focusNode,
                    // Note: unfocusOnTapOutside not specified, defaults to true
                  ),
                  const Expanded(child: SizedBox(key: Key('outside'))),
                ],
              ),
            ),
          ),
        );

        // Act - focus the search bar
        await tester.tap(find.byType(TextField));
        await tester.pump();
        expect(focusNode.hasFocus, isTrue);

        // Act - tap outside
        await tester.tapAt(const Offset(200, 400));
        await tester.pump();

        // Assert - default behavior unfocuses
        expect(focusNode.hasFocus, isFalse);

        focusNode.dispose();
      });
    });
  });
}
