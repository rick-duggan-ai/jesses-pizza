import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SetDeliveryMode>(_onSetDeliveryMode);
    on<SetAddress>(_onSetAddress);
    on<SetGuestInfo>(_onSetGuestInfo);
    on<ClearCart>(_onClearCart);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    final existing = state.items.indexWhere(
      (i) =>
          i.menuItemId == event.item.menuItemId &&
          i.sizeName == event.item.sizeName,
    );
    if (existing >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existing] =
          updated[existing].copyWith(quantity: updated[existing].quantity + event.item.quantity);
      emit(state.copyWith(items: updated));
    } else {
      emit(state.copyWith(items: [...state.items, event.item]));
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    emit(state.copyWith(
      items: state.items
          .where((i) => !(i.menuItemId == event.menuItemId && i.sizeName == event.sizeName))
          .toList(),
    ));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updated = state.items.map((i) {
      if (i.menuItemId == event.menuItemId && i.sizeName == event.sizeName) {
        return i.copyWith(quantity: event.quantity);
      }
      return i;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onSetDeliveryMode(SetDeliveryMode event, Emitter<CartState> emit) {
    if (!event.isDelivery) {
      emit(state.withAddressCleared().copyWith(isDelivery: false));
    } else {
      emit(state.copyWith(isDelivery: true));
    }
  }

  void _onSetAddress(SetAddress event, Emitter<CartState> emit) {
    emit(state.copyWith(address: event.address));
  }

  void _onSetGuestInfo(SetGuestInfo event, Emitter<CartState> emit) {
    emit(state.copyWith(guestInfo: event.guestInfo));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
