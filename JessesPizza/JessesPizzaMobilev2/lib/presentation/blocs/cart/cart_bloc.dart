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
    on<SetTip>(_onSetTip);
    on<UpdateSettings>(_onUpdateSettings);
    on<UpdateItem>(_onUpdateItem);
    on<ValidateCart>(_onValidateCart);
    on<ClearCart>(_onClearCart);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    // Each item is added as a distinct entry (group selections may differ).
    emit(state.copyWith(items: [...state.items, event.item]));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    if (event.index != null) {
      final updated = List<CartItem>.from(state.items);
      if (event.index! >= 0 && event.index! < updated.length) {
        updated.removeAt(event.index!);
      }
      emit(state.copyWith(items: updated));
    } else {
      emit(state.copyWith(
        items: state.items
            .where((i) =>
                !(i.menuItemId == event.menuItemId &&
                    i.sizeName == event.sizeName))
            .toList(),
      ));
    }
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (event.index != null) {
      final updated = List<CartItem>.from(state.items);
      if (event.index! >= 0 && event.index! < updated.length) {
        updated[event.index!] =
            updated[event.index!].copyWith(quantity: event.quantity);
      }
      emit(state.copyWith(items: updated));
    } else {
      final updated = state.items.map((i) {
        if (i.menuItemId == event.menuItemId && i.sizeName == event.sizeName) {
          return i.copyWith(quantity: event.quantity);
        }
        return i;
      }).toList();
      emit(state.copyWith(items: updated));
    }
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

  void _onSetTip(SetTip event, Emitter<CartState> emit) {
    emit(state.copyWith(tip: event.amount));
  }

  void _onUpdateSettings(UpdateSettings event, Emitter<CartState> emit) {
    emit(state.copyWith(
      taxRate: event.settings.taxRate,
      deliveryCharge: event.settings.deliveryCharge,
      minimumOrderAmount: event.settings.minimumOrderAmount,
      settingsLoaded: true,
    ));
  }

  void _onUpdateItem(UpdateItem event, Emitter<CartState> emit) {
    final updated = List<CartItem>.from(state.items);
    if (event.index >= 0 && event.index < updated.length) {
      updated[event.index] = event.item;
    }
    emit(state.copyWith(items: updated));
  }

  void _onValidateCart(ValidateCart event, Emitter<CartState> emit) {
    final validIds = event.validMenuItemIds;
    final validItems =
        state.items.where((i) => validIds.contains(i.menuItemId)).toList();
    if (validItems.length != state.items.length) {
      emit(state.copyWith(items: validItems));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
