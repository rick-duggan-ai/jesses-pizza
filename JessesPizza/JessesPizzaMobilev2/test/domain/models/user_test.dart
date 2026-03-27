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

    test('fromLoginResponse parses real API login shape', () {
      // This is the actual shape returned by the C# LoginResponse:
      // {token, tokenExpires, succeeded, accountConfirmed, name, message}
      // Note: NO isGuest, NO email fields
      final apiJson = {
        'token': 'eyJhbGciOi...',
        'tokenExpires': '2026-09-16T12:00:00Z',
        'succeeded': true,
        'accountConfirmed': true,
        'name': 'Jack',
        'message': 'Login successful',
      };
      final user = User.fromLoginResponse(apiJson, isGuest: false);
      expect(user.token, 'eyJhbGciOi...');
      expect(user.isGuest, false);
      expect(user.accountConfirmed, true);
      expect(user.firstName, 'Jack');
      expect(user.email, isNull);
    });

    test('fromLoginResponse parses guest login (no name, isGuest=true)', () {
      final apiJson = {
        'token': 'guest-jwt-token',
        'tokenExpires': '2026-09-16T12:00:00Z',
        'succeeded': true,
        'accountConfirmed': false,
      };
      final user = User.fromLoginResponse(apiJson, isGuest: true);
      expect(user.token, 'guest-jwt-token');
      expect(user.isGuest, true);
      expect(user.accountConfirmed, false);
      expect(user.firstName, isNull);
    });

    test('fromLoginResponse handles unconfirmed account', () {
      final apiJson = {
        'token': 'jwt-token',
        'tokenExpires': '2026-09-16T12:00:00Z',
        'succeeded': true,
        'accountConfirmed': false,
        'name': 'Jesse',
      };
      final user = User.fromLoginResponse(apiJson);
      expect(user.accountConfirmed, false);
      expect(user.firstName, 'Jesse');
    });
  });
}
