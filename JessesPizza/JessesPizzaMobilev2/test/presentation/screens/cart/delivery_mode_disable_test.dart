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

  group('CartState.isDeliveryDisabled', () {
    test('returns true when deliveryCharge is 99', () {
      const state = CartState(deliveryCharge: 99.0);
      expect(state.isDeliveryDisabled, isTrue);
    });

    test('returns true when deliveryCharge is above 99', () {
      const state = CartState(deliveryCharge: 150.0);
      expect(state.isDeliveryDisabled, isTrue);
    });

    test('returns false when deliveryCharge is below 99', () {
      const state = CartState(deliveryCharge: 98.99);
      expect(state.isDeliveryDisabled, isFalse);
    });

    test('returns false for default deliveryCharge', () {
      const state = CartState();
      expect(state.isDeliveryDisabled, isFalse);
    });
  });

  group('Delivery disabled when charge >= 99', () {
    testWidgets('shows unavailable banner when delivery charge >= 99',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 99.0,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Delivery is currently unavailable'),
        findsWidgets,
      );
    });

    testWidgets('delivery button is disabled when charge >= 99',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 99.0,
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

    testWidgets('no contact delivery button is disabled when charge >= 99',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 99.0,
        ),
      );

      await tester.pumpWidget(buildSubject());

      final opacityFinder = find.ancestor(
        of: find.text('No Contact Delivery'),
        matching: find.byType(Opacity),
      );
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 0.5);
    });

    testWidgets('pickup button remains enabled when delivery is disabled',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 99.0,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Pick up at the store'), findsOneWidget);

      // Pickup button should not have reduced opacity
      final pickupOpacity = find.ancestor(
        of: find.text('Pickup'),
        matching: find.byType(Opacity),
      );
      // Pickup is not wrapped in BlocBuilder Opacity logic, so no Opacity widget
      expect(pickupOpacity, findsNothing);
    });

    testWidgets('no banner shown when delivery charge is normal',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 3.99,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Delivery is currently unavailable'),
        findsNothing,
      );
      expect(
        find.textContaining('Deliver to your address'),
        findsOneWidget,
      );
    });

    testWidgets('delivery buttons enabled when charge is 98.99',
        (tester) async {
      when(() => cartBloc.state).thenReturn(
        const CartState(
          items: [tItem],
          deliveryCharge: 98.99,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Delivery is currently unavailable'),
        findsNothing,
      );

      final opacityFinder = find.ancestor(
        of: find.text('Delivery'),
        matching: find.byType(Opacity),
      );
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 1.0);
    });
  });
}
