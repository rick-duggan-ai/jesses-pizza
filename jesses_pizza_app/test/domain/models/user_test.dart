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
