import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final double taxRate;
  final double deliveryCharge;
  final double tip;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.taxRate = 8.0,
    this.deliveryCharge = 3.99,
    this.tip = 0.0,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get taxAmount => subtotal * (taxRate / 100);

  double get deliveryAmount => isDelivery ? deliveryCharge : 0.0;

  double get total => subtotal + taxAmount + deliveryAmount + tip;

  /// Whether store settings have been loaded from the API.
  bool get settingsLoaded => taxRate != StoreSettings.defaults.taxRate ||
      deliveryCharge != StoreSettings.defaults.deliveryCharge;

  static const _clearAddress = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    double? taxRate,
    double? deliveryCharge,
    double? tip,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress) ? this.address : address as Address?,
      taxRate: taxRate ?? this.taxRate,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      tip: tip ?? this.tip,
    );
  }

  CartState withAddressCleared() {
    return CartState(
      items: items,
      isDelivery: isDelivery,
      address: null,
      taxRate: taxRate,
      deliveryCharge: deliveryCharge,
      tip: tip,
    );
  }

  @override
  List<Object?> get props => [items, isDelivery, address, taxRate, deliveryCharge, tip];
}
