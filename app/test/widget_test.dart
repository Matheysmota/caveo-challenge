import 'package:flutter_test/flutter_test.dart';
import 'package:caveo_challenge/app/app_widget.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppWidget());
    expect(find.text('Caveo Flutter Challenge'), findsOneWidget);
  });
}
