import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

/// Persists and restores auth tokens using FlutterSecureStorage.
///
/// Storage keys mirror the V1 Xamarin app:
///   oauth_token, oauth_token_expiration, oauth_token_is_guest, oauth_user_email
class TokenStorageService {
  static const _keyToken = 'oauth_token';
  static const _keyExpiration = 'oauth_token_expiration';
  static const _keyIsGuest = 'oauth_token_is_guest';
  static const _keyEmail = 'oauth_user_email';

  final FlutterSecureStorage _storage;

  TokenStorageService({required FlutterSecureStorage storage})
      : _storage = storage;

  /// Persist auth data after successful login or guest login.
  Future<void> saveUser(User user) async {
    await _storage.write(key: _keyToken, value: user.token);
    await _storage.write(
      key: _keyExpiration,
      value: user.tokenExpires.toIso8601String(),
    );
    await _storage.write(
      key: _keyIsGuest,
      value: user.isGuest.toString(),
    );
    if (user.email != null) {
      await _storage.write(key: _keyEmail, value: user.email);
    } else {
      await _storage.delete(key: _keyEmail);
    }
  }

  /// Attempt to restore a non-expired user from storage.
  /// Returns null if no token stored or token is expired.
  Future<User?> restoreUser() async {
    final token = await _storage.read(key: _keyToken);
    final expirationStr = await _storage.read(key: _keyExpiration);
    final isGuestStr = await _storage.read(key: _keyIsGuest);

    if (token == null || expirationStr == null || isGuestStr == null) {
      return null;
    }

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null || expiration.isBefore(DateTime.now())) {
      // Token expired or unparseable — clear stale data
      await clearAll();
      return null;
    }

    final isGuest = isGuestStr.toLowerCase() == 'true';
    final email = await _storage.read(key: _keyEmail);

    return User(
      token: token,
      tokenExpires: expiration,
      isGuest: isGuest,
      email: email,
    );
  }

  /// Remove all stored auth data (logout / token expiry).
  Future<void> clearAll() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyExpiration);
    await _storage.delete(key: _keyIsGuest);
    await _storage.delete(key: _keyEmail);
  }
}
