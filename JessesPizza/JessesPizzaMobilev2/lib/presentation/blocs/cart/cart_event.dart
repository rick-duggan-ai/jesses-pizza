import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';

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
  final String sizeName;
  const RemoveItem(this.menuItemId, this.sizeName);
  @override
  List<Object?> get props => [menuItemId, sizeName];
}

class UpdateQuantity extends CartEvent {
  final String menuItemId;
  final String sizeName;
  final int quantity;
  const UpdateQuantity(this.menuItemId, this.sizeName, this.quantity);
  @override
  List<Object?> get props => [menuItemId, sizeName, quantity];
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

class UpdateSettings extends CartEvent {
  final StoreSettings settings;
  const UpdateSettings(this.settings);
  @override
  List<Object?> get props => [settings];
}

class SetTip extends CartEvent {
  final double tip;
  const SetTip(this.tip);
  @override
  List<Object?> get props => [tip];
}
