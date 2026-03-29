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
}
