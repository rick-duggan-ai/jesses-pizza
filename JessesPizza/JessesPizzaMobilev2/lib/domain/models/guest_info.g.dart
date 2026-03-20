// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuestInfo _$GuestInfoFromJson(Map<String, dynamic> json) => _GuestInfo(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  addressLine1: json['addressLine1'] as String,
  city: json['city'] as String,
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$GuestInfoToJson(_GuestInfo instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'addressLine1': instance.addressLine1,
      'city': instance.city,
      'zipCode': instance.zipCode,
    };
