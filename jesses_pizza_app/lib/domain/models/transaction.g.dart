// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  total: (json['total'] as num).toDouble(),
  isDelivery: json['isDelivery'] as bool,
  name: json['name'] as String?,
  transactionState: json['transactionState'] as String?,
  convergeTransactionId: json['convergeTransactionId'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'total': instance.total,
      'isDelivery': instance.isDelivery,
      'name': instance.name,
      'transactionState': instance.transactionState,
      'convergeTransactionId': instance.convergeTransactionId,
      'items': instance.items,
    };

_TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    _TransactionItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      sizeName: json['sizeName'] as String?,
    );

Map<String, dynamic> _$TransactionItemToJson(_TransactionItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'sizeName': instance.sizeName,
    };
