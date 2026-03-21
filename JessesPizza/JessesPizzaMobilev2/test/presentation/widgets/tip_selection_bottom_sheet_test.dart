import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/presentation/widgets/tip_selection_bottom_sheet.dart';

void main() {
  Widget buildSubject({double subtotal = 25.00}) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result = await showTipSelectionBottomSheet(
                context: context,
                subtotal: subtotal,
              );
              if (context.mounted && result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('tip:${result.amount}')),
                );
              }
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  Future<void> openSheet(WidgetTester tester, {double subtotal = 25.00}) async {
    await tester.pumpWidget(buildSubject(subtotal: subtotal));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  group('TipSelectionBottomSheet', () {
    testWidgets('displays title and subtotal', (tester) async {
      await openSheet(tester);

      expect(find.text('Add a tip?'), findsOneWidget);
      expect(find.text('Subtotal: \$25.00'), findsOneWidget);
    });

    testWidgets('displays percentage options with calculated amounts',
        (tester) async {
      await openSheet(tester);

      expect(find.text('20% - \$5.00'), findsOneWidget);
      expect(find.text('22% - \$5.50'), findsOneWidget);
      expect(find.text('25% - \$6.25'), findsOneWidget);
    });

    testWidgets('displays Custom Amount and No Tip buttons', (tester) async {
      await openSheet(tester);

      expect(find.text('Custom Amount'), findsOneWidget);
      expect(find.text('No Tip'), findsOneWidget);
    });

    testWidgets('selecting 20% returns correct tip amount', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('20% - \$5.00'));
      await tester.pumpAndSettle();

      expect(find.text('tip:5.0'), findsOneWidget);
    });

    testWidgets('selecting No Tip returns 0.0', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('No Tip'));
      await tester.pumpAndSettle();

      expect(find.text('tip:0.0'), findsOneWidget);
    });

    testWidgets('Custom Amount shows text field and Add button',
        (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Custom Amount'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('Custom Amount submits entered value', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Custom Amount'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '3.50');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('tip:3.5'), findsOneWidget);
    });

    testWidgets('Custom Amount shows error for empty input', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Custom Amount'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter an amount'), findsOneWidget);
    });

    testWidgets('percentage calculations with non-round subtotal',
        (tester) async {
      await openSheet(tester, subtotal: 33.33);

      expect(find.text('Subtotal: \$33.33'), findsOneWidget);
      expect(find.text('20% - \$6.67'), findsOneWidget);
      expect(find.text('22% - \$7.33'), findsOneWidget);
      expect(find.text('25% - \$8.33'), findsOneWidget);
    });
  });
}
