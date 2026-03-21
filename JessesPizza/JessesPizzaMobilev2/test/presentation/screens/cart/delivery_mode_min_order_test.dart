import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/delivery_mode_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState>
    implements CartBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  const tItem = CartItem(
    menuItemId: 'item-1',
    name: 'Pepperoni Pizza',
    sizeName: 'Large',
    price: 14.99,
    quantity: 1,
  );

  final tUser = User(
    token: 'tok',
    tokenExpires: DateTime(2099),
    isGuest: false,
    email: 'test@test.com',
  );

  late MockCartBloc cartBloc;
  late MockAuthBloc authBloc;

  setUp(() {
    cartBloc = MockCartBloc();
    authBloc = MockAuthBloc();
    when(() => authBloc.state)
        .thenReturn(AuthAuthenticated(user: tUser));
  });

  Widget buildSubject() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>.value(value: cartBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: const DeliveryModeScreen(),
      ),
    );
  }

  group('Delivery minimum order validation', () {
    testWidgets('shows minimum order message when subtotal is below minimum',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem], // subtotal = 14.99
          minimumOrderAmount: 20.00,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Minimum order for delivery is \$20.00'),
        findsOneWidget,
      );
    });

    testWidgets('delivery button is disabled when below minimum',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem], // subtotal = 14.99
          minimumOrderAmount: 20.00,
        ),
      );

      await tester.pumpWidget(buildSubject());

      final opacityFinder = find.ancestor(
        of: find.text('Delivery'),
        matching: find.byType(Opacity),
      );
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 0.5);
    });

    testWidgets('delivery button is enabled when subtotal meets minimum',
        (tester) async {
      const item = CartItem(
        menuItemId: 'item-1',
        name: 'Big Order',
        sizeName: 'Large',
        price: 25.00,
        quantity: 1,
      );
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [item], // subtotal = 25.00
          minimumOrderAmount: 20.00,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Deliver to your address'), findsOneWidget);
      expect(
        find.text('Minimum order for delivery is \$20.00'),
        findsNothing,
      );
    });

    testWidgets('pickup button is always enabled regardless of minimum',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem], // subtotal = 14.99
          minimumOrderAmount: 20.00,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Pick up at the store'), findsOneWidget);
    });

    testWidgets(
        'delivery button is enabled when minimumOrderAmount is 0 (no minimum)',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          minimumOrderAmount: 0.0,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Deliver to your address'), findsOneWidget);
    });
  });

  group('CartState.meetsDeliveryMinimum', () {
    test('returns true when minimumOrderAmount is 0', () {
      const state = CartState(items: [tItem], minimumOrderAmount: 0.0);
      expect(state.meetsDeliveryMinimum, isTrue);
    });

    test('returns true when subtotal equals minimumOrderAmount', () {
      const state = CartState(items: [tItem], minimumOrderAmount: 14.99);
      expect(state.meetsDeliveryMinimum, isTrue);
    });

    test('returns true when subtotal exceeds minimumOrderAmount', () {
      const state = CartState(items: [tItem], minimumOrderAmount: 10.00);
      expect(state.meetsDeliveryMinimum, isTrue);
    });

    test('returns false when subtotal is below minimumOrderAmount', () {
      const state = CartState(items: [tItem], minimumOrderAmount: 20.00);
      expect(state.meetsDeliveryMinimum, isFalse);
    });

    test('returns true when cart is empty and minimumOrderAmount is 0', () {
      const state = CartState(minimumOrderAmount: 0.0);
      expect(state.meetsDeliveryMinimum, isTrue);
    });

    test('returns false when cart is empty and minimumOrderAmount > 0', () {
      const state = CartState(minimumOrderAmount: 15.00);
      expect(state.meetsDeliveryMinimum, isFalse);
    });
  });
}
