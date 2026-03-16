# Jesse's Pizza — Flutter Mobile App Rebuild

## Overview

Rebuild the customer-facing Android and iOS mobile apps using Flutter, replacing the existing Xamarin Forms app. The new app targets feature parity with the existing app (menu browsing, ordering, payment, account management) with a modernized UX. The existing JessesApi (.NET Core 3.1) remains unchanged.

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Framework | Flutter | Strong UI toolkit for food ordering UX, single codebase for Android + iOS, good performance |
| State management | BLoC (flutter_bloc) | Explicit state management for interacting domains (auth, cart, menu, orders, payment). Testable, well-documented. |
| API versioning | Support both v1.0 and v1.1 | Maintain compatibility with both API versions as the current app does |
| Payment provider | Converge/Elavon (unchanged) | Keep existing integration — direct card + HPP WebView flows |
| Push notifications | Out of scope | Would require API changes |
| Store hours | Enforced | Block ordering when store is closed |
| Delivery + Pickup | Both supported | With address management, same as current app |

## Project Structure

```
lib/
  app/                    # App config, routing, theme
  data/
    api/                  # ApiClient (dio), endpoint definitions, request/response DTOs
    repositories/         # Repository implementations
  domain/
    models/               # Domain models (MenuItem, Order, Transaction, User, etc.)
    repositories/         # Repository interfaces (abstractions)
  presentation/
    blocs/                # BLoC classes grouped by feature
    screens/              # Screen widgets grouped by feature
    widgets/              # Shared/reusable widgets
```

### Key boundaries

- **data/api/** — Single `ApiClient` class wrapping HTTP calls to JessesApi. Handles JWT token attachment via `dio` interceptor and error mapping.
- **data/repositories/** — Concrete repos that call the API client and map DTOs to domain models.
- **domain/** — Pure Dart, no Flutter or package dependencies. Models mirror API responses but are owned by the app.
- **presentation/** — BLoCs consume repositories via interfaces. Screens consume BLoCs.

### Core packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `dio` | HTTP client |
| `get_it` | Dependency injection |
| `freezed` + `json_serializable` | Immutable models with JSON serialization |
| `webview_flutter` | Converge HPP payment flow |
| `flutter_secure_storage` | JWT token persistence |
| `mocktail` | Test mocking |
| `bloc_test` | BLoC testing |

## Navigation

Three bottom tabs with push navigation within each tab. Replaces the Xamarin app's hamburger drawer with a modern bottom nav pattern.

### Menu Tab
- **Menu Categories** — list of menu groups
  - → **Category Items** — items within a group
    - → **Item Detail** — sizes, customization, add to cart
- Store closed state: the `CheckHours` endpoint returns a boolean (open/closed). When closed, a banner is displayed and add-to-cart is blocked. The API does not return hour ranges, so the banner will say "Store is currently closed" without specifying opening times.

### Cart Tab
- **Cart Summary** — items, quantities, total
  - → **Pickup or Delivery** selection
  - → **Select/Add Address** (delivery only)
  - → **Payment** — saved card or HPP WebView
  - → **Order Confirmation**

### Account Tab
- **Account Overview**
  - → **Order History** → **Order Detail**
  - → **View Profile** (name, phone, email — read-only, no update endpoint exists)
  - → **Manage Addresses**
  - → **Manage Credit Cards**
  - → **Contact Us**
  - → **About**
  - → **Delete Account**
  - → **Log Out**

### Auth Flow (modal, outside tabs)
- **Login** (email + password)
  - → **Forgot Password** → SMS verification via `ConfirmPasswordChange` → New password
    - Resend code available via `ResendChangePasswordCode`
- **Sign Up** (email validation → password → phone verification via `ConfirmAccount` → create account)
  - Resend code available via `ResendSignupCode`
- Auth is required before checkout. Guests can browse the menu freely.

## BLoCs & State Management

| BLoC | State | Key Events |
|------|-------|------------|
| **AuthBloc** | Current user, JWT token, login status | Login, SignUp, Logout, TokenExpired, ValidateEmail, VerifyPhone |
| **MenuBloc** | Menu groups, menu items, store hours/open status | LoadMenu, LoadGroupItems, CheckStoreHours |
| **CartBloc** | Cart items, quantities, pickup/delivery choice, selected address | AddItem, RemoveItem, UpdateQuantity, SetDeliveryMode, SetAddress, ClearCart |
| **OrderBloc** | Current transaction, payment status, order history | SubmitOrder, ProcessPayment, LoadOrderHistory, LoadOrderDetail |
| **AccountBloc** | User profile, addresses, credit cards | LoadProfile, SaveAddress, DeleteAddress, SaveCard, DeleteCard |

### Key interactions

- `CartBloc` checks `MenuBloc` for store hours before allowing add-to-cart.
- `OrderBloc` reads `CartBloc` state to build the transaction.
- `OrderBloc` requires `AuthBloc` to have a valid token before submitting.
- On `TokenExpired`, `AuthBloc` emits unauthenticated state, which triggers the auth modal.
- Cart state is in-memory only (not persisted to disk). App kill resets the cart. This is a deliberate choice to match the current app's behavior and avoid state sync complexity.

### Order history version handling

The `GetOrders` endpoint returns different response shapes per API version: v1.0 returns `List<MongoTransaction>`, v1.1 returns `List<MongoTransactionV1_1>`. The app will prefer v1.1 (richer data) and fall back to v1.0 if needed.

### JWT token expiration

Login tokens expire after 6 months. The app will react to 401 responses rather than proactively checking expiration. Password-reset tokens expire after 7 days — the forgot-password flow should handle this gracefully with a "code expired" error state.

### Routing

Navigation will use Flutter's built-in imperative Navigator with a `BottomNavigationBar` and per-tab navigator stacks. No third-party routing package needed for this app's complexity.

## API Integration

### Authentication

1. Login/SignUp returns a JWT token.
2. Token stored in `flutter_secure_storage`.
3. `dio` interceptor attaches `Authorization: Bearer {token}` to all requests.
4. On 401 response, `AuthBloc` emits `Unauthenticated` → triggers login modal.
5. API version sent via `X-Version` header.

### Endpoints

| Feature | Method | Endpoint | API Version |
|---------|--------|----------|-------------|
| Login | POST | `/api/Auth/UserLogin` | 1.0 |
| Guest login | POST | `/api/Auth/GuestLogin` | 1.0 |
| Sign up (validate) | POST | `/api/Auth/ValidateEmailAddress` | 1.0 |
| Sign up (create) | POST | `/api/Auth/CreateUser` | 1.0 |
| Confirm account (SMS verify) | POST | `/api/Auth/ConfirmAccount` | 1.0 |
| Resend signup code | POST | `/api/Auth/ResendSignupCode` | 1.0 |
| Forgot password | POST | `/api/Auth/ForgotPassword` | 1.0 |
| Confirm password change | POST | `/api/Auth/ConfirmPasswordChange` | 1.0 |
| Resend password code | POST | `/api/Auth/ResendChangePasswordCode` | 1.0 |
| New password | POST | `/api/Auth/NewPassword` | 1.0 |
| Delete account | POST | `/api/Auth/DeleteAccount` | 1.0 |
| Check store hours | GET | `/api/Mongo/CheckHours` | 1.0 |
| Get menu groups | GET | `/api/Mongo/Groups` | 1.0 |
| Get menu items | GET | `/api/Mongo/MainMenuItems` | 1.0 |
| Submit order | POST | `/api/Mongo/PostTransaction` | 1.0 + 1.1 |
| HPP token | POST | `/api/Mongo/GetHPPToken` | 1.0 + 1.1 |
| Order history | GET | `/api/Mongo/GetOrders` | 1.0 + 1.1 |
| Get addresses | GET | `/api/Mongo/Addresses` | 1.0 |
| Save address | POST | `/api/Mongo/SaveAddress` | 1.0 |
| Delete address | POST | `/api/Mongo/DeleteAddress` | 1.0 |
| Get credit cards | GET | `/api/Mongo/CreditCards` | 1.0 |
| Save credit card | POST | `/api/Mongo/SaveCreditCard` | 1.0 |
| Delete credit card | POST | `/api/Mongo/DeleteCard` | 1.0 |
| Account info | GET | `/api/Mongo/GetAccountInfo` | 1.0 |
| Validate transaction | POST | `/api/Mongo/ValidateTransaction` | 1.0 + 1.1 |
| Get transaction by GUID | GET | `/api/Mongo/TransactionGuid` | 1.0 + 1.1 |
| Privacy policy | GET | `/api/Mongo/Privacy` | 1.0 |

**Notes:**
- There is no `UpdateAccountInfo` endpoint on the API.
- `ValidateTransaction` should be called before `PostTransaction` to validate item availability and pricing.
- `TransactionGuid` is used for the Order Detail screen to fetch a single transaction.
- `CheckHours` returns a raw boolean, not wrapped in the standard `Succeeded`/`Message` envelope.
- `GuestLogin` returns an `AppUser` object (with `Token`, `TokenExpires`, `IsGuest` fields), not the standard `Succeeded`/`Message` envelope.
- KDS/admin-only endpoints (`UpdateTransactionState`, `UpdateTransaction`, `approval`, `CancelPage`) are intentionally excluded. The "Edit Profile" screen will be read-only for now (displays profile info from `GetAccountInfo`). Adding a profile update endpoint would require an API change, which is out of scope.

### Error handling

All API calls return a response object with `Succeeded` (bool) and `Message` (string). The `ApiClient` maps these consistently so BLoCs can surface user-friendly error messages.

## Payment

Two payment paths, matching the existing app.

### Path 1: Saved Credit Card

1. User selects a saved card from their account.
2. `OrderBloc` builds a `MongoTransactionV1_1` from cart state.
3. Sends to `PostTransaction` with the card token.
4. API processes with Converge/Elavon, returns `PostTransactionResponse`.
5. On success → order confirmation screen, cart cleared.
6. On decline → show error message, stay on payment screen.

### Path 2: Hosted Payment Page (HPP)

1. `OrderBloc` requests an HPP token from `GetHPPToken`.
2. App opens a `WebView` to the Converge HPP URL.
3. Customer enters card details on Converge's hosted page (PCI-compliant — card data never touches the app or API).
4. Converge redirects to the API's `ApprovalHPP` endpoint, which processes the payment.
5. App detects the WebView navigation/completion and checks transaction status.
6. On success → order confirmation, cart cleared.
7. On failure → show error, close WebView.

No SignalR connection is needed in the customer app. The `/chatHub` (PizzaHub) hub is KDS-facing only.

No card data is stored locally. Saved cards are tokenized server-side and referenced by ID.

## Testing

### Unit tests
- All BLoCs tested with `bloc_test` — verify state transitions for each event.
- Repository classes tested with mocked `ApiClient` (using `mocktail`).
- Domain model serialization tested (JSON round-trips).

### Widget tests
- Key screens tested with mocked BLoCs — verify correct widgets render for each state (loading, loaded, error, empty).
- Cart interactions (add/remove/quantity changes).

### Integration tests
- End-to-end checkout flow (happy path): browse menu → add to cart → checkout → payment → confirmation.
- Auth flow: sign up, login, token expiration handling.

### Out of scope for testing
- Converge HPP WebView internals (third-party page).
- Pixel-perfect UI.

## Known Issues

- **API typo**: The SMS verification message in `AuthController` reads "Your verifaction code" instead of "Your verification code". This is a server-side bug, not addressable in the Flutter app.
