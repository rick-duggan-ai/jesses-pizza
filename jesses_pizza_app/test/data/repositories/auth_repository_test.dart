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
    test('login returns User on success', () async {
      final responseData = {
        'token': 'jwt-token-123',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'isGuest': false,
        'email': 'test@example.com',
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
      expect(user.email, 'test@example.com');
    });

    test('guestLogin returns User with isGuest true', () async {
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

    test('login calls correct endpoint with apiVersion 1.0', () async {
      final responseData = {
        'token': 'jwt-token-123',
        'tokenExpires': '2026-09-16T00:00:00Z',
        'isGuest': false,
        'email': 'test@example.com',
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

      await authRepository.login('test@example.com', 'password123', 'device');

      verify(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.login,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).called(1);
    });
  });
}
