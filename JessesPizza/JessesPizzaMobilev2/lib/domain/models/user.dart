import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String token,
    required DateTime tokenExpires,
    @Default(false) bool isGuest,
    @Default(false) bool accountConfirmed,
    String? email,
    String? firstName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Build a User from the API login/guest response, which returns
  /// {token, tokenExpires, succeeded, accountConfirmed, name} —
  /// NOT the same shape as our model's toJson.
  factory User.fromLoginResponse(Map<String, dynamic> json, {bool isGuest = false}) {
    return User(
      token: json['token'] as String,
      tokenExpires: DateTime.parse(json['tokenExpires'] as String),
      isGuest: isGuest,
      accountConfirmed: json['accountConfirmed'] as bool? ?? false,
      email: json['email'] as String?,
      firstName: json['name'] as String?,
    );
  }
}
