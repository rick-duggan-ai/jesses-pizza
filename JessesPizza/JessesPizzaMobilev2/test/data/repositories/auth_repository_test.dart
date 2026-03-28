import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/auth_repository.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late AuthRepository authRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    authRepository = AuthRepository(apiClient: mockApiClient);
  });

  group('AuthRepository', () {
    test('login returns User on success (real API shape)', () async {
      // Real C# LoginResponse: {token, tokenExpires, succeeded, accountConfirmed, name}
      final responseData = {
        'token': 'jwt-token-123',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'succeeded': true,
        'accountConfirmed': true,
        'name': 'Jack',
      };

      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.login,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.login),
          ));

      final user = await authRepository.login(
          'test@example.com', 'password123', 'device-abc');

      expect(user, isA<User>());
      expect(user.token, 'jwt-token-123');
      expect(user.isGuest, false);
      expect(user.firstName, 'Jack');
      expect(user.accountConfirmed, true);
    });

    test('login throws on failed credentials (#110)', () async {
      // API returns succeeded=false with null token on bad credentials
      final responseData = {
        'succeeded': false,
        'message': 'Invalid username or password',
        'token': null,
        'tokenExpires': null,
        'accountConfirmed': false,
      };

      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.login,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.login),
          ));

      expect(
        () => authRepository.login('bad@email.com', 'wrongpass', 'device'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid username or password'),
        )),
      );
    });

    test('guestLogin returns User with isGuest true', () async {
      // Real C# AppUser: {token, tokenExpires, isGuest}
      final responseData = {
        'token': 'guest-token',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'isGuest': true,
      };

      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.guestLogin,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.guestLogin),
          ));

      final user = await authRepository.guestLogin('device-abc');

      expect(user.isGuest, true);
      expect(user.token, 'guest-token');
    });

    test('guestLogin throws when token is null', () async {
      final responseData = {
        'token': null,
        'tokenExpires': null,
        'isGuest': false,
      };

      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.guestLogin,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.guestLogin),
          ));

      expect(
        () => authRepository.guestLogin('device'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Guest login failed'),
        )),
      );
    });
  });
}
