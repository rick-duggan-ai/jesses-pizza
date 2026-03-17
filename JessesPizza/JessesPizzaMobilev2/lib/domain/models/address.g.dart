// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String?,
  addressLine1: json['addressLine1'] as String,
  addressLine2: json['addressLine2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String?,
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
};
