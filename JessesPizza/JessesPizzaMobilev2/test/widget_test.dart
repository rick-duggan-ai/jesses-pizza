import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jesses_pizza_app/app/app.dart';
import 'package:jesses_pizza_app/app/di.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await setupDependencies();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const JessesPizzaApp());
      await tester.pump();
    });
    expect(find.text("Jesse's Pizza"), findsOneWidget);
  });
}
