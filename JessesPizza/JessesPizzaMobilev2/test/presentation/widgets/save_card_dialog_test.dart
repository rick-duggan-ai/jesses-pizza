import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/presentation/widgets/save_card_dialog.dart';

void main() {
  group('SaveCardDialog', () {
    testWidgets('displays title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SaveCardDialog()),
        ),
      );

      expect(find.text('Save Card'), findsOneWidget);
      expect(
        find.text('Would you like to save this card for future orders?'),
        findsOneWidget,
      );
      expect(find.text('No Thanks'), findsOneWidget);
      expect(find.text('Yes, Save It'), findsOneWidget);
    });

    testWidgets('show returns true when user taps Yes', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  dialogResult = await SaveCardDialog.show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('Save Card'), findsOneWidget);

      await tester.tap(find.text('Yes, Save It'));
      await tester.pumpAndSettle();

      expect(dialogResult, isTrue);
    });

    testWidgets('show returns false when user taps No Thanks', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  dialogResult = await SaveCardDialog.show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('No Thanks'));
      await tester.pumpAndSettle();

      expect(dialogResult, isFalse);
    });

    testWidgets('displays credit card icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SaveCardDialog()),
        ),
      );

      expect(find.byIcon(Icons.credit_card), findsOneWidget);
    });
  });
}
