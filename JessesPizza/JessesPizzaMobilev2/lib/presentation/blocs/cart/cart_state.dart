import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/guest_info.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final GuestInfo? guestInfo;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.guestInfo,
  });

  double get total => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  static const _clearAddress = Object();
  static const _clearGuestInfo = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    Object? guestInfo = _clearGuestInfo,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress) ? this.address : address as Address?,
      guestInfo: identical(guestInfo, _clearGuestInfo) ? this.guestInfo : guestInfo as GuestInfo?,
    );
  }

  CartState withAddressCleared() {
    return CartState(
      items: items,
      isDelivery: isDelivery,
      address: null,
      guestInfo: guestInfo,
    );
  }

  @override
  List<Object?> get props => [items, isDelivery, address, guestInfo];
}
