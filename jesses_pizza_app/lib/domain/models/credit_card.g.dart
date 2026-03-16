// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => _CreditCard(
  id: json['id'] as String,
  cardNumber: json['cardNumber'] as String,
  expirationDate: json['expirationDate'] as String,
);

Map<String, dynamic> _$CreditCardToJson(_CreditCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardNumber': instance.cardNumber,
      'expirationDate': instance.expirationDate,
    };
