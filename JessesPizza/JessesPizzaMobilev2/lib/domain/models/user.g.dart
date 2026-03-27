// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  token: json['token'] as String,
  tokenExpires: DateTime.parse(json['tokenExpires'] as String),
  isGuest: json['isGuest'] as bool,
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'token': instance.token,
  'tokenExpires': instance.tokenExpires.toIso8601String(),
  'isGuest': instance.isGuest,
  'email': instance.email,
  'firstName': instance.firstName,
};
