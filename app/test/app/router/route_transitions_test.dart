import 'package:caveo_challenge/app/router/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RouteTransitions', () {
    group('defaultDuration', () {
      test('should be 300 milliseconds', () {
        expect(
          RouteTransitions.defaultDuration,
          const Duration(milliseconds: 300),
        );
      });
    });

    group('fade', () {
      testWidgets('should return FadeTransition when animations enabled', (
        tester,
      ) async {
        late Widget result;
        final animation = AnimationController(vsync: tester, value: 0.5);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                result = RouteTransitions.fade(
                  context,
                  animation,
                  animation,
                  const SizedBox(key: Key('test-child')),
                );
                return result;
              },
            ),
          ),
        );

        expect(result, isA<FadeTransition>());
        animation.dispose();
      });
    });

    group('slideUp', () {
      testWidgets('should return SlideTransition when animations enabled', (
        tester,
      ) async {
        late Widget result;
        final animation = AnimationController(vsync: tester, value: 0.5);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                result = RouteTransitions.slideUp(
                  context,
                  animation,
                  animation,
                  const SizedBox(key: Key('test-child')),
                );
                return result;
              },
            ),
          ),
        );

        expect(result, isA<SlideTransition>());
        animation.dispose();
      });
    });

    group('slideFromRight', () {
      testWidgets('should return SlideTransition when animations enabled', (
        tester,
      ) async {
        late Widget result;
        final animation = AnimationController(vsync: tester, value: 0.5);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                result = RouteTransitions.slideFromRight(
                  context,
                  animation,
                  animation,
                  const SizedBox(key: Key('test-child')),
                );
                return result;
              },
            ),
          ),
        );

        expect(result, isA<SlideTransition>());
        animation.dispose();
      });
    });

    group('none', () {
      testWidgets('should return child directly without animation', (
        tester,
      ) async {
        late Widget result;
        const child = SizedBox(key: Key('test-child'));
        final animation = AnimationController(vsync: tester, value: 0.5);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                result = RouteTransitions.none(
                  context,
                  animation,
                  animation,
                  child,
                );
                return result;
              },
            ),
          ),
        );

        expect(result, same(child));
        animation.dispose();
      });
    });
  });
}
