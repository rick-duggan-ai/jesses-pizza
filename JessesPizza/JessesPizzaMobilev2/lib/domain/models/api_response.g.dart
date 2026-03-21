// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => _ApiResponse(
  succeeded: json['succeeded'] as bool,
  message: json['message'] as String?,
  transactionGuid: json['transactionGuid'] as String?,
);

Map<String, dynamic> _$ApiResponseToJson(_ApiResponse instance) =>
    <String, dynamic>{
      'succeeded': instance.succeeded,
      'message': instance.message,
      'transactionGuid': instance.transactionGuid,
    };
