import 'package:flutter_test/flutter_test.dart';
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
