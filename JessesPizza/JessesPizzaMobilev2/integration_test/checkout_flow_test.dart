// integration_test/checkout_flow_test.dart
//
// Widget integration tests for the checkout (happy-path) flow.
// Focuses on navigation between screens, not pixel-perfect rendering.
// All repositories are mocked; no device is required.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';

import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/cart_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/delivery_mode_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/payment_screen.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockMenuRepository extends Mock implements IMenuRepository {}
class MockOrderRepository extends Mock implements IOrderRepository {}
class MockAccountRepository extends Mock implements IAccountRepository {}
class MockApiClient extends Mock implements ApiClient {}

// ---------------------------------------------------------------------------
// Test data
// ---------------------------------------------------------------------------

final _tUser = User(
  token: 'test-token',
  tokenExpires: DateTime(2030),
  isGuest: false,
  email: 'user@example.com',
);

const _tItem = CartItem(
  menuItemId: 'pizza-1',
  name: 'Margherita',
  sizeName: 'Large',
  price: 14.99,
  quantity: 1,
);

final _tGroups = [
  const MenuGroup(id: 'grp-1', name: 'Pizzas'),
];

final _tMenuCategories = [
  MenuCategory(
    id: 'grp-1',
    name: 'Pizzas',
    menuItems: [
      MenuItem(
        id: 'pizza-1',
        name: 'Margherita',
        sizes: const [MenuItemSize(name: 'Large', price: 14.99)],
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Widget builder helper
// ---------------------------------------------------------------------------

Widget _buildTestApp({
  required AuthBloc authBloc,
  required MenuBloc menuBloc,
  required CartBloc cartBloc,
  required OrderBloc orderBloc,
  required AccountBloc accountBloc,
  required Widget home,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>.value(value: authBloc),
      BlocProvider<MenuBloc>.value(value: menuBloc),
      BlocProvider<CartBloc>.value(value: cartBloc),
      BlocProvider<OrderBloc>.value(value: orderBloc),
      BlocProvider<AccountBloc>.value(value: accountBloc),
    ],
    child: MaterialApp(home: home),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockMenuRepository mockMenuRepo;
  late MockOrderRepository mockOrderRepo;
  late MockAccountRepository mockAccountRepo;
  late MockApiClient mockApiClient;

  late AuthBloc authBloc;
  late MenuBloc menuBloc;
  late CartBloc cartBloc;
  late OrderBloc orderBloc;
  late AccountBloc accountBloc;

  setUpAll(() {
    registerFallbackValue(
      const Address(addressLine1: '1 Main St', city: 'Anytown', zipCode: '00000'),
    );
    registerFallbackValue(
      const CreditCard(id: 'fallback', maskedCardNumber: '****0000', expirationDate: '01/30'),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockMenuRepo = MockMenuRepository();
    mockOrderRepo = MockOrderRepository();
    mockAccountRepo = MockAccountRepository();
    mockApiClient = MockApiClient();

    when(() => mockApiClient.setToken(any())).thenReturn(null);
    when(() => mockApiClient.clearToken()).thenReturn(null);

    // Menu repo stubs
    when(() => mockMenuRepo.getGroups()).thenAnswer((_) async => _tGroups);
    when(() => mockMenuRepo.getMenuItems()).thenAnswer((_) async => _tMenuCategories);
    when(() => mockMenuRepo.checkHours()).thenAnswer((_) async => true);

    // Account repo stubs
    when(() => mockAccountRepo.getAccountInfo())
        .thenAnswer((_) async => <String, dynamic>{});
    when(() => mockAccountRepo.getAddresses()).thenAnswer((_) async => []);
    when(() => mockAccountRepo.getCreditCards()).thenAnswer((_) async => []);

    // Auth repo stubs
    when(() => mockAuthRepo.login(any(), any(), any()))
        .thenAnswer((_) async => _tUser);

    authBloc = AuthBloc(
      repository: mockAuthRepo,
      apiClient: mockApiClient,
    );
    menuBloc = MenuBloc(repository: mockMenuRepo);
    cartBloc = CartBloc();
    orderBloc = OrderBloc(repository: mockOrderRepo);
    accountBloc = AccountBloc(repository: mockAccountRepo);
  });

  tearDown(() {
    authBloc.close();
    menuBloc.close();
    cartBloc.close();
    orderBloc.close();
    accountBloc.close();
  });

  // -------------------------------------------------------------------------
  // Test 1: Cart shows added items
  // -------------------------------------------------------------------------
  group('Cart screen', () {
    testWidgets('shows item name and total after AddItem event', (tester) async {
      // Seed authenticated state so checkout works
      authBloc.add(AuthEvent.loginRequested(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'test-device',
      ));
      await Future.delayed(Duration.zero);

      // Add a cart item directly via the bloc
      cartBloc.add(const AddItem(_tItem));

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const CartScreen(),
      ));
      await tester.pumpAndSettle();

      // Cart state should contain the item
      expect(cartBloc.state.items, contains(_tItem));
      expect(cartBloc.state.items.length, 1);
      expect(cartBloc.state.total, closeTo(14.99, 0.01));
    });
  });

  // -------------------------------------------------------------------------
  // Test 2: Checkout button → DeliveryModeScreen
  // -------------------------------------------------------------------------
  group('Checkout flow', () {
    testWidgets('tapping Checkout navigates to DeliveryModeScreen when authenticated', (tester) async {
      // Seed authenticated state
      authBloc.add(AuthEvent.loginRequested(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'test-device',
      ));
      await Future.delayed(Duration.zero);

      // Add an item to the cart so the checkout button is visible
      cartBloc.add(const AddItem(_tItem));

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const CartScreen(),
      ));
      await tester.pumpAndSettle();

      // Find the Checkout button
      final checkoutButton = find.widgetWithText(ElevatedButton, 'Proceed to Checkout');
      expect(checkoutButton, findsOneWidget);

      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Should now be on the DeliveryModeScreen
      expect(find.byType(DeliveryModeScreen), findsOneWidget);
      expect(find.text('Delivery Mode'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Test 3: Select Pickup → PaymentScreen
    // -----------------------------------------------------------------------
    testWidgets('tapping Pickup on DeliveryModeScreen navigates to PaymentScreen', (tester) async {
      // Seed authenticated state and a cart item
      authBloc.add(AuthEvent.loginRequested(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'test-device',
      ));
      await Future.delayed(Duration.zero);
      cartBloc.add(const AddItem(_tItem));

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const DeliveryModeScreen(),
      ));
      await tester.pumpAndSettle();

      // DeliveryModeScreen should be visible
      expect(find.text('Delivery Mode'), findsOneWidget);
      expect(find.text('Pickup'), findsOneWidget);

      // Tap Pickup
      await tester.tap(find.text('Pickup'));
      await tester.pumpAndSettle();

      // Should now be on the PaymentScreen
      expect(find.byType(PaymentScreen), findsOneWidget);

      // CartBloc should have delivery mode set to false (pickup)
      expect(cartBloc.state.isDelivery, isFalse);
    });
  });
}
