// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreSettings _$StoreSettingsFromJson(Map<String, dynamic> json) =>
    _StoreSettings(
      id: json['id'] as String?,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 8.0,
      deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 3.99,
      minimumOrderAmount:
          (json['minimumOrderAmount'] as num?)?.toDouble() ?? 0.0,
      storeHours:
          (json['storeHours'] as List<dynamic>?)
              ?.map((e) => StoreHours.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      zipCodes:
          (json['zipCodes'] as List<dynamic>?)
              ?.map((e) => ZipCode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      aboutText: json['aboutText'] as String?,
    );

Map<String, dynamic> _$StoreSettingsToJson(_StoreSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taxRate': instance.taxRate,
      'deliveryCharge': instance.deliveryCharge,
      'minimumOrderAmount': instance.minimumOrderAmount,
      'storeHours': instance.storeHours,
      'zipCodes': instance.zipCodes,
      'aboutText': instance.aboutText,
    };

_StoreHours _$StoreHoursFromJson(Map<String, dynamic> json) => _StoreHours(
  day: (json['day'] as num?)?.toInt() ?? 0,
  openingTime: json['openingTime'] as String?,
  closingTime: json['closingTime'] as String?,
);

Map<String, dynamic> _$StoreHoursToJson(_StoreHours instance) =>
    <String, dynamic>{
      'day': instance.day,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
    };

_ZipCode _$ZipCodeFromJson(Map<String, dynamic> json) =>
    _ZipCode(zipCodeValue: json['zipCodeValue'] as String?);

Map<String, dynamic> _$ZipCodeToJson(_ZipCode instance) => <String, dynamic>{
  'zipCodeValue': instance.zipCodeValue,
};
