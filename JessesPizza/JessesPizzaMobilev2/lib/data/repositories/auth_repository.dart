import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  @override
  Future<User> login(String email, String password, String deviceId) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, 'deviceId': deviceId},
      apiVersion: '1.0',
    );
    final data = response.data!;
    if (data['succeeded'] != true) {
      throw Exception(data['message'] as String? ?? 'Login failed');
    }
    // V1 approach: only grab token + expiration from API, set everything else locally
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Login failed — no token received');
    }
    final expiresRaw = data['tokenExpires'];
    final expires = expiresRaw is String
        ? DateTime.parse(expiresRaw)
        : DateTime.now().add(const Duration(days: 180));

    return User(
      token: token,
      tokenExpires: expires,
      isGuest: false,
      accountConfirmed: data['accountConfirmed'] as bool? ?? false,
      email: email, // from the login form, not the API
      firstName: data['name'] as String?,
    );
  }

  @override
  Future<User> guestLogin(String deviceId) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.guestLogin,
      data: {'secret': 'JessesPizzaAppSecret', 'deviceId': deviceId},
      apiVersion: '1.0',
    );
    final data = response.data!;
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Guest login failed');
    }
    final expiresRaw = data['tokenExpires'];
    final expires = expiresRaw is String
        ? DateTime.parse(expiresRaw)
        : DateTime.now().add(const Duration(days: 180));

    return User(
      token: token,
      tokenExpires: expires,
      isGuest: true, // set locally, not from API
    );
  }

  @override
  Future<ApiResponse> validateEmail(String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.validateEmail,
      data: {'email': email, 'password': password},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.createUser,
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      },
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> confirmAccount(String email, String code) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.confirmAccount,
      data: {'email': email, 'code': code},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> resendSignupCode(String email) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.resendSignupCode,
      data: {'email': email},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> forgotPassword(String phoneNumber) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'phoneNumber': phoneNumber},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> confirmPasswordChange(String phoneNumber, String code) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.confirmPasswordChange,
      data: {'phoneNumber': phoneNumber, 'code': code},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> resendChangePasswordCode(String phoneNumber) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.resendChangePasswordCode,
      data: {'phoneNumber': phoneNumber},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> newPassword(
      String phoneNumber, String password, String token) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.newPassword,
      data: {'phoneNumber': phoneNumber, 'password': password, 'token': token},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteAccount() async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.deleteAccount,
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }
}
