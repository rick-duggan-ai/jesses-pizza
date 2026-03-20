import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';

void main() {
  const tItem = CartItem(
    menuItemId: 'item-1',
    name: 'Pepperoni Pizza',
    sizeName: 'Large',
    price: 14.99,
    quantity: 1,
  );

  group('CartBloc', () {
    test('initial state is empty CartState with default settings', () {
      final bloc = CartBloc();
      expect(bloc.state, const CartState());
      expect(bloc.state.subtotal, 0.0);
      expect(bloc.state.taxRate, 8.0);
      expect(bloc.state.deliveryCharge, 3.99);
      expect(bloc.state.tip, 0.0);
      bloc.close();
    });

    blocTest<CartBloc, CartState>(
      'AddItem adds new item to cart',
      build: () => CartBloc(),
      act: (bloc) => bloc.add(AddItem(tItem)),
      expect: () => [
        CartState(items: [tItem]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'AddItem increments quantity for existing item with same menuItemId+sizeName',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(AddItem(tItem));
        bloc.add(AddItem(tItem));
      },
      expect: () => [
        CartState(items: [tItem]),
        CartState(items: [tItem.copyWith(quantity: 2)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'RemoveItem removes item by menuItemId',
      build: () => CartBloc(),
      seed: () => CartState(items: [tItem]),
      act: (bloc) => bloc.add(const RemoveItem('item-1', 'Large')),
      expect: () => [const CartState(items: [])],
    );

    blocTest<CartBloc, CartState>(
      'UpdateQuantity updates item quantity',
      build: () => CartBloc(),
      seed: () => CartState(items: [tItem]),
      act: (bloc) => bloc.add(const UpdateQuantity('item-1', 'Large', 3)),
      expect: () => [
        CartState(items: [tItem.copyWith(quantity: 3)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'ClearCart resets state to empty',
      build: () => CartBloc(),
      seed: () => CartState(items: [tItem]),
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [const CartState()],
    );

    blocTest<CartBloc, CartState>(
      'UpdateSettings updates taxRate and deliveryCharge',
      build: () => CartBloc(),
      act: (bloc) => bloc.add(
        const UpdateSettings(StoreSettings(taxRate: 9.5, deliveryCharge: 4.99)),
      ),
      expect: () => [
        const CartState(taxRate: 9.5, deliveryCharge: 4.99),
      ],
    );

    blocTest<CartBloc, CartState>(
      'SetTip updates tip amount',
      build: () => CartBloc(),
      act: (bloc) => bloc.add(const SetTip(5.00)),
      expect: () => [
        const CartState(tip: 5.00),
      ],
    );
  });

  group('CartState computed totals', () {
    test('subtotal calculates correctly', () {
      const item2 = CartItem(
        menuItemId: 'item-2',
        name: 'Soda',
        sizeName: 'Medium',
        price: 2.50,
        quantity: 2,
      );
      final state = CartState(items: [tItem, item2]);
      // 14.99 * 1 + 2.50 * 2 = 14.99 + 5.00 = 19.99
      expect(state.subtotal, closeTo(19.99, 0.01));
    });

    test('taxAmount applies taxRate to subtotal', () {
      final state = CartState(items: [tItem], taxRate: 10.0);
      // 14.99 * 10% = 1.499
      expect(state.taxAmount, closeTo(1.499, 0.001));
    });

    test('deliveryAmount is 0 when not delivery', () {
      final state = CartState(items: [tItem], isDelivery: false);
      expect(state.deliveryAmount, 0.0);
    });

    test('deliveryAmount equals deliveryCharge when delivery', () {
      const state = CartState(isDelivery: true, deliveryCharge: 4.50);
      expect(state.deliveryAmount, 4.50);
    });

    test('total includes subtotal + tax + delivery + tip', () {
      final state = CartState(
        items: [tItem],
        isDelivery: true,
        taxRate: 10.0,
        deliveryCharge: 5.00,
        tip: 3.00,
      );
      // subtotal = 14.99
      // tax = 14.99 * 0.10 = 1.499
      // delivery = 5.00
      // tip = 3.00
      // total = 14.99 + 1.499 + 5.00 + 3.00 = 24.489
      expect(state.total, closeTo(24.489, 0.001));
    });

    test('total excludes delivery when not delivery mode', () {
      final state = CartState(
        items: [tItem],
        isDelivery: false,
        taxRate: 8.0,
        deliveryCharge: 3.99,
        tip: 2.00,
      );
      // subtotal = 14.99
      // tax = 14.99 * 0.08 = 1.1992
      // delivery = 0
      // tip = 2.00
      // total = 14.99 + 1.1992 + 0 + 2.00 = 18.1892
      expect(state.total, closeTo(18.1892, 0.001));
    });
  });
}
