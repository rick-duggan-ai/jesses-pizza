import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final double tipAmount;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.tipAmount = 0.0,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get total => subtotal + tipAmount;

  static const _clearAddress = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    double? tipAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress) ? this.address : address as Address?,
      tipAmount: tipAmount ?? this.tipAmount,
    );
  }

  CartState withAddressCleared() {
    return CartState(
      items: items,
      isDelivery: isDelivery,
      address: null,
      tipAmount: tipAmount,
    );
  }

  @override
  List<Object?> get props => [items, isDelivery, address, tipAmount];
}
