import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/guest_info.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final GuestInfo? guestInfo;
  final double taxRate;
  final double deliveryCharge;
  final double minimumOrderAmount;
  final double tip;
  final bool settingsLoaded;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.guestInfo,
    this.taxRate = 8.0,
    this.deliveryCharge = 3.99,
    this.minimumOrderAmount = 0.0,
    this.tip = 0.0,
    this.settingsLoaded = false,
  });

  /// Alias used by tip tests.
  double get tipAmount => tip;

  /// Whether delivery is disabled because the delivery charge is >= $99.
  bool get isDeliveryDisabled => deliveryCharge >= 99.0;

  /// Whether the cart subtotal meets the minimum order amount for delivery.
  bool get meetsDeliveryMinimum =>
      minimumOrderAmount <= 0 || subtotal >= minimumOrderAmount;

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get taxAmount => subtotal * (taxRate / 100.0);

  double get deliveryAmount => isDelivery ? deliveryCharge : 0.0;

  double get total => subtotal + taxAmount + deliveryAmount + tip;

  static const _clearAddress = Object();
  static const _clearGuestInfo = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    Object? guestInfo = _clearGuestInfo,
    double? taxRate,
    double? deliveryCharge,
    double? minimumOrderAmount,
    double? tip,
    bool? settingsLoaded,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress)
          ? this.address
          : address as Address?,
      guestInfo: identical(guestInfo, _clearGuestInfo)
          ? this.guestInfo
          : guestInfo as GuestInfo?,
      taxRate: taxRate ?? this.taxRate,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      tip: tip ?? this.tip,
      settingsLoaded: settingsLoaded ?? this.settingsLoaded,
    );
  }

  CartState withAddressCleared() {
    return CartState(
      items: items,
      isDelivery: isDelivery,
      address: null,
      guestInfo: guestInfo,
      taxRate: taxRate,
      deliveryCharge: deliveryCharge,
      minimumOrderAmount: minimumOrderAmount,
      tip: tip,
      settingsLoaded: settingsLoaded,
    );
  }

  @override
  List<Object?> get props => [
        items,
        isDelivery,
        address,
        guestInfo,
        taxRate,
        deliveryCharge,
        minimumOrderAmount,
        tip,
        settingsLoaded,
      ];
}
