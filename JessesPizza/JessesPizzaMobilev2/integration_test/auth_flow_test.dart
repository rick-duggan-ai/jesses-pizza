// integration_test/auth_flow_test.dart
//
// Widget integration tests for the auth flow.
// These run with flutter_test (no device required) and use mocked repositories.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/services/token_storage_service.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';

import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/screens/auth/login_screen.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockMenuRepository extends Mock implements IMenuRepository {}
class MockOrderRepository extends Mock implements IOrderRepository {}
class MockAccountRepository extends Mock implements IAccountRepository {}
class MockApiClient extends Mock implements ApiClient {}
class MockTokenStorageService extends Mock implements TokenStorageService {}

// ---------------------------------------------------------------------------
// Helpers
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
  late MockTokenStorageService mockTokenStorage;

  late AuthBloc authBloc;
  late MenuBloc menuBloc;
  late CartBloc cartBloc;
  late OrderBloc orderBloc;
  late AccountBloc accountBloc;

  final tUser = User(
    token: 'test-token',
    tokenExpires: DateTime(2030),
    isGuest: false,
    email: 'user@example.com',
  );

  setUpAll(() {
    // registerFallbackValue is required by mocktail for any custom types
    // used as arguments in when() / verify() matchers.
    registerFallbackValue(User(
      token: 'fallback',
      tokenExpires: DateTime(2030),
      isGuest: false,
    ));
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
    mockTokenStorage = MockTokenStorageService();

    when(() => mockApiClient.setToken(any())).thenReturn(null);
    when(() => mockApiClient.clearToken()).thenReturn(null);
    when(() => mockTokenStorage.saveUser(any())).thenAnswer((_) async {});
    when(() => mockTokenStorage.clearAll()).thenAnswer((_) async {});
    when(() => mockTokenStorage.restoreUser()).thenAnswer((_) async => null);

    // Menu repo stubs (needed by MenuBloc)
    when(() => mockMenuRepo.getGroups()).thenAnswer((_) async => []);
    when(() => mockMenuRepo.getMenuItems()).thenAnswer((_) async => []);
    when(() => mockMenuRepo.checkHours()).thenAnswer((_) async => true);

    // Account repo stubs
    when(() => mockAccountRepo.getAccountInfo())
        .thenAnswer((_) async => <String, dynamic>{});
    when(() => mockAccountRepo.getAddresses()).thenAnswer((_) async => []);
    when(() => mockAccountRepo.getCreditCards()).thenAnswer((_) async => []);

    authBloc = AuthBloc(
      repository: mockAuthRepo,
      apiClient: mockApiClient,
      tokenStorage: mockTokenStorage,
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
  // Test 1: Login flow
  // -------------------------------------------------------------------------
  group('Login flow', () {
    testWidgets('renders LoginScreen → user fills credentials → taps Login → AuthBloc emits authenticated', (tester) async {
      when(() => mockAuthRepo.login(any(), any(), any()))
          .thenAnswer((_) async => tUser);

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const LoginScreen(),
      ));
      await tester.pumpAndSettle();

      // Fill in email
      final emailField = find.widgetWithText(TextFormField, 'Email');
      if (emailField.evaluate().isEmpty) {
        // Try by hint text
        await tester.enterText(
          find.byType(TextFormField).first,
          'user@example.com',
        );
      } else {
        await tester.enterText(emailField, 'user@example.com');
      }

      // Fill in password – the second TextFormField
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      await tester.pump();

      // Tap the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Login').evaluate().isNotEmpty
          ? find.widgetWithText(ElevatedButton, 'Login')
          : find.widgetWithText(FilledButton, 'Login');

      await tester.tap(loginButton);
      await tester.pump(); // start async

      // Verify AuthBloc received the event
      expect(authBloc.state, isA<AuthLoading>());

      await tester.pumpAndSettle();

      // After mock resolves, state should be authenticated
      expect(authBloc.state, isA<AuthAuthenticated>());
      final authState = authBloc.state as AuthAuthenticated;
      expect(authState.user.email, 'user@example.com');
    });
  });

  // -------------------------------------------------------------------------
  // Test 2: Logout flow
  // -------------------------------------------------------------------------
  group('Logout flow', () {
    testWidgets('dispatching LogoutRequested emits AuthUnauthenticated', (tester) async {
      // Seed with authenticated state
      when(() => mockAuthRepo.login(any(), any(), any()))
          .thenAnswer((_) async => tUser);

      // Manually seed authenticated state by dispatching login
      authBloc.add(AuthEvent.loginRequested(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'test-device',
      ));
      await Future.delayed(Duration.zero); // let async complete

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const Scaffold(body: Text('App')),
      ));
      await tester.pumpAndSettle();

      // Dispatch logout
      authBloc.add(const AuthEvent.logoutRequested());
      await tester.pumpAndSettle();

      expect(authBloc.state, isA<AuthUnauthenticated>());
      verify(() => mockApiClient.clearToken()).called(greaterThanOrEqualTo(1));
    });
  });

  // -------------------------------------------------------------------------
  // Test 3: Token expiry
  // -------------------------------------------------------------------------
  group('Token expiry', () {
    testWidgets('dispatching TokenExpired emits AuthUnauthenticated', (tester) async {
      // Start with authenticated state
      when(() => mockAuthRepo.login(any(), any(), any()))
          .thenAnswer((_) async => tUser);

      authBloc.add(AuthEvent.loginRequested(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'test-device',
      ));
      await Future.delayed(Duration.zero);

      await tester.pumpWidget(_buildTestApp(
        authBloc: authBloc,
        menuBloc: menuBloc,
        cartBloc: cartBloc,
        orderBloc: orderBloc,
        accountBloc: accountBloc,
        home: const Scaffold(body: Text('App')),
      ));
      await tester.pumpAndSettle();

      // Dispatch token expiry event
      authBloc.add(const AuthEvent.tokenExpired());
      await tester.pumpAndSettle();

      expect(authBloc.state, isA<AuthUnauthenticated>());
      verify(() => mockApiClient.clearToken()).called(greaterThanOrEqualTo(1));
    });
  });
}
