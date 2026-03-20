// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    _TransactionRequest(
      info: CustomerInfo.fromJson(json['info'] as Map<String, dynamic>),
      transactionItems: (json['transactionItems'] as List<dynamic>)
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: OrderTotals.fromJson(json['totals'] as Map<String, dynamic>),
      isDelivery: json['isDelivery'] as bool,
      noContactDelivery: json['noContactDelivery'] as bool? ?? false,
      specialInstructions: json['specialInstructions'] as String?,
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$TransactionRequestToJson(_TransactionRequest instance) =>
    <String, dynamic>{
      'info': instance.info,
      'transactionItems': instance.transactionItems,
      'totals': instance.totals,
      'isDelivery': instance.isDelivery,
      'noContactDelivery': instance.noContactDelivery,
      'specialInstructions': instance.specialInstructions,
      'transactionId': instance.transactionId,
    };

_PostTransactionRequest _$PostTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _PostTransactionRequest(
  transaction: TransactionRequest.fromJson(
    json['transaction'] as Map<String, dynamic>,
  ),
  card: CreditCardRef.fromJson(json['card'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostTransactionRequestToJson(
  _PostTransactionRequest instance,
) => <String, dynamic>{
  'transaction': instance.transaction,
  'card': instance.card,
};

_CreditCardRef _$CreditCardRefFromJson(Map<String, dynamic> json) =>
    _CreditCardRef(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String?,
      expirationDate: json['expirationDate'] as String?,
      shortDescription: json['shortDescription'] as String?,
    );

Map<String, dynamic> _$CreditCardRefToJson(_CreditCardRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardNumber': instance.cardNumber,
      'expirationDate': instance.expirationDate,
      'shortDescription': instance.shortDescription,
    };

_CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) =>
    _CustomerInfo(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      emailAddress: json['emailAddress'] as String,
      addressLine1: json['addressLine1'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
    );

Map<String, dynamic> _$CustomerInfoToJson(_CustomerInfo instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'emailAddress': instance.emailAddress,
      'addressLine1': instance.addressLine1,
      'city': instance.city,
      'zipCode': instance.zipCode,
    };

_TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    _TransactionItem(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      sizeName: json['sizeName'] as String,
      selectedSizeId: json['selectedSizeId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      requiredChoicesEnabled: json['requiredChoicesEnabled'] as bool? ?? false,
      requiredChoices: json['requiredChoices'] as String?,
      requiredDelimitedString: json['requiredDelimitedString'] as String?,
      optionalChoicesEnabled: json['optionalChoicesEnabled'] as bool? ?? false,
      optionalChoices: json['optionalChoices'] as String?,
      optionalDelimitedString: json['optionalDelimitedString'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      instructionsEnabled: json['instructionsEnabled'] as bool? ?? false,
      instructions: json['instructions'] as String?,
    );

Map<String, dynamic> _$TransactionItemToJson(_TransactionItem instance) =>
    <String, dynamic>{
      'menuItemId': instance.menuItemId,
      'name': instance.name,
      'description': instance.description,
      'sizeName': instance.sizeName,
      'selectedSizeId': instance.selectedSizeId,
      'imageUrl': instance.imageUrl,
      'requiredChoicesEnabled': instance.requiredChoicesEnabled,
      'requiredChoices': instance.requiredChoices,
      'requiredDelimitedString': instance.requiredDelimitedString,
      'optionalChoicesEnabled': instance.optionalChoicesEnabled,
      'optionalChoices': instance.optionalChoices,
      'optionalDelimitedString': instance.optionalDelimitedString,
      'quantity': instance.quantity,
      'price': instance.price,
      'instructionsEnabled': instance.instructionsEnabled,
      'instructions': instance.instructions,
    };

_OrderTotals _$OrderTotalsFromJson(Map<String, dynamic> json) => _OrderTotals(
  taxTotal: (json['taxTotal'] as num?)?.toDouble() ?? 0,
  deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0,
  subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0,
  total: (json['total'] as num?)?.toDouble() ?? 0,
  tip: (json['tip'] as num?)?.toDouble() ?? 0,
  specialInstructions: json['specialInstructions'] as String?,
);

Map<String, dynamic> _$OrderTotalsToJson(_OrderTotals instance) =>
    <String, dynamic>{
      'taxTotal': instance.taxTotal,
      'deliveryCharge': instance.deliveryCharge,
      'subTotal': instance.subTotal,
      'total': instance.total,
      'tip': instance.tip,
      'specialInstructions': instance.specialInstructions,
    };
