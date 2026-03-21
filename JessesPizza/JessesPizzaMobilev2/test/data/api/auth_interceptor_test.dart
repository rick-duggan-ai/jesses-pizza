import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jesses_pizza_app/data/api/auth_interceptor.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthInterceptor interceptor;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
    interceptor = AuthInterceptor(storage: mockStorage);
  });

  tearDown(() {
    interceptor.dispose();
  });

  DioException makeDioError(int statusCode, String path) {
    final requestOptions = RequestOptions(path: path);
    return DioException(
      requestOptions: requestOptions,
      response: Response(
        requestOptions: requestOptions,
        statusCode: statusCode,
      ),
      type: DioExceptionType.badResponse,
    );
  }

  group('AuthInterceptor', () {
    test('emits auth expired event on 401 from protected endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, '/api/Mongo/GetOrders'),
        handler,
      );

      // Allow async _handleAuthExpired to complete
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(1));
      expect(handler.nextCalled, isTrue);
    });

    test('emits auth expired event on 403 from protected endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(403, '/api/Mongo/Addresses'),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(1));
      expect(handler.nextCalled, isTrue);
    });

    test('does NOT emit on 401 from login endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, ApiEndpoints.login),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
      expect(handler.nextCalled, isTrue);
    });

    test('does NOT emit on 401 from guest login endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, ApiEndpoints.guestLogin),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
    });

    test('does NOT emit on 401 from createUser endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, ApiEndpoints.createUser),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
    });

    test('does NOT emit on 401 from forgotPassword endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, ApiEndpoints.forgotPassword),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
    });

    test('does NOT emit on 404 from protected endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(404, '/api/Mongo/GetOrders'),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
      expect(handler.nextCalled, isTrue);
    });

    test('does NOT emit on 500 from protected endpoint', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(500, '/api/Mongo/GetOrders'),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
    });

    test('clears auth_token and refresh_token from secure storage', () async {
      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, '/api/Mongo/GetOrders'),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
      verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
    });

    test('always passes error to next handler', () {
      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, '/api/Mongo/GetOrders'),
        handler,
      );

      expect(handler.nextCalled, isTrue);
    });

    test('handles error with no response gracefully', () async {
      final events = <void>[];
      interceptor.onAuthExpired.listen(events.add);

      final handler = _FakeErrorInterceptorHandler();
      final err = DioException(
        requestOptions: RequestOptions(path: '/api/Mongo/GetOrders'),
        type: DioExceptionType.connectionTimeout,
      );

      interceptor.onError(err, handler);
      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
      expect(handler.nextCalled, isTrue);
    });

    test('onAuthExpired is a broadcast stream (multiple listeners)', () async {
      final events1 = <void>[];
      final events2 = <void>[];
      interceptor.onAuthExpired.listen(events1.add);
      interceptor.onAuthExpired.listen(events2.add);

      final handler = _FakeErrorInterceptorHandler();
      interceptor.onError(
        makeDioError(401, '/api/Mongo/GetOrders'),
        handler,
      );

      await Future<void>.delayed(Duration.zero);

      expect(events1, hasLength(1));
      expect(events2, hasLength(1));
    });
  });
}

class _FakeErrorInterceptorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;

  @override
  void next(DioException err) {
    nextCalled = true;
  }
}
