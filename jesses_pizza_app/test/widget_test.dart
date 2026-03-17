import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/app/app.dart';
import 'package:jesses_pizza_app/app/di.dart';

void main() {
  setUpAll(() {
    setupDependencies();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JessesPizzaApp());
    expect(find.text("Jesse's Pizza"), findsOneWidget);
  });
}
