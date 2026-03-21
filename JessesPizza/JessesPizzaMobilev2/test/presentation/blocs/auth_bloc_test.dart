import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockAuthRepository mockRepo;
  late MockApiClient mockApiClient;

  final tUser = User(
    token: 'test-token',
    tokenExpires: DateTime(2030),
    isGuest: false,
    email: 'test@example.com',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    mockApiClient = MockApiClient();
    when(() => mockApiClient.setToken(any())).thenReturn(null);
    when(() => mockApiClient.clearToken()).thenReturn(null);
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      final bloc = AuthBloc(repository: mockRepo, apiClient: mockApiClient);
      expect(bloc.state, const AuthState.initial());
      bloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] on login success',
      build: () {
        when(() => mockRepo.login(any(), any(), any()))
            .thenAnswer((_) async => tUser);
        return AuthBloc(repository: mockRepo, apiClient: mockApiClient);
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
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] on login failure',
      build: () {
        when(() => mockRepo.login(any(), any(), any()))
            .thenThrow(Exception('Invalid credentials'));
        return AuthBloc(repository: mockRepo, apiClient: mockApiClient);
      },
      act: (bloc) => bloc.add(const AuthEvent.loginRequested(
        email: 'bad@example.com',
        password: 'wrong',
        deviceId: 'device-1',
      )),
      expect: () => [
        const AuthState.loading(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] on logout',
      build: () => AuthBloc(repository: mockRepo, apiClient: mockApiClient),
      act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] on token expired',
      build: () => AuthBloc(repository: mockRepo, apiClient: mockApiClient),
      act: (bloc) => bloc.add(const AuthEvent.tokenExpired()),
      expect: () => [const AuthState.unauthenticated()],
    );
  });
}
