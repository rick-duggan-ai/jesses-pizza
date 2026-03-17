import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';

abstract class IAuthRepository {
  Future<User> login(String email, String password, String deviceId);
  Future<User> guestLogin(String deviceId);
  Future<ApiResponse> validateEmail(String email, String password);
  Future<ApiResponse> createUser({
    required String email, required String password,
    required String firstName, required String lastName,
    required String phoneNumber,
  });
  Future<ApiResponse> confirmAccount(String email, String code);
  Future<ApiResponse> resendSignupCode(String email);
  Future<ApiResponse> forgotPassword(String email);
  Future<ApiResponse> confirmPasswordChange(String email, String code);
  Future<ApiResponse> resendChangePasswordCode(String email);
  Future<ApiResponse> newPassword(String email, String password, String token);
  Future<ApiResponse> deleteAccount();
}
