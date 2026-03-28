import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
    required String deviceId,
  }) = LoginRequested;

  const factory AuthEvent.signUpRequested({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) = SignUpRequested;

  const factory AuthEvent.confirmAccountRequested({
    required String email,
    required String code,
  }) = ConfirmAccountRequested;

  const factory AuthEvent.guestLoginRequested({
    required String deviceId,
  }) = GuestLoginRequested;

  const factory AuthEvent.logoutRequested() = LogoutRequested;

  const factory AuthEvent.tokenExpired() = TokenExpired;

  const factory AuthEvent.deleteAccountRequested() = DeleteAccountRequested;

  const factory AuthEvent.checkStoredAuth() = CheckStoredAuth;
}
