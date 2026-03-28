import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/presentation/widgets/payment_result_dialog.dart';

void main() {
  group('PaymentResultDialog', () {
    testWidgets('renders title, message, icon, and button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaymentResultDialog(
              title: 'Test Title',
              message: 'Test message body',
              buttonText: 'Dismiss',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test message body'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('button closes the dialog', (tester) async {
      bool dialogClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (_) => const PaymentResultDialog(
                      title: 'Title',
                      message: 'Message',
                      buttonText: 'Close',
                    ),
                  );
                  dialogClosed = true;
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(dialogClosed, isTrue);
      expect(find.text('Title'), findsNothing);
    });
  });

  group('PaymentResultDialog.showDecline', () {
    testWidgets('shows decline dialog with correct content', (tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              savedContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      PaymentResultDialog.showDecline(savedContext);
      await tester.pumpAndSettle();

      expect(find.text('Payment Declined'), findsOneWidget);
      expect(
        find.textContaining('Your card was declined'),
        findsOneWidget,
      );
      expect(find.text('OK'), findsOneWidget);
      expect(find.byIcon(Icons.credit_card_off), findsOneWidget);
    });

    testWidgets('OK button dismisses the decline dialog', (tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              savedContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      PaymentResultDialog.showDecline(savedContext);
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Payment Declined'), findsNothing);
    });
  });

  group('PaymentResultDialog.showFailure', () {
    testWidgets('shows failure dialog with server message', (tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              savedContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      PaymentResultDialog.showFailure(
        savedContext,
        message: 'Gateway timeout: please retry',
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Failed'), findsOneWidget);
      expect(find.text('Gateway timeout: please retry'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('Try Again button dismisses the failure dialog',
        (tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              savedContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      PaymentResultDialog.showFailure(
        savedContext,
        message: 'Error occurred',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      expect(find.text('Payment Failed'), findsNothing);
    });

    testWidgets('dialog is not dismissible by tapping outside',
        (tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              savedContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      PaymentResultDialog.showFailure(
        savedContext,
        message: 'Server error',
      );
      await tester.pumpAndSettle();

      // Tap the barrier (outside the dialog)
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.text('Payment Failed'), findsOneWidget);
    });
  });
}
