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

  const TransactionRequest({
    required this.info,
    required this.transactionItems,
    required this.totals,
    required this.isDelivery,
    this.noContactDelivery = false,
    this.specialInstructions = '',
  });

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
        'transactionItems': transactionItems.map((i) => i.toJson()).toList(),
        'totals': totals.toJson(),
        'isDelivery': isDelivery,
        'noContactDelivery': noContactDelivery,
        'specialInstructions': specialInstructions,
      };

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
      transactionItems: items
          .map((item) => TransactionItem(
                menuItemId: item.menuItemId,
                name: item.name,
                sizeName: item.sizeName,
                quantity: item.quantity,
                price: item.price,
              ))
          .toList(),
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
}

/// Mirrors C# OrderTotals fields.
class OrderTotals {
  final double subTotal;
  final double taxTotal;
  final double deliveryCharge;
  final double tip;
  final double total;

  const OrderTotals({
    this.subTotal = 0.0,
    this.taxTotal = 0.0,
    this.deliveryCharge = 0.0,
    this.tip = 0.0,
    this.total = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'subTotal': subTotal,
        'taxTotal': taxTotal,
        'deliveryCharge': deliveryCharge,
        'tip': tip,
        'total': total,
      };
}

/// Mirrors C# ShoppingCartItem fields used in the transaction payload.
class TransactionItem {
  final String menuItemId;
  final String name;
  final String sizeName;
  final int quantity;
  final double price;

  const TransactionItem({
    required this.menuItemId,
    required this.name,
    required this.sizeName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'name': name,
        'sizeName': sizeName,
        'quantity': quantity,
        'price': price,
      };
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
