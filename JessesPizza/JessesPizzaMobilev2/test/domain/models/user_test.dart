import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

void main() {
  group('User', () {
    test('fromJson creates User from stored JSON (token persistence)', () {
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

    test('fromJson defaults isGuest to false when missing', () {
      final json = {
        'token': 'some-token',
        'tokenExpires': '2026-09-16T00:00:00Z',
      };
      final user = User.fromJson(json);
      expect(user.isGuest, false);
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
      expect(json['email'], 'test@example.com');
    });

    test('User constructor sets isGuest and email locally (V1 approach)', () {
      // V1 approach: token + expiration from API, everything else set by caller
      final user = User(
        token: 'api-token',
        tokenExpires: DateTime.parse('2026-09-16T00:00:00Z'),
        isGuest: false,
        email: 'typed@form.com',
        firstName: 'Jack',
        accountConfirmed: true,
      );
      expect(user.token, 'api-token');
      expect(user.isGuest, false);
      expect(user.email, 'typed@form.com');
      expect(user.firstName, 'Jack');
      expect(user.accountConfirmed, true);
    });

    test('Guest user has no email or firstName', () {
      final user = User(
        token: 'guest-token',
        tokenExpires: DateTime.parse('2026-09-16T00:00:00Z'),
        isGuest: true,
      );
      expect(user.isGuest, true);
      expect(user.email, isNull);
      expect(user.firstName, isNull);
      expect(user.accountConfirmed, false);
    });
  });
}
