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
    on<ClearCart>(_onClearCart);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    emit(state.copyWith(items: [...state.items, event.item]));
  }
  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    final updated = List<CartItem>.from(state.items);
    if (event.index != null && event.index! < updated.length) {
      updated.removeAt(event.index!);
    } else {
      final idx = updated.indexWhere((i) => i.menuItemId == event.menuItemId && i.sizeName == event.sizeName);
      if (idx >= 0) updated.removeAt(idx);
    }
    emit(state.copyWith(items: updated));
  }
  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updated = List<CartItem>.from(state.items);
    if (event.index != null && event.index! < updated.length) {
      updated[event.index!] = updated[event.index!].copyWith(quantity: event.quantity);
    } else {
      final idx = updated.indexWhere((i) => i.menuItemId == event.menuItemId && i.sizeName == event.sizeName);
      if (idx >= 0) updated[idx] = updated[idx].copyWith(quantity: event.quantity);
    }
    emit(state.copyWith(items: updated));
  }
  void _onSetDeliveryMode(SetDeliveryMode event, Emitter<CartState> emit) {
    if (!event.isDelivery) { emit(state.withAddressCleared().copyWith(isDelivery: false)); }
    else { emit(state.copyWith(isDelivery: true)); }
  }
  void _onSetAddress(SetAddress event, Emitter<CartState> emit) { emit(state.copyWith(address: event.address)); }
  void _onClearCart(ClearCart event, Emitter<CartState> emit) { emit(const CartState()); }
}
