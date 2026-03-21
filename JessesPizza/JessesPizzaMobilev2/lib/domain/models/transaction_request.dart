import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

part 'transaction_request.freezed.dart';
part 'transaction_request.g.dart';

/// Matches V1's LocalTransactionV1_1 payload sent to ValidateTransaction
/// and GetHPPToken endpoints.
@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required CustomerInfo info,
    required List<TransactionItem> transactionItems,
    required OrderTotals totals,
    required bool isDelivery,
    @Default(false) bool noContactDelivery,
    String? specialInstructions,
    String? transactionId,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);

  /// Builds a [TransactionRequest] from cart state and customer details.
  static TransactionRequest fromCartState({
    required List<CartItem> items,
    required CustomerInfo customerInfo,
    required OrderTotals totals,
    required bool isDelivery,
    bool noContactDelivery = false,
    String? specialInstructions,
  }) {
    return TransactionRequest(
      info: customerInfo,
      transactionItems: items.map((i) => TransactionItem.fromCartItem(i)).toList(),
      totals: totals,
      isDelivery: isDelivery,
      noContactDelivery: noContactDelivery,
      specialInstructions: specialInstructions,
    );
  }
}

/// Wraps a [TransactionRequest] with a credit card for the PostTransaction
/// endpoint. Matches V1's PostTransactionRequestV1_1.
@freezed
abstract class PostTransactionRequest with _$PostTransactionRequest {
  const factory PostTransactionRequest({
    required TransactionRequest transaction,
    required CreditCardRef card,
  }) = _PostTransactionRequest;

  factory PostTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$PostTransactionRequestFromJson(json);
}

/// Minimal credit card reference for submitting with a transaction.
@freezed
abstract class CreditCardRef with _$CreditCardRef {
  const factory CreditCardRef({
    required String id,
    String? cardNumber,
    String? expirationDate,
    String? shortDescription,
  }) = _CreditCardRef;

  factory CreditCardRef.fromJson(Map<String, dynamic> json) =>
      _$CreditCardRefFromJson(json);
}

/// Customer info matching V1's CustomerInfoApp.
@freezed
abstract class CustomerInfo with _$CustomerInfo {
  const factory CustomerInfo({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String emailAddress,
    String? addressLine1,
    String? city,
    String? zipCode,
  }) = _CustomerInfo;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}

/// Item in a transaction, matching V1's ShoppingCartItem.
@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String menuItemId,
    required String name,
    String? description,
    required String sizeName,
    String? selectedSizeId,
    String? imageUrl,
    @Default(false) bool requiredChoicesEnabled,
    String? requiredChoices,
    String? requiredDelimitedString,
    @Default(false) bool optionalChoicesEnabled,
    String? optionalChoices,
    String? optionalDelimitedString,
    required int quantity,
    required double price,
    @Default(false) bool instructionsEnabled,
    String? instructions,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  /// Converts a [CartItem] into a [TransactionItem] for the API payload.
  static TransactionItem fromCartItem(CartItem item) {
    return TransactionItem(
      menuItemId: item.menuItemId,
      name: item.name,
      description: item.description,
      sizeName: item.sizeName,
      selectedSizeId: item.selectedSizeId,
      imageUrl: item.imageUrl,
      requiredChoicesEnabled: item.requiredChoicesEnabled,
      requiredChoices: item.requiredChoices,
      requiredDelimitedString: item.requiredDelimitedString,
      optionalChoicesEnabled: item.optionalChoicesEnabled,
      optionalChoices: item.optionalChoices,
      optionalDelimitedString: item.optionalDelimitedString,
      quantity: item.quantity,
      price: item.price,
      instructionsEnabled: item.instructionsEnabled,
      instructions: item.instructions,
    );
  }
}

/// Order totals matching V1's OrderTotals.
@freezed
abstract class OrderTotals with _$OrderTotals {
  const factory OrderTotals({
    @Default(0) double taxTotal,
    @Default(0) double deliveryCharge,
    @Default(0) double subTotal,
    @Default(0) double total,
    @Default(0) double tip,
    String? specialInstructions,
  }) = _OrderTotals;

  factory OrderTotals.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsFromJson(json);
}
