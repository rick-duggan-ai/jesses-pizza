import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/guest_info.dart';
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
  final int? index;
  const RemoveItem(this.menuItemId, this.sizeName, {this.index});
  @override
  List<Object?> get props => [menuItemId, sizeName, index];
}

class UpdateQuantity extends CartEvent {
  final String menuItemId;
  final String sizeName;
  final int quantity;
  final int? index;
  const UpdateQuantity(this.menuItemId, this.sizeName, this.quantity,
      {this.index});
  @override
  List<Object?> get props => [menuItemId, sizeName, quantity, index];
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

class SetGuestInfo extends CartEvent {
  final GuestInfo guestInfo;
  const SetGuestInfo(this.guestInfo);
  @override
  List<Object?> get props => [guestInfo];
}

class SetTip extends CartEvent {
  final double amount;
  const SetTip(this.amount);
  @override
  List<Object?> get props => [amount];
}

class UpdateSettings extends CartEvent {
  final StoreSettings settings;
  const UpdateSettings(this.settings);
  @override
  List<Object?> get props => [settings];
}

class UpdateItem extends CartEvent {
  final int index;
  final CartItem item;
  const UpdateItem({required this.index, required this.item});
  @override
  List<Object?> get props => [index, item];
}

class ValidateCart extends CartEvent {
  final Set<String> validMenuItemIds;
  const ValidateCart(this.validMenuItemIds);
  @override
  List<Object?> get props => [validMenuItemIds];
}

class ClearCart extends CartEvent {
  const ClearCart();
  @override
  List<Object?> get props => [];
}
