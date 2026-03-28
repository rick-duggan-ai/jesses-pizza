# Jesse's Pizza Flutter Mobile App — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Flutter mobile app for Android and iOS that replaces the existing Xamarin customer app, with menu browsing, ordering, payment (Converge/Elavon), and account management.

**Architecture:** Layered architecture (data/domain/presentation) with BLoC state management. Single `ApiClient` using dio for all HTTP calls to JessesApi. Five BLoCs (Auth, Menu, Cart, Order, Account) with repository pattern for data access.

**Tech Stack:** Flutter, flutter_bloc, dio, freezed, json_serializable, get_it, webview_flutter, flutter_secure_storage

**Spec:** `docs/superpowers/specs/2026-03-16-flutter-mobile-app-rebuild-design.md`

---

## File Structure

```
jesses_pizza_app/
  lib/
    main.dart                                    # App entry point, DI setup
    app/
      app.dart                                   # MaterialApp, theme, bottom nav shell
      routes.dart                                # Route names and navigation helpers
      theme.dart                                 # App theme (colors, typography)
    data/
      api/
        api_client.dart                          # dio wrapper, JWT interceptor, error mapping
        api_endpoints.dart                       # Endpoint path constants
        dto/
          auth_dtos.dart                         # Login/signup request/response DTOs
          menu_dtos.dart                         # Menu groups/items DTOs
          order_dtos.dart                        # Transaction, order history DTOs
          account_dtos.dart                      # Address, credit card, profile DTOs
          payment_dtos.dart                      # HPP token, transaction validation DTOs
      repositories/
        auth_repository.dart                     # Auth API calls
        menu_repository.dart                     # Menu + store hours API calls
        order_repository.dart                    # Order submission, history, validation
        account_repository.dart                  # Profile, addresses, credit cards
    domain/
      models/
        user.dart                                # User/AppUser model
        menu_group.dart                          # Menu group model
        menu_item.dart                           # Menu item model (with sizes)
        cart_item.dart                            # Cart item (menu item + quantity + customization)
        transaction.dart                         # Order/transaction model (v1.0 + v1.1)
        address.dart                             # Delivery address model
        credit_card.dart                         # Saved credit card model
        api_response.dart                        # Generic API response wrapper
      repositories/
        i_auth_repository.dart                   # Auth repository interface
        i_menu_repository.dart                   # Menu repository interface
        i_order_repository.dart                  # Order repository interface
        i_account_repository.dart                # Account repository interface
    presentation/
      blocs/
        auth/
          auth_bloc.dart                         # Auth state management
          auth_event.dart                        # Auth events
          auth_state.dart                        # Auth states
        menu/
          menu_bloc.dart                         # Menu + store hours state
          menu_event.dart
          menu_state.dart
        cart/
          cart_bloc.dart                          # Cart state management
          cart_event.dart
          cart_state.dart
        order/
          order_bloc.dart                         # Order submission + history
          order_event.dart
          order_state.dart
        account/
          account_bloc.dart                       # Profile, addresses, cards
          account_event.dart
          account_state.dart
      screens/
        menu/
          menu_categories_screen.dart            # List of menu groups
          category_items_screen.dart             # Items in a group
          item_detail_screen.dart                # Item detail + add to cart
        cart/
          cart_screen.dart                        # Cart summary
          delivery_mode_screen.dart              # Pickup vs delivery
          address_selection_screen.dart           # Select/add delivery address
          payment_screen.dart                    # Payment method selection
          hpp_webview_screen.dart                # Converge HPP WebView
          order_confirmation_screen.dart         # Order success
        account/
          account_screen.dart                    # Account overview/settings list
          order_history_screen.dart              # Past orders list
          order_detail_screen.dart               # Single order detail
          profile_screen.dart                    # View profile (read-only)
          addresses_screen.dart                  # Manage addresses
          credit_cards_screen.dart               # Manage credit cards
          contact_screen.dart                    # Contact us
          about_screen.dart                      # About
        auth/
          login_screen.dart                      # Login form
          signup_screen.dart                     # Multi-step signup
          forgot_password_screen.dart            # Password reset flow
          sms_verification_screen.dart           # SMS code entry (shared)
      widgets/
        store_closed_banner.dart                 # "Store is currently closed" banner
        menu_item_card.dart                      # Menu item display card
        cart_item_tile.dart                      # Cart item row
        order_tile.dart                          # Order history row
        address_tile.dart                        # Address display/select
        credit_card_tile.dart                    # Credit card display
        loading_indicator.dart                   # Shared loading widget
        error_display.dart                       # Shared error widget
  test/
    data/
      api/
        api_client_test.dart
      repositories/
        auth_repository_test.dart
        menu_repository_test.dart
        order_repository_test.dart
        account_repository_test.dart
    domain/
      models/
        user_test.dart
        menu_item_test.dart
        transaction_test.dart
    presentation/
      blocs/
        auth_bloc_test.dart
        menu_bloc_test.dart
        cart_bloc_test.dart
        order_bloc_test.dart
        account_bloc_test.dart
      screens/
        menu_categories_screen_test.dart
        cart_screen_test.dart
        payment_screen_test.dart
    integration_test/
      checkout_flow_test.dart
      auth_flow_test.dart
```

---

## Chunk 1: Project Scaffolding & Domain Models

### Task 1: Create Flutter project and add dependencies

**Files:**
- Create: `jesses_pizza_app/pubspec.yaml`
- Create: `jesses_pizza_app/analysis_options.yaml`

- [ ] **Step 1: Create Flutter project**

```bash
cd /home/rickduggan/workspace/clients/jesses-pizza/jesses-pizza
flutter create jesses_pizza_app --org com.jessespizza --platforms android,ios
```

- [ ] **Step 2: Replace pubspec.yaml dependencies**

Replace the dependencies section in `jesses_pizza_app/pubspec.yaml`:

```yaml
name: jesses_pizza_app
description: Jesse's Pizza customer ordering app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.7.0

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  dio: ^5.8.0
  get_it: ^8.0.3
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0
  webview_flutter: ^4.12.0
  flutter_secure_storage: ^9.2.4
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.14
  freezed: ^3.0.0
  json_serializable: ^6.9.4
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```

- [ ] **Step 3: Install dependencies**

```bash
cd jesses_pizza_app && flutter pub get
```

- [ ] **Step 4: Verify project builds**

```bash
flutter analyze
```
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add jesses_pizza_app/
git commit -m "feat: scaffold Flutter project with dependencies"
```

---

### Task 2: Domain models — User

**Files:**
- Create: `lib/domain/models/user.dart`
- Create: `lib/domain/models/api_response.dart`
- Test: `test/domain/models/user_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

void main() {
  group('User', () {
    test('fromJson creates User from API login response', () {
      final json = {
        'token': 'jwt-token-123',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'isGuest': false,
        'email': 'test@example.com',
      };
      final user = User.fromJson(json);
      expect(user.token, 'jwt-token-123');
      expect(user.isGuest, false);
      expect(user.email, 'test@example.com');
    });

    test('fromJson handles guest login response', () {
      final json = {
        'token': 'guest-token',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'isGuest': true,
      };
      final user = User.fromJson(json);
      expect(user.isGuest, true);
      expect(user.email, isNull);
    });

    test('toJson produces valid JSON', () {
      final user = User(
        token: 'jwt-token-123',
        tokenExpires: DateTime.parse('2026-09-16T00:00:00Z'),
        isGuest: false,
        email: 'test@example.com',
      );
      final json = user.toJson();
      expect(json['token'], 'jwt-token-123');
      expect(json['isGuest'], false);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/domain/models/user_test.dart
```
Expected: FAIL — `user.dart` does not exist

- [ ] **Step 3: Create api_response.dart**

```dart
// lib/domain/models/api_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool succeeded,
    String? message,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}
```

- [ ] **Step 4: Create user.dart**

```dart
// lib/domain/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String token,
    required DateTime tokenExpires,
    required bool isGuest,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

- [ ] **Step 5: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 6: Run test to verify it passes**

```bash
flutter test test/domain/models/user_test.dart
```
Expected: All tests PASS

- [ ] **Step 7: Commit**

```bash
git add lib/domain/models/user.dart lib/domain/models/api_response.dart test/domain/models/user_test.dart
git commit -m "feat: add User and ApiResponse domain models"
```

---

### Task 3: Domain models — Menu

**Files:**
- Create: `lib/domain/models/menu_group.dart`
- Create: `lib/domain/models/menu_item.dart`
- Test: `test/domain/models/menu_item_test.dart`

The menu models must match the MongoDB document structure returned by the API. Check `JessesPizza.Core/Models/` for the exact field names — look at `MainMenuItemWrapper`, `GroupWrapper`, and related classes.

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/models/menu_item_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

void main() {
  group('MenuGroup', () {
    test('fromJson creates MenuGroup', () {
      final json = {
        'id': 'group-1',
        'name': 'Pizzas',
        'description': 'Our famous pizzas',
        'imageUrl': 'https://example.com/pizza.jpg',
      };
      final group = MenuGroup.fromJson(json);
      expect(group.name, 'Pizzas');
    });
  });

  group('MenuItem', () {
    test('fromJson creates MenuItem with sizes', () {
      final json = {
        'id': 'item-1',
        'name': 'Pepperoni Pizza',
        'description': 'Classic pepperoni',
        'groupId': 'group-1',
        'imageUrl': 'https://example.com/pepperoni.jpg',
        'sizes': [
          {'name': 'Small', 'price': 9.99},
          {'name': 'Large', 'price': 14.99},
        ],
      };
      final item = MenuItem.fromJson(json);
      expect(item.name, 'Pepperoni Pizza');
      expect(item.sizes.length, 2);
      expect(item.sizes.first.price, 9.99);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/domain/models/menu_item_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create menu_group.dart**

```dart
// lib/domain/models/menu_group.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_group.freezed.dart';
part 'menu_group.g.dart';

@freezed
abstract class MenuGroup with _$MenuGroup {
  const factory MenuGroup({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  }) = _MenuGroup;

  factory MenuGroup.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupFromJson(json);
}
```

- [ ] **Step 4: Create menu_item.dart**

```dart
// lib/domain/models/menu_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    String? description,
    String? groupId,
    String? imageUrl,
    @Default([]) List<MenuItemSize> sizes,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}

@freezed
abstract class MenuItemSize with _$MenuItemSize {
  const factory MenuItemSize({
    required String name,
    required double price,
  }) = _MenuItemSize;

  factory MenuItemSize.fromJson(Map<String, dynamic> json) =>
      _$MenuItemSizeFromJson(json);
}
```

- [ ] **Step 5: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 6: Run test to verify it passes**

```bash
flutter test test/domain/models/menu_item_test.dart
```
Expected: All tests PASS

- [ ] **Step 7: Commit**

```bash
git add lib/domain/models/menu_group.dart lib/domain/models/menu_item.dart test/domain/models/menu_item_test.dart
git commit -m "feat: add MenuGroup and MenuItem domain models"
```

---

### Task 4: Domain models — Transaction, Address, CreditCard, CartItem

**Files:**
- Create: `lib/domain/models/transaction.dart`
- Create: `lib/domain/models/address.dart`
- Create: `lib/domain/models/credit_card.dart`
- Create: `lib/domain/models/cart_item.dart`
- Test: `test/domain/models/transaction_test.dart`

The transaction model must handle both v1.0 and v1.1 response shapes. Check `JessesPizza.Core/Models/` for `MongoTransaction` and `MongoTransactionV1_1` to get exact field names. Key difference: v1.1 has `TransactionStateV1_1` enum and richer item data.

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/models/transaction_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

void main() {
  group('Transaction', () {
    test('fromJson creates Transaction from v1.1 response', () {
      final json = {
        'id': 'txn-1',
        'date': '2026-03-16T12:00:00Z',
        'total': 24.99,
        'isDelivery': true,
        'name': 'John Doe',
        'transactionState': 'Authorized',
        'items': [],
      };
      final txn = Transaction.fromJson(json);
      expect(txn.total, 24.99);
      expect(txn.isDelivery, true);
    });
  });

  group('Address', () {
    test('fromJson creates Address', () {
      final json = {
        'id': 'addr-1',
        'addressLine1': '123 Main St',
        'city': 'Springfield',
        'zipCode': '12345',
      };
      final addr = Address.fromJson(json);
      expect(addr.addressLine1, '123 Main St');
    });
  });

  group('CreditCard', () {
    test('fromJson creates CreditCard with masked number', () {
      final json = {
        'id': 'card-1',
        'cardNumber': '****1234',
        'expirationDate': '12/28',
      };
      final card = CreditCard.fromJson(json);
      expect(card.cardNumber, '****1234');
    });
  });

  group('CartItem', () {
    test('calculates line total from quantity and price', () {
      final item = CartItem(
        menuItemId: 'item-1',
        name: 'Pepperoni Pizza',
        sizeName: 'Large',
        price: 14.99,
        quantity: 2,
      );
      expect(item.lineTotal, 29.98);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/domain/models/transaction_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create address.dart**

```dart
// lib/domain/models/address.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    String? id,
    required String addressLine1,
    String? addressLine2,
    required String city,
    String? state,
    required String zipCode,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
```

- [ ] **Step 4: Create credit_card.dart**

```dart
// lib/domain/models/credit_card.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';
part 'credit_card.g.dart';

@freezed
abstract class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String id,
    required String cardNumber,
    required String expirationDate,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);
}
```

- [ ] **Step 5: Create transaction.dart**

```dart
// lib/domain/models/transaction.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required DateTime date,
    required double total,
    required bool isDelivery,
    String? name,
    String? transactionState,
    String? convergeTransactionId,
    @Default([]) List<TransactionItem> items,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String name,
    required double price,
    required int quantity,
    String? sizeName,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);
}
```

- [ ] **Step 6: Create cart_item.dart**

```dart
// lib/domain/models/cart_item.dart

class CartItem {
  final String menuItemId;
  final String name;
  final String sizeName;
  final double price;
  final int quantity;

  const CartItem({
    required this.menuItemId,
    required this.name,
    required this.sizeName,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuItemId: menuItemId,
      name: name,
      sizeName: sizeName,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
```

- [ ] **Step 7: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 8: Run test to verify it passes**

```bash
flutter test test/domain/models/transaction_test.dart
```
Expected: All tests PASS

- [ ] **Step 9: Commit**

```bash
git add lib/domain/models/ test/domain/models/transaction_test.dart
git commit -m "feat: add Transaction, Address, CreditCard, CartItem models"
```

---

## Chunk 2: API Client & Repository Layer

### Task 5: API endpoint constants and ApiClient

**Files:**
- Create: `lib/data/api/api_endpoints.dart`
- Create: `lib/data/api/api_client.dart`
- Test: `test/data/api/api_client_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/data/api/api_client_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';

void main() {
  group('ApiEndpoints', () {
    test('auth endpoints have correct paths', () {
      expect(ApiEndpoints.login, '/api/Auth/UserLogin');
      expect(ApiEndpoints.guestLogin, '/api/Auth/GuestLogin');
      expect(ApiEndpoints.createUser, '/api/Auth/CreateUser');
      expect(ApiEndpoints.confirmAccount, '/api/Auth/ConfirmAccount');
      expect(ApiEndpoints.deleteAccount, '/api/Auth/DeleteAccount');
    });

    test('mongo endpoints have correct paths', () {
      expect(ApiEndpoints.checkHours, '/api/Mongo/CheckHours');
      expect(ApiEndpoints.groups, '/api/Mongo/Groups');
      expect(ApiEndpoints.mainMenuItems, '/api/Mongo/MainMenuItems');
      expect(ApiEndpoints.postTransaction, '/api/Mongo/PostTransaction');
      expect(ApiEndpoints.getHppToken, '/api/Mongo/GetHPPToken');
      expect(ApiEndpoints.getOrders, '/api/Mongo/GetOrders');
      expect(ApiEndpoints.deleteCard, '/api/Mongo/DeleteCard');
      expect(ApiEndpoints.getAccountInfo, '/api/Mongo/GetAccountInfo');
      expect(ApiEndpoints.validateTransaction, '/api/Mongo/ValidateTransaction');
    });
  });

  group('ApiClient', () {
    test('attaches auth token to requests when token is set', () {
      final client = ApiClient(baseUrl: 'https://test.com');
      client.setToken('test-jwt-token');

      final dio = client.dio;
      // Verify interceptor is configured
      expect(dio.interceptors.length, greaterThan(0));
    });

    test('clears auth token', () {
      final client = ApiClient(baseUrl: 'https://test.com');
      client.setToken('test-jwt-token');
      client.clearToken();
      // Should not throw
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/data/api/api_client_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create api_endpoints.dart**

```dart
// lib/data/api/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const login = '/api/Auth/UserLogin';
  static const guestLogin = '/api/Auth/GuestLogin';
  static const validateEmail = '/api/Auth/ValidateEmailAddress';
  static const createUser = '/api/Auth/CreateUser';
  static const confirmAccount = '/api/Auth/ConfirmAccount';
  static const resendSignupCode = '/api/Auth/ResendSignupCode';
  static const forgotPassword = '/api/Auth/ForgotPassword';
  static const confirmPasswordChange = '/api/Auth/ConfirmPasswordChange';
  static const resendChangePasswordCode = '/api/Auth/ResendChangePasswordCode';
  static const newPassword = '/api/Auth/NewPassword';
  static const deleteAccount = '/api/Auth/DeleteAccount';

  // Menu
  static const checkHours = '/api/Mongo/CheckHours';
  static const groups = '/api/Mongo/Groups';
  static const mainMenuItems = '/api/Mongo/MainMenuItems';

  // Orders
  static const postTransaction = '/api/Mongo/PostTransaction';
  static const getHppToken = '/api/Mongo/GetHPPToken';
  static const getOrders = '/api/Mongo/GetOrders';
  static const validateTransaction = '/api/Mongo/ValidateTransaction';
  static const transactionGuid = '/api/Mongo/TransactionGuid';

  // Account
  static const addresses = '/api/Mongo/Addresses';
  static const saveAddress = '/api/Mongo/SaveAddress';
  static const deleteAddress = '/api/Mongo/DeleteAddress';
  static const creditCards = '/api/Mongo/CreditCards';
  static const saveCreditCard = '/api/Mongo/SaveCreditCard';
  static const deleteCard = '/api/Mongo/DeleteCard';
  static const getAccountInfo = '/api/Mongo/GetAccountInfo';

  // Other
  static const privacy = '/api/Mongo/Privacy';
}
```

- [ ] **Step 4: Create api_client.dart**

```dart
// lib/data/api/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  String? _token;

  ApiClient({required String baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
    ));
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  void setApiVersion(RequestOptions options, String version) {
    options.headers['X-Version'] = version;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? apiVersion,
  }) async {
    final options = Options();
    if (apiVersion != null) {
      options.headers = {'X-Version': apiVersion};
    }
    return dio.get<T>(path,
        queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    String? apiVersion,
  }) async {
    final options = Options();
    if (apiVersion != null) {
      options.headers = {'X-Version': apiVersion};
    }
    return dio.post<T>(path, data: data, options: options);
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
flutter test test/data/api/api_client_test.dart
```
Expected: All tests PASS

- [ ] **Step 6: Commit**

```bash
git add lib/data/api/ test/data/api/
git commit -m "feat: add ApiClient with JWT interceptor and endpoint constants"
```

---

### Task 6: Repository interfaces

**Files:**
- Create: `lib/domain/repositories/i_auth_repository.dart`
- Create: `lib/domain/repositories/i_menu_repository.dart`
- Create: `lib/domain/repositories/i_order_repository.dart`
- Create: `lib/domain/repositories/i_account_repository.dart`

- [ ] **Step 1: Create i_auth_repository.dart**

```dart
// lib/domain/repositories/i_auth_repository.dart
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

abstract class IAuthRepository {
  Future<User> login(String email, String password, String deviceId);
  Future<User> guestLogin(String deviceId);
  Future<ApiResponse> validateEmail(String email, String password);
  Future<ApiResponse> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });
  Future<ApiResponse> confirmAccount(String email, String code);
  Future<ApiResponse> resendSignupCode(String email);
  Future<ApiResponse> forgotPassword(String email);
  Future<ApiResponse> confirmPasswordChange(String email, String code);
  Future<ApiResponse> resendChangePasswordCode(String email);
  Future<ApiResponse> newPassword(String email, String password, String token);
  Future<ApiResponse> deleteAccount();
}
```

- [ ] **Step 2: Create i_menu_repository.dart**

```dart
// lib/domain/repositories/i_menu_repository.dart
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

abstract class IMenuRepository {
  Future<List<MenuGroup>> getGroups();
  Future<List<MenuItem>> getMenuItems();
  Future<bool> checkHours();
}
```

- [ ] **Step 3: Create i_order_repository.dart**

```dart
// lib/domain/repositories/i_order_repository.dart
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';

abstract class IOrderRepository {
  Future<ApiResponse> validateTransaction(Map<String, dynamic> transaction);
  Future<ApiResponse> postTransaction(Map<String, dynamic> transaction);
  Future<String> getHppToken(Map<String, dynamic> transaction);
  Future<List<Transaction>> getOrders();
  Future<Transaction> getTransactionByGuid(String guid);
}
```

- [ ] **Step 4: Create i_account_repository.dart**

```dart
// lib/domain/repositories/i_account_repository.dart
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';

abstract class IAccountRepository {
  Future<Map<String, dynamic>> getAccountInfo();
  Future<List<Address>> getAddresses();
  Future<ApiResponse> saveAddress(Address address);
  Future<ApiResponse> deleteAddress(Address address);
  Future<List<CreditCard>> getCreditCards();
  Future<ApiResponse> saveCreditCard(CreditCard card);
  Future<ApiResponse> deleteCreditCard(String cardId);
  Future<String> getPrivacyPolicy();
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/domain/repositories/
git commit -m "feat: add repository interfaces for auth, menu, order, account"
```

---

### Task 7: Auth repository implementation

**Files:**
- Create: `lib/data/repositories/auth_repository.dart`
- Test: `test/data/repositories/auth_repository_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/data/repositories/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/auth_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockClient;
  late AuthRepository repository;

  setUp(() {
    mockClient = MockApiClient();
    repository = AuthRepository(mockClient);
  });

  group('login', () {
    test('returns User on successful login', () async {
      when(() => mockClient.post<Map<String, dynamic>>(
            ApiEndpoints.login,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: {
              'token': 'jwt-123',
              'tokenExpires': '2026-09-16T00:00:00Z',
              'isGuest': false,
              'email': 'test@test.com',
            },
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final user = await repository.login('test@test.com', 'pass', 'device1');
      expect(user.token, 'jwt-123');
      expect(user.isGuest, false);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/data/repositories/auth_repository_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create auth_repository.dart**

```dart
// lib/data/repositories/auth_repository.dart
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

  @override
  Future<User> login(String email, String password, String deviceId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, 'deviceId': deviceId},
      apiVersion: '1.0',
    );
    return User.fromJson(response.data!);
  }

  @override
  Future<User> guestLogin(String deviceId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.guestLogin,
      data: {'deviceId': deviceId},
      apiVersion: '1.0',
    );
    return User.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> validateEmail(String email, String password) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.validateEmail,
      data: {'email': email, 'password': password},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.createUser,
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      },
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> confirmAccount(String email, String code) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.confirmAccount,
      data: {'email': email, 'code': code},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> resendSignupCode(String email) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.resendSignupCode,
      data: {'email': email},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> forgotPassword(String email) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> confirmPasswordChange(String email, String code) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.confirmPasswordChange,
      data: {'email': email, 'code': code},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> resendChangePasswordCode(String email) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.resendChangePasswordCode,
      data: {'email': email},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> newPassword(
      String email, String password, String token) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.newPassword,
      data: {'email': email, 'password': password, 'token': token},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteAccount() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.deleteAccount,
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/data/repositories/auth_repository_test.dart
```
Expected: All tests PASS

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/auth_repository.dart test/data/repositories/auth_repository_test.dart
git commit -m "feat: add AuthRepository implementation"
```

---

### Task 8: Menu, Order, and Account repository implementations

**Files:**
- Create: `lib/data/repositories/menu_repository.dart`
- Create: `lib/data/repositories/order_repository.dart`
- Create: `lib/data/repositories/account_repository.dart`
- Test: `test/data/repositories/menu_repository_test.dart`
- Test: `test/data/repositories/order_repository_test.dart`
- Test: `test/data/repositories/account_repository_test.dart`

- [ ] **Step 1: Write failing test for MenuRepository**

```dart
// test/data/repositories/menu_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/menu_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockClient;
  late MenuRepository repository;

  setUp(() {
    mockClient = MockApiClient();
    repository = MenuRepository(mockClient);
  });

  group('getGroups', () {
    test('returns list of MenuGroups', () async {
      when(() => mockClient.get<List<dynamic>>(
            ApiEndpoints.groups,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: [
              {'id': '1', 'name': 'Pizzas'},
              {'id': '2', 'name': 'Drinks'},
            ],
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final groups = await repository.getGroups();
      expect(groups.length, 2);
      expect(groups.first.name, 'Pizzas');
    });
  });

  group('checkHours', () {
    test('returns boolean from API', () async {
      when(() => mockClient.get<bool>(
            ApiEndpoints.checkHours,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: true,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      final isOpen = await repository.checkHours();
      expect(isOpen, true);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/data/repositories/menu_repository_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create menu_repository.dart**

```dart
// lib/data/repositories/menu_repository.dart
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';

class MenuRepository implements IMenuRepository {
  final ApiClient _client;

  MenuRepository(this._client);

  @override
  Future<List<MenuGroup>> getGroups() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.groups,
      apiVersion: '1.0',
    );
    return response.data!
        .map((json) => MenuGroup.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MenuItem>> getMenuItems() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.mainMenuItems,
      apiVersion: '1.0',
    );
    return response.data!
        .map((json) => MenuItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> checkHours() async {
    final response = await _client.get<bool>(
      ApiEndpoints.checkHours,
      apiVersion: '1.0',
    );
    return response.data!;
  }
}
```

- [ ] **Step 4: Create order_repository.dart**

```dart
// lib/data/repositories/order_repository.dart
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';

class OrderRepository implements IOrderRepository {
  final ApiClient _client;

  OrderRepository(this._client);

  @override
  Future<ApiResponse> validateTransaction(
      Map<String, dynamic> transaction) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.validateTransaction,
      data: transaction,
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> postTransaction(
      Map<String, dynamic> transaction) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.postTransaction,
      data: transaction,
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<String> getHppToken(Map<String, dynamic> transaction) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.getHppToken,
      data: transaction,
      apiVersion: '1.1',
    );
    return response.data!['token'] as String;
  }

  @override
  Future<List<Transaction>> getOrders() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.getOrders,
      apiVersion: '1.1',
    );
    final data = response.data!;
    final transactions = (data['transactions'] as List<dynamic>?) ?? [];
    return transactions
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Transaction> getTransactionByGuid(String guid) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.transactionGuid,
      queryParameters: {'guid': guid},
      apiVersion: '1.1',
    );
    return Transaction.fromJson(response.data!);
  }
}
```

- [ ] **Step 5: Create account_repository.dart**

```dart
// lib/data/repositories/account_repository.dart
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';

class AccountRepository implements IAccountRepository {
  final ApiClient _client;

  AccountRepository(this._client);

  @override
  Future<Map<String, dynamic>> getAccountInfo() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.getAccountInfo,
      apiVersion: '1.0',
    );
    return response.data!;
  }

  @override
  Future<List<Address>> getAddresses() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.addresses,
      apiVersion: '1.0',
    );
    final data = response.data!;
    final addresses = (data['addresses'] as List<dynamic>?) ?? [];
    return addresses
        .map((json) => Address.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ApiResponse> saveAddress(Address address) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.saveAddress,
      data: {'address': address.toJson()},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteAddress(Address address) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.deleteAddress,
      data: {'address': address.toJson()},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<List<CreditCard>> getCreditCards() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.creditCards,
      apiVersion: '1.0',
    );
    final data = response.data!;
    final cards = (data['creditCards'] as List<dynamic>?) ?? [];
    return cards
        .map((json) => CreditCard.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ApiResponse> saveCreditCard(CreditCard card) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.saveCreditCard,
      data: card.toJson(),
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteCreditCard(String cardId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.deleteCard,
      data: {'creditCardId': cardId},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<String> getPrivacyPolicy() async {
    final response = await _client.get<String>(
      ApiEndpoints.privacy,
      apiVersion: '1.0',
    );
    return response.data!;
  }
}
```

- [ ] **Step 6: Write and run tests for order and account repos**

Follow the same pattern as auth_repository_test.dart — mock ApiClient, verify correct endpoints are called with correct API versions, verify response mapping.

- [ ] **Step 7: Run all tests**

```bash
flutter test
```
Expected: All tests PASS

- [ ] **Step 8: Commit**

```bash
git add lib/data/repositories/ test/data/repositories/
git commit -m "feat: add Menu, Order, Account repository implementations"
```

---

## Chunk 3: BLoCs

### Task 9: AuthBloc

**Files:**
- Create: `lib/presentation/blocs/auth/auth_event.dart`
- Create: `lib/presentation/blocs/auth/auth_state.dart`
- Create: `lib/presentation/blocs/auth/auth_bloc.dart`
- Test: `test/presentation/blocs/auth_bloc_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/presentation/blocs/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  final testUser = User(
    token: 'jwt-123',
    tokenExpires: DateTime(2026, 9, 16),
    isGuest: false,
    email: 'test@test.com',
  );

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] on successful login',
      build: () {
        when(() => mockRepo.login('test@test.com', 'pass', 'device1'))
            .thenAnswer((_) async => testUser);
        return AuthBloc(authRepository: mockRepo);
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          email: 'test@test.com',
          password: 'pass',
          deviceId: 'device1',
        ),
      ),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] on failed login',
      build: () {
        when(() => mockRepo.login(any(), any(), any()))
            .thenThrow(Exception('Invalid credentials'));
        return AuthBloc(authRepository: mockRepo);
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          email: 'bad@test.com',
          password: 'wrong',
          deviceId: 'device1',
        ),
      ),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] on logout',
      build: () => AuthBloc(authRepository: mockRepo),
      seed: () => AuthState.authenticated(testUser),
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [const AuthState.unauthenticated()],
    );
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/presentation/blocs/auth_bloc_test.dart
```
Expected: FAIL

- [ ] **Step 3: Create auth_event.dart**

```dart
// lib/presentation/blocs/auth/auth_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
    required String deviceId,
  }) = LoginRequested;

  const factory AuthEvent.signUpRequested({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) = SignUpRequested;

  const factory AuthEvent.confirmAccountRequested({
    required String email,
    required String code,
  }) = ConfirmAccountRequested;

  const factory AuthEvent.logoutRequested() = LogoutRequested;
  const factory AuthEvent.tokenExpired() = TokenExpired;
}
```

- [ ] **Step 4: Create auth_state.dart**

```dart
// lib/presentation/blocs/auth/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

- [ ] **Step 5: Create auth_bloc.dart**

```dart
// lib/presentation/blocs/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenExpired>(_onTokenExpired);
    on<SignUpRequested>(_onSignUpRequested);
    on<ConfirmAccountRequested>(_onConfirmAccountRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.login(
        event.email,
        event.password,
        event.deviceId,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.createUser(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      );
      // After creating user, they need to confirm via SMS
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onConfirmAccountRequested(
    ConfirmAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final response = await _authRepository.confirmAccount(
        event.email,
        event.code,
      );
      if (!response.succeeded) {
        emit(AuthState.error(response.message ?? 'Verification failed'));
        return;
      }
      // After confirming, log the user in
      final user = await _authRepository.login(event.email, '', '');
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }

  void _onTokenExpired(
    TokenExpired event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }
}
```

- [ ] **Step 6: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 7: Run test to verify it passes**

```bash
flutter test test/presentation/blocs/auth_bloc_test.dart
```
Expected: All tests PASS

- [ ] **Step 8: Commit**

```bash
git add lib/presentation/blocs/auth/ test/presentation/blocs/auth_bloc_test.dart
git commit -m "feat: add AuthBloc with login, signup, logout"
```

---

### Task 10: MenuBloc

**Files:**
- Create: `lib/presentation/blocs/menu/menu_event.dart`
- Create: `lib/presentation/blocs/menu/menu_state.dart`
- Create: `lib/presentation/blocs/menu/menu_bloc.dart`
- Test: `test/presentation/blocs/menu_bloc_test.dart`

Follow the same TDD pattern as AuthBloc. Key behaviors:
- `LoadMenu` → fetches groups and items, emits loaded state
- `CheckStoreHours` → calls `checkHours()`, emits open/closed status
- State includes `isStoreOpen` boolean used by CartBloc

- [ ] **Step 1-8: TDD cycle** (same pattern as Task 9)

Commit message: `"feat: add MenuBloc with menu loading and store hours check"`

---

### Task 11: CartBloc

**Files:**
- Create: `lib/presentation/blocs/cart/cart_event.dart`
- Create: `lib/presentation/blocs/cart/cart_state.dart`
- Create: `lib/presentation/blocs/cart/cart_bloc.dart`
- Test: `test/presentation/blocs/cart_bloc_test.dart`

Key behaviors:
- `AddItem` → adds CartItem or increments quantity if already in cart
- `RemoveItem` → removes item from cart
- `UpdateQuantity` → updates item quantity
- `SetDeliveryMode` → sets pickup vs delivery
- `SetAddress` → sets delivery address
- `ClearCart` → empties cart
- State exposes `total` (sum of all line totals)

- [ ] **Step 1-8: TDD cycle** (same pattern as Task 9)

Commit message: `"feat: add CartBloc with add/remove/quantity management"`

---

### Task 12: OrderBloc

**Files:**
- Create: `lib/presentation/blocs/order/order_event.dart`
- Create: `lib/presentation/blocs/order/order_state.dart`
- Create: `lib/presentation/blocs/order/order_bloc.dart`
- Test: `test/presentation/blocs/order_bloc_test.dart`

Key behaviors:
- `SubmitOrder` → calls `validateTransaction`, then `postTransaction`
- `LoadOrderHistory` → fetches orders via `getOrders`
- `LoadOrderDetail` → fetches single order via `getTransactionByGuid`
- `RequestHppToken` → gets HPP token for WebView flow

- [ ] **Step 1-8: TDD cycle**

Commit message: `"feat: add OrderBloc with order submission and history"`

---

### Task 13: AccountBloc

**Files:**
- Create: `lib/presentation/blocs/account/account_event.dart`
- Create: `lib/presentation/blocs/account/account_state.dart`
- Create: `lib/presentation/blocs/account/account_bloc.dart`
- Test: `test/presentation/blocs/account_bloc_test.dart`

Key behaviors:
- `LoadProfile` → fetches account info
- `SaveAddress` / `DeleteAddress` → manages addresses, refreshes list
- `SaveCard` / `DeleteCard` → manages credit cards, refreshes list

- [ ] **Step 1-8: TDD cycle**

Commit message: `"feat: add AccountBloc with profile, addresses, credit cards"`

---

## Chunk 4: DI Setup, Theme, and App Shell

### Task 14: Dependency injection setup

**Files:**
- Create: `lib/main.dart`
- Create: `lib/app/di.dart`

- [ ] **Step 1: Create di.dart**

```dart
// lib/app/di.dart
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/repositories/auth_repository.dart';
import 'package:jesses_pizza_app/data/repositories/menu_repository.dart';
import 'package:jesses_pizza_app/data/repositories/order_repository.dart';
import 'package:jesses_pizza_app/data/repositories/account_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // API
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://services.jessespizza.com:5000'),
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Repositories
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IMenuRepository>(
    () => MenuRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IOrderRepository>(
    () => OrderRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IAccountRepository>(
    () => AccountRepository(getIt<ApiClient>()),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<IAuthRepository>()),
  );
  getIt.registerFactory<MenuBloc>(
    () => MenuBloc(menuRepository: getIt<IMenuRepository>()),
  );
  getIt.registerFactory<CartBloc>(() => CartBloc());
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(orderRepository: getIt<IOrderRepository>()),
  );
  getIt.registerFactory<AccountBloc>(
    () => AccountBloc(accountRepository: getIt<IAccountRepository>()),
  );
}
```

- [ ] **Step 2: Create main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const JessesPizzaApp());
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart lib/app/di.dart
git commit -m "feat: add dependency injection setup and main entry point"
```

---

### Task 15: Theme and App shell with bottom navigation

**Files:**
- Create: `lib/app/theme.dart`
- Create: `lib/app/app.dart`

- [ ] **Step 1: Create theme.dart**

```dart
// lib/app/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFFE94560);
  static const _backgroundColor = Color(0xFFF5F5F5);

  static ThemeData get light => ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey,
        ),
      );
}
```

- [ ] **Step 2: Create app.dart with bottom navigation shell**

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/app/theme.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/screens/menu/menu_categories_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/cart_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/account_screen.dart';

class JessesPizzaApp extends StatelessWidget {
  const JessesPizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<MenuBloc>()),
        BlocProvider(create: (_) => getIt<CartBloc>()),
        BlocProvider(create: (_) => getIt<OrderBloc>()),
        BlocProvider(create: (_) => getIt<AccountBloc>()),
      ],
      child: MaterialApp(
        title: "Jesse's Pizza",
        theme: AppTheme.light,
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const MenuCategoriesScreen(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const CartScreen(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const AccountScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/app/
git commit -m "feat: add theme, app shell with three-tab bottom navigation"
```

---

## Chunk 5: Screens — Menu Tab

### Task 16: Menu Categories screen

**Files:**
- Create: `lib/presentation/screens/menu/menu_categories_screen.dart`
- Create: `lib/presentation/widgets/store_closed_banner.dart`
- Test: `test/presentation/screens/menu_categories_screen_test.dart`

- [ ] **Step 1-6: TDD cycle** — test that screen shows loading, then list of groups, and store closed banner when `isStoreOpen` is false

Commit message: `"feat: add MenuCategoriesScreen with store hours banner"`

### Task 17: Category Items screen

**Files:**
- Create: `lib/presentation/screens/menu/category_items_screen.dart`
- Create: `lib/presentation/widgets/menu_item_card.dart`

- [ ] **Step 1-6: TDD cycle** — test that screen shows items filtered by group, each with name/image/price

Commit message: `"feat: add CategoryItemsScreen with menu item cards"`

### Task 18: Item Detail screen

**Files:**
- Create: `lib/presentation/screens/menu/item_detail_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test size selection, add to cart button (disabled when store closed), quantity selector

Commit message: `"feat: add ItemDetailScreen with size selection and add-to-cart"`

---

## Chunk 6: Screens — Cart & Checkout Tab

### Task 19: Cart screen

**Files:**
- Create: `lib/presentation/screens/cart/cart_screen.dart`
- Create: `lib/presentation/widgets/cart_item_tile.dart`

- [ ] **Step 1-6: TDD cycle** — test empty cart state, item list with quantities, total display, proceed to checkout

Commit message: `"feat: add CartScreen with item tiles and checkout button"`

### Task 20: Delivery mode and address selection

**Files:**
- Create: `lib/presentation/screens/cart/delivery_mode_screen.dart`
- Create: `lib/presentation/screens/cart/address_selection_screen.dart`
- Create: `lib/presentation/widgets/address_tile.dart`

- [ ] **Step 1-6: TDD cycle** — test pickup/delivery toggle, address list, add new address form

Commit message: `"feat: add delivery mode selection and address management screens"`

### Task 21: Payment screen and HPP WebView

**Files:**
- Create: `lib/presentation/screens/cart/payment_screen.dart`
- Create: `lib/presentation/screens/cart/hpp_webview_screen.dart`
- Create: `lib/presentation/widgets/credit_card_tile.dart`
- Test: `test/presentation/screens/payment_screen_test.dart`

- [ ] **Step 1-6: TDD cycle** — test saved card selection, pay button, HPP WebView launch

Commit message: `"feat: add PaymentScreen with saved cards and HPP WebView"`

### Task 22: Order confirmation screen

**Files:**
- Create: `lib/presentation/screens/cart/order_confirmation_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test order details display, "back to menu" button, cart is cleared

Commit message: `"feat: add OrderConfirmationScreen"`

---

## Chunk 7: Screens — Account Tab

### Task 23: Account overview screen

**Files:**
- Create: `lib/presentation/screens/account/account_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test settings list renders, navigation to sub-screens, unauthenticated state shows login prompt

Commit message: `"feat: add AccountScreen with settings list"`

### Task 24: Order history and detail

**Files:**
- Create: `lib/presentation/screens/account/order_history_screen.dart`
- Create: `lib/presentation/screens/account/order_detail_screen.dart`
- Create: `lib/presentation/widgets/order_tile.dart`

- [ ] **Step 1-6: TDD cycle** — test order list loading, empty state, order detail display

Commit message: `"feat: add order history and detail screens"`

### Task 25: Profile, addresses, credit cards screens

**Files:**
- Create: `lib/presentation/screens/account/profile_screen.dart`
- Create: `lib/presentation/screens/account/addresses_screen.dart`
- Create: `lib/presentation/screens/account/credit_cards_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test read-only profile, address CRUD, credit card CRUD

Commit message: `"feat: add profile, address, and credit card management screens"`

### Task 26: Contact, About screens

**Files:**
- Create: `lib/presentation/screens/account/contact_screen.dart`
- Create: `lib/presentation/screens/account/about_screen.dart`

- [ ] **Step 1-4: Simple implementation** — static content screens

Commit message: `"feat: add Contact Us and About screens"`

---

## Chunk 8: Auth Screens

### Task 27: Login screen

**Files:**
- Create: `lib/presentation/screens/auth/login_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test form validation, login button calls AuthBloc, error display, navigate to signup/forgot password

Commit message: `"feat: add LoginScreen with form validation"`

### Task 28: Signup screen

**Files:**
- Create: `lib/presentation/screens/auth/signup_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test multi-step form (email → password → name/phone), validation, calls CreateUser

Commit message: `"feat: add multi-step SignupScreen"`

### Task 29: SMS verification screen (shared)

**Files:**
- Create: `lib/presentation/screens/auth/sms_verification_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test code input, resend button, calls ConfirmAccount or ConfirmPasswordChange depending on context

Commit message: `"feat: add shared SMS verification screen"`

### Task 30: Forgot password screen

**Files:**
- Create: `lib/presentation/screens/auth/forgot_password_screen.dart`

- [ ] **Step 1-6: TDD cycle** — test email entry, calls ForgotPassword, navigates to SMS verify then new password

Commit message: `"feat: add forgot password flow"`

---

## Chunk 9: Shared Widgets and Polish

### Task 31: Shared widgets

**Files:**
- Create: `lib/presentation/widgets/loading_indicator.dart`
- Create: `lib/presentation/widgets/error_display.dart`

- [ ] **Step 1: Create loading_indicator.dart**

```dart
// lib/presentation/widgets/loading_indicator.dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
```

- [ ] **Step 2: Create error_display.dart**

```dart
// lib/presentation/widgets/error_display.dart
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/widgets/
git commit -m "feat: add shared loading and error widgets"
```

---

## Chunk 10: Integration Tests and Final Verification

### Task 32: Auth flow integration test

**Files:**
- Create: `integration_test/auth_flow_test.dart`

- [ ] **Step 1-4: Write integration test** covering login → authenticated state → logout → unauthenticated state

Commit message: `"test: add auth flow integration test"`

### Task 33: Checkout flow integration test

**Files:**
- Create: `integration_test/checkout_flow_test.dart`

- [ ] **Step 1-4: Write integration test** covering browse menu → add to cart → select delivery → payment → confirmation

Commit message: `"test: add checkout flow integration test"`

### Task 34: Final verification

- [ ] **Step 1: Run all tests**

```bash
flutter test
```
Expected: All tests PASS

- [ ] **Step 2: Run analysis**

```bash
flutter analyze
```
Expected: No issues found

- [ ] **Step 3: Build Android**

```bash
flutter build apk --debug
```
Expected: Build succeeds

- [ ] **Step 4: Build iOS** (if on macOS)

```bash
flutter build ios --debug --no-codesign
```
Expected: Build succeeds

- [ ] **Step 5: Final commit**

```bash
git add .
git commit -m "feat: complete Jesse's Pizza Flutter app v1.0"
```
