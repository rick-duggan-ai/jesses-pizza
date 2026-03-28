import 'package:jesses_pizza_app/domain/models/cart_item.dart';

/// Mirrors C# PostTransactionRequestV1_1:
///   { "transaction": LocalTransactionV1_1, "card": CreditCard }
class PostTransactionRequest {
  final TransactionRequest transaction;
  final CreditCardRef card;

  const PostTransactionRequest({
    required this.transaction,
    required this.card,
  });

  Map<String, dynamic> toJson() => {
        'transaction': transaction.toJson(),
        'card': card.toJson(),
      };
}

/// Mirrors C# LocalTransactionV1_1:
///   { "info": CustomerInfoApp, "transactionItems": [...],
///     "totals": OrderTotals, "isDelivery": bool,
///     "noContactDelivery": bool, "specialInstructions": string }
class TransactionRequest {
  final CustomerInfo info;
  final List<TransactionItem> transactionItems;
  final OrderTotals totals;
  final bool isDelivery;
  final bool noContactDelivery;
  final String specialInstructions;
  final String? transactionId;

  const TransactionRequest({
    required this.info,
    required this.transactionItems,
    required this.totals,
    required this.isDelivery,
    this.noContactDelivery = false,
    this.specialInstructions = '',
    this.transactionId,
  });

  TransactionRequest copyWith({
    CustomerInfo? info,
    List<TransactionItem>? transactionItems,
    OrderTotals? totals,
    bool? isDelivery,
    bool? noContactDelivery,
    String? specialInstructions,
    String? transactionId,
  }) {
    return TransactionRequest(
      info: info ?? this.info,
      transactionItems: transactionItems ?? this.transactionItems,
      totals: totals ?? this.totals,
      isDelivery: isDelivery ?? this.isDelivery,
      noContactDelivery: noContactDelivery ?? this.noContactDelivery,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
        'transactionItems':
            transactionItems.map((i) => i.toJson()).toList(),
        'totals': totals.toJson(),
        'isDelivery': isDelivery,
        'noContactDelivery': noContactDelivery,
        'specialInstructions': specialInstructions,
        if (transactionId != null) 'transactionId': transactionId,
      };

  factory TransactionRequest.fromJson(Map<String, dynamic> json) {
    return TransactionRequest(
      info: CustomerInfo.fromJson(json['info'] as Map<String, dynamic>),
      transactionItems: (json['transactionItems'] as List)
          .map((i) => TransactionItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      totals: OrderTotals.fromJson(json['totals'] as Map<String, dynamic>),
      isDelivery: json['isDelivery'] as bool,
      noContactDelivery: json['noContactDelivery'] as bool? ?? false,
      specialInstructions: json['specialInstructions'] as String? ?? '',
      transactionId: json['transactionId'] as String?,
    );
  }

  /// Convenience factory to build from CartState data.
  factory TransactionRequest.fromCartState({
    required List<CartItem> items,
    required CustomerInfo customerInfo,
    required OrderTotals totals,
    required bool isDelivery,
    bool noContactDelivery = false,
    String specialInstructions = '',
  }) {
    return TransactionRequest(
      info: customerInfo,
      transactionItems:
          items.map((item) => TransactionItem.fromCartItem(item)).toList(),
      totals: totals,
      isDelivery: isDelivery,
      noContactDelivery: noContactDelivery,
      specialInstructions: specialInstructions,
    );
  }
}

/// Mirrors C# CustomerInfoApp fields.
class CustomerInfo {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? emailAddress;
  final String? addressLine1;
  final String? city;
  final String? zipCode;

  const CustomerInfo({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailAddress,
    this.addressLine1,
    this.city,
    this.zipCode,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'phoneNumber': phoneNumber ?? '',
        'emailAddress': emailAddress ?? '',
        'addressLine1': addressLine1 ?? '',
        'city': city ?? '',
        'zipCode': zipCode ?? '',
      };

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      emailAddress: json['emailAddress'] as String?,
      addressLine1: json['addressLine1'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
    );
  }
}

/// Mirrors C# OrderTotals fields.
class OrderTotals {
  final double subTotal;
  final double taxTotal;
  final double deliveryCharge;
  final double tip;
  final double total;
  final String? specialInstructions;

  const OrderTotals({
    this.subTotal = 0.0,
    this.taxTotal = 0.0,
    this.deliveryCharge = 0.0,
    this.tip = 0.0,
    this.total = 0.0,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() => {
        'subTotal': subTotal,
        'taxTotal': taxTotal,
        'deliveryCharge': deliveryCharge,
        'tip': tip,
        'total': total,
        if (specialInstructions != null)
          'specialInstructions': specialInstructions,
      };

  factory OrderTotals.fromJson(Map<String, dynamic> json) {
    return OrderTotals(
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      taxTotal: (json['taxTotal'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
      tip: (json['tip'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      specialInstructions: json['specialInstructions'] as String?,
    );
  }
}

/// Mirrors C# ShoppingCartItem fields used in the transaction payload.
class TransactionItem {
  final String menuItemId;
  final String name;
  final String? description;
  final String sizeName;
  final String? selectedSizeId;
  final String? imageUrl;
  final bool requiredChoicesEnabled;
  final String? requiredChoices;
  final String? requiredDelimitedString;
  final bool optionalChoicesEnabled;
  final String? optionalChoices;
  final String? optionalDelimitedString;
  final int quantity;
  final double price;
  final bool instructionsEnabled;
  final String? instructions;

  const TransactionItem({
    required this.menuItemId,
    required this.name,
    this.description,
    required this.sizeName,
    this.selectedSizeId,
    this.imageUrl,
    this.requiredChoicesEnabled = false,
    this.requiredChoices,
    this.requiredDelimitedString,
    this.optionalChoicesEnabled = false,
    this.optionalChoices,
    this.optionalDelimitedString,
    required this.quantity,
    required this.price,
    this.instructionsEnabled = false,
    this.instructions,
  });

  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'name': name,
        if (description != null) 'description': description,
        'sizeName': sizeName,
        if (selectedSizeId != null) 'selectedSizeId': selectedSizeId,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'requiredChoicesEnabled': requiredChoicesEnabled,
        if (requiredChoices != null) 'requiredChoices': requiredChoices,
        if (requiredDelimitedString != null)
          'requiredDelimitedString': requiredDelimitedString,
        'optionalChoicesEnabled': optionalChoicesEnabled,
        if (optionalChoices != null) 'optionalChoices': optionalChoices,
        if (optionalDelimitedString != null)
          'optionalDelimitedString': optionalDelimitedString,
        'quantity': quantity,
        'price': price,
        'instructionsEnabled': instructionsEnabled,
        if (instructions != null) 'instructions': instructions,
      };

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      sizeName: json['sizeName'] as String,
      selectedSizeId: json['selectedSizeId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      requiredChoicesEnabled:
          json['requiredChoicesEnabled'] as bool? ?? false,
      requiredChoices: json['requiredChoices'] as String?,
      requiredDelimitedString: json['requiredDelimitedString'] as String?,
      optionalChoicesEnabled:
          json['optionalChoicesEnabled'] as bool? ?? false,
      optionalChoices: json['optionalChoices'] as String?,
      optionalDelimitedString: json['optionalDelimitedString'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      instructionsEnabled: json['instructionsEnabled'] as bool? ?? false,
      instructions: json['instructions'] as String?,
    );
  }

  /// Build a TransactionItem from a CartItem.
  factory TransactionItem.fromCartItem(CartItem cartItem) {
    return TransactionItem(
      menuItemId: cartItem.menuItemId,
      name: cartItem.name,
      description: cartItem.description,
      sizeName: cartItem.sizeName,
      selectedSizeId: cartItem.selectedSizeId,
      imageUrl: cartItem.imageUrl,
      requiredChoicesEnabled: cartItem.requiredChoicesEnabled,
      requiredChoices: cartItem.requiredChoices,
      requiredDelimitedString: cartItem.requiredDelimitedString,
      optionalChoicesEnabled: cartItem.optionalChoicesEnabled,
      optionalChoices: cartItem.optionalChoices,
      optionalDelimitedString: cartItem.optionalDelimitedString,
      quantity: cartItem.quantity,
      price: cartItem.price,
      instructionsEnabled: cartItem.instructionsEnabled,
      instructions: cartItem.instructions,
    );
  }
}

/// Reference to a saved credit card for the PostTransactionRequest.
class CreditCardRef {
  final String id;
  final String? cardNumber;
  final String? expirationDate;

  const CreditCardRef({
    required this.id,
    this.cardNumber,
    this.expirationDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        if (cardNumber != null) 'cardNumber': cardNumber,
        if (expirationDate != null) 'expirationDate': expirationDate,
      };
}
