import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';

/// Dio interceptor that detects 401/403 responses indicating token expiration.
///
/// When a non-auth endpoint returns 401 or 403, the interceptor:
/// 1. Clears stored tokens from FlutterSecureStorage
/// 2. Emits an event on [onAuthExpired] so the app can react (e.g. redirect to login)
///
/// Auth endpoints (login, register, etc.) are excluded because they may
/// legitimately return 401/403 for invalid credentials.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final StreamController<void> _authExpiredController =
      StreamController<void>.broadcast();

  /// Endpoints that should NOT trigger the auth-expiration flow.
  static const _excludedPaths = [
    ApiEndpoints.login,
    ApiEndpoints.guestLogin,
    ApiEndpoints.createUser,
    ApiEndpoints.confirmAccount,
    ApiEndpoints.resendSignupCode,
    ApiEndpoints.validateEmail,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.confirmPasswordChange,
    ApiEndpoints.resendChangePasswordCode,
    ApiEndpoints.newPassword,
  ];

  AuthInterceptor({required FlutterSecureStorage storage})
      : _storage = storage;

  /// Stream that emits when a 401/403 is detected on a protected endpoint.
  Stream<void> get onAuthExpired => _authExpiredController.stream;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if ((statusCode == 401 || statusCode == 403) && !_isExcluded(path)) {
      _handleAuthExpired();
    }

    handler.next(err);
  }

  bool _isExcluded(String path) {
    return _excludedPaths.any(
      (excluded) => path.endsWith(excluded) || path == excluded,
    );
  }

  Future<void> _handleAuthExpired() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
    _authExpiredController.add(null);
  }

  /// Dispose the stream controller when no longer needed.
  void dispose() {
    _authExpiredController.close();
  }
}
