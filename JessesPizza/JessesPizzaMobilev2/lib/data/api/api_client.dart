import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  String? _token;

  ApiClient({required String baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
    ));
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? apiVersion,
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: apiVersion != null ? Options(headers: {'X-Version': apiVersion}) : null,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    String? apiVersion,
  }) async {
    return dio.post<T>(
      path,
      data: data,
      options: apiVersion != null ? Options(headers: {'X-Version': apiVersion}) : null,
    );
  }
}
