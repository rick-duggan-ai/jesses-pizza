import 'package:equatable/equatable.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/guest_info.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isDelivery;
  final Address? address;
  final GuestInfo? guestInfo;
  final double tipAmount;
  final double taxRate;
  final double deliveryCharge;
  final double minimumOrderAmount;
  final bool settingsLoaded;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.address,
    this.guestInfo,
    this.tipAmount = 0.0,
    this.taxRate = 0.0,
    this.deliveryCharge = 0.0,
    this.minimumOrderAmount = 0.0,
    this.settingsLoaded = false,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get total => subtotal + tipAmount;

  static const _clearAddress = Object();
  static const _keepGuestInfo = Object();

  CartState copyWith({
    List<CartItem>? items,
    bool? isDelivery,
    Object? address = _clearAddress,
    Object? guestInfo = _keepGuestInfo,
    double? tipAmount,
    double? taxRate,
    double? deliveryCharge,
    double? minimumOrderAmount,
    bool? settingsLoaded,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      address: identical(address, _clearAddress)
          ? this.address
          : address as Address?,
      guestInfo: identical(guestInfo, _keepGuestInfo)
          ? this.guestInfo
          : guestInfo as GuestInfo?,
      tipAmount: tipAmount ?? this.tipAmount,
      taxRate: taxRate ?? this.taxRate,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      settingsLoaded: settingsLoaded ?? this.settingsLoaded,
    );
  }

  CartState withAddressCleared() {
    return CartState(
      items: items,
      isDelivery: isDelivery,
      address: null,
      guestInfo: guestInfo,
      tipAmount: tipAmount,
      taxRate: taxRate,
      deliveryCharge: deliveryCharge,
      minimumOrderAmount: minimumOrderAmount,
      settingsLoaded: settingsLoaded,
    );
  }

  @override
  List<Object?> get props => [
        items,
        isDelivery,
        address,
        guestInfo,
        tipAmount,
        taxRate,
        deliveryCharge,
        minimumOrderAmount,
        settingsLoaded,
      ];
}
