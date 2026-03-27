import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/cart_screen.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  late MockMenuBloc menuBloc;
  late MockAuthBloc authBloc;
  late MockCartBloc cartBloc;

  const cartItem = CartItem(
    menuItemId: '1',
    name: 'Cheese Pizza',
    sizeName: 'Large',
    price: 12.99,
    quantity: 1,
  );

  const cartStateWithItem = CartState(items: [cartItem]);

  final closedSettings = StoreSettings(
    storeHours: [
      // Monday (api day 1) — store hours exist
      StoreHours(day: 1, openingTime: '11:00', closingTime: '22:00'),
    ],
  );

  setUp(() {
    menuBloc = MockMenuBloc();
    authBloc = MockAuthBloc();
    cartBloc = MockCartBloc();

    when(() => cartBloc.state).thenReturn(cartStateWithItem);
  });

  tearDown(() {
    menuBloc.close();
    authBloc.close();
    cartBloc.close();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MenuBloc>.value(value: menuBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<CartBloc>.value(value: cartBloc),
        ],
        child: const CartScreen(),
      ),
    );
  }

  group('CartScreen store hours check', () {
    testWidgets('shows Store Closed dialog when store is closed',
        (tester) async {
      // Menu bloc starts in loaded/closed state and stays closed after refresh.
      final closedState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: false,
        settings: closedSettings,
      );
      when(() => menuBloc.state).thenReturn(closedState);
      whenListen(menuBloc, Stream.value(closedState),
          initialState: closedState);

      await tester.pumpWidget(buildSubject());

      // Tap checkout
      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      // Verify the Store Closed dialog is shown
      expect(find.text('Store Closed'), findsOneWidget);
      expect(
        find.textContaining('Sorry, we are currently closed'),
        findsOneWidget,
      );
    });

    testWidgets('shows actual hours in the closed dialog', (tester) async {
      // Create settings with hours for today's weekday
      final todayWeekday = DateTime.now().weekday;
      final apiDay = todayWeekday == 7 ? 0 : todayWeekday;
      final settingsWithTodayHours = StoreSettings(
        storeHours: [
          StoreHours(day: apiDay, openingTime: '11:00', closingTime: '22:00'),
        ],
      );

      final closedState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: false,
        settings: settingsWithTodayHours,
      );
      when(() => menuBloc.state).thenReturn(closedState);
      whenListen(menuBloc, Stream.value(closedState),
          initialState: closedState);

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Store Closed'), findsOneWidget);
      expect(
        find.textContaining('11:00 AM - 10:00 PM'),
        findsOneWidget,
      );
    });

    testWidgets('shows closed-for-today message when no hours configured',
        (tester) async {
      final closedState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: false,
        settings: const StoreSettings(), // no hours configured
      );
      when(() => menuBloc.state).thenReturn(closedState);
      whenListen(menuBloc, Stream.value(closedState),
          initialState: closedState);

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Store Closed'), findsOneWidget);
      expect(
        find.text('Sorry, we are currently closed for today.'),
        findsOneWidget,
      );
    });

    testWidgets('dismisses Store Closed dialog with OK button',
        (tester) async {
      final closedState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: false,
        settings: const StoreSettings(),
      );
      when(() => menuBloc.state).thenReturn(closedState);
      whenListen(menuBloc, Stream.value(closedState),
          initialState: closedState);

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Store Closed'), findsOneWidget);

      // Tap OK to dismiss
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Store Closed'), findsNothing);
    });

    testWidgets('does not show closed dialog when store is open',
        (tester) async {
      final openState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: true,
        settings: const StoreSettings(),
      );
      when(() => menuBloc.state).thenReturn(openState);
      whenListen(menuBloc, Stream.value(openState), initialState: openState);
      when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text('Proceed to Checkout'));
      // Use pump() instead of pumpAndSettle() because the checkout button
      // shows a CircularProgressIndicator while the dialog is open,
      // and its infinite animation prevents pumpAndSettle from completing.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should NOT show store closed dialog
      expect(find.text('Store Closed'), findsNothing);
      // Should show login dialog instead (since unauthenticated)
      expect(find.text('Login Required'), findsOneWidget);
    });
  });
}
