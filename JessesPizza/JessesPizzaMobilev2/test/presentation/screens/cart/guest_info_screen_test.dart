import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/guest_info_screen.dart';

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = CartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<CartBloc>.value(
        value: cartBloc,
        child: const GuestInfoScreen(),
      ),
    );
  }

  Future<void> scrollToAndTapContinue(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
  }

  group('GuestInfoScreen', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);

      // Scroll down to see remaining fields
      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Zip Code'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(buildSubject());

      await scrollToAndTapContinue(tester);

      // Scroll back up to see top errors
      await tester.ensureVisible(find.text('First Name'));
      await tester.pumpAndSettle();
      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);

      // Scroll down to see bottom errors
      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Address is required'), findsOneWidget);
      expect(find.text('City is required'), findsOneWidget);
      expect(find.text('Zip code is required'), findsOneWidget);
    });

    testWidgets('shows error for invalid email', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );

      await scrollToAndTapContinue(tester);

      await tester.ensureVisible(find.text('Email'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows error for invalid phone number', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '123',
      );

      await scrollToAndTapContinue(tester);

      await tester.ensureVisible(find.text('Phone Number'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid phone number'), findsOneWidget);
    });

    testWidgets('shows error for invalid zip code', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Zip Code'),
        'abc',
      );

      await scrollToAndTapContinue(tester);

      expect(find.text('Enter a valid zip code'), findsOneWidget);
    });

    testWidgets('accepts valid 10-digit phone number', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '5551234567',
      );

      await scrollToAndTapContinue(tester);

      expect(find.text('Enter a valid phone number'), findsNothing);
    });

    testWidgets('accepts valid 5-digit zip code', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Zip Code'),
        '12345',
      );

      await scrollToAndTapContinue(tester);

      expect(find.text('Enter a valid zip code'), findsNothing);
    });

    testWidgets('accepts valid zip+4 format', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Zip Code'),
        '12345-6789',
      );

      await scrollToAndTapContinue(tester);

      expect(find.text('Enter a valid zip code'), findsNothing);
    });

    testWidgets('accepts valid email format', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      await scrollToAndTapContinue(tester);

      expect(find.text('Enter a valid email address'), findsNothing);
    });

    testWidgets('stores guest info in cart bloc when form is valid',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      // Fill in all fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'First Name'), 'John');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Last Name'), 'Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '5551234567');

      // Scroll down to fill remaining fields
      await tester.ensureVisible(find.widgetWithText(TextFormField, 'Address'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Address'), '123 Main St');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'City'), 'Springfield');

      await tester.ensureVisible(find.widgetWithText(TextFormField, 'Zip Code'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Zip Code'), '12345');

      await scrollToAndTapContinue(tester);

      // Verify guest info was stored in the CartBloc
      final guestInfo = cartBloc.state.guestInfo;
      expect(guestInfo, isNotNull);
      expect(guestInfo!.firstName, 'John');
      expect(guestInfo.lastName, 'Doe');
      expect(guestInfo.email, 'john@example.com');
      expect(guestInfo.phoneNumber, '5551234567');
      expect(guestInfo.addressLine1, '123 Main St');
      expect(guestInfo.city, 'Springfield');
      expect(guestInfo.zipCode, '12345');
    });
  });
}
