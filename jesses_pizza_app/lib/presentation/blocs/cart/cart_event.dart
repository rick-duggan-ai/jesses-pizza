import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddItem extends CartEvent {
  final CartItem item;
  const AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final String menuItemId;
  const RemoveItem(this.menuItemId);
  @override
  List<Object?> get props => [menuItemId];
}

class UpdateQuantity extends CartEvent {
  final String menuItemId;
  final int quantity;
  const UpdateQuantity(this.menuItemId, this.quantity);
  @override
  List<Object?> get props => [menuItemId, quantity];
}

class SetDeliveryMode extends CartEvent {
  final bool isDelivery;
  const SetDeliveryMode(this.isDelivery);
  @override
  List<Object?> get props => [isDelivery];
}

class SetAddress extends CartEvent {
  final Address address;
  const SetAddress(this.address);
  @override
  List<Object?> get props => [address];
}

class ClearCart extends CartEvent {
  const ClearCart();
  @override
  List<Object?> get props => [];
}
