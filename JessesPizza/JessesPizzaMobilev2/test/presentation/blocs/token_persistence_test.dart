import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/services/token_storage_service.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockApiClient extends Mock implements ApiClient {}
class MockTokenStorageService extends Mock implements TokenStorageService {}

void main() {
  late MockAuthRepository mockRepo;
  late MockApiClient mockApiClient;
  late MockTokenStorageService mockTokenStorage;

  final tUser = User(
    token: 'test-token',
    tokenExpires: DateTime(2030),
    isGuest: false,
    email: 'test@example.com',
  );

  final tGuestUser = User(
    token: 'guest-token',
    tokenExpires: DateTime(2030),
    isGuest: true,
  );

  setUpAll(() {
    registerFallbackValue(User(
      token: 'fallback',
      tokenExpires: DateTime(2030),
      isGuest: false,
    ));
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    mockApiClient = MockApiClient();
    mockTokenStorage = MockTokenStorageService();
    when(() => mockApiClient.setToken(any())).thenReturn(null);
    when(() => mockApiClient.clearToken()).thenReturn(null);
    when(() => mockTokenStorage.saveUser(any())).thenAnswer((_) async {});
    when(() => mockTokenStorage.clearAll()).thenAnswer((_) async {});
    when(() => mockTokenStorage.restoreUser()).thenAnswer((_) async => null);
  });

  AuthBloc buildBloc() => AuthBloc(
        repository: mockRepo,
        apiClient: mockApiClient,
        tokenStorage: mockTokenStorage,
      );

  group('CheckStoredAuth', () {
    blocTest<AuthBloc, AuthState>(
      'restores authenticated state when valid token exists in storage',
      build: () {
        when(() => mockTokenStorage.restoreUser())
            .thenAnswer((_) async => tUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.checkStoredAuth()),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(user: tUser),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.restoreUser()).called(1);
        verify(() => mockApiClient.setToken('test-token')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when no token in storage',
      build: () {
        when(() => mockTokenStorage.restoreUser())
            .thenAnswer((_) async => null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.checkStoredAuth()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.restoreUser()).called(1);
        verifyNever(() => mockApiClient.setToken(any()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when storage throws',
      build: () {
        when(() => mockTokenStorage.restoreUser())
            .thenThrow(Exception('storage error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.checkStoredAuth()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
    );
  });

  group('Token save on login', () {
    blocTest<AuthBloc, AuthState>(
      'saves token to storage on successful login',
      build: () {
        when(() => mockRepo.login(any(), any(), any()))
            .thenAnswer((_) async => tUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.loginRequested(
        email: 'test@example.com',
        password: 'password',
        deviceId: 'device-1',
      )),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(user: tUser),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.saveUser(tUser)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'saves token to storage on guest login',
      build: () {
        when(() => mockRepo.guestLogin(any()))
            .thenAnswer((_) async => tGuestUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.guestLoginRequested(
        deviceId: 'device-1',
      )),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(user: tGuestUser),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.saveUser(tGuestUser)).called(1);
      },
    );
  });

  group('Token clear on logout/expiry/delete', () {
    blocTest<AuthBloc, AuthState>(
      'clears storage on logout',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
      expect: () => [const AuthState.unauthenticated()],
      verify: (_) {
        verify(() => mockTokenStorage.clearAll()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'clears storage on token expired',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.tokenExpired()),
      expect: () => [const AuthState.unauthenticated()],
      verify: (_) {
        verify(() => mockTokenStorage.clearAll()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'clears storage on delete account',
      build: () {
        when(() => mockRepo.deleteAccount())
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthEvent.deleteAccountRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.clearAll()).called(1);
      },
    );
  });
}
