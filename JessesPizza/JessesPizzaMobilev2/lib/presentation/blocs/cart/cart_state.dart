import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final double taxRate;
  final double deliveryCharge;
  final double minimumOrderAmount;
  final double tip;
  final bool settingsLoaded;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.taxRate = 8.0,
    this.deliveryCharge = 3.99,
    this.minimumOrderAmount = 0.0,
    this.tip = 0.0,
    this.settingsLoaded = false,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);
  double get taxAmount => subtotal * (taxRate / 100);
  double get deliveryAmount => isDelivery ? deliveryCharge : 0.0;
  double get total => subtotal + taxAmount + deliveryAmount + tip;

  static const _clearAddress = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    double? taxRate,
    double? deliveryCharge,
    double? minimumOrderAmount,
    double? tip,
    bool? settingsLoaded,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress) ? this.address : address as Address?,
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
      taxRate: taxRate,
      deliveryCharge: deliveryCharge,
      minimumOrderAmount: minimumOrderAmount,
      tip: tip,
      settingsLoaded: settingsLoaded,
    );
  }

  @override
  List<Object?> get props => [items, isDelivery, address, taxRate, deliveryCharge, minimumOrderAmount, tip, settingsLoaded];
}
