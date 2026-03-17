import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
  });

  double get total => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Address? address,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [items, isDelivery, address];
}
