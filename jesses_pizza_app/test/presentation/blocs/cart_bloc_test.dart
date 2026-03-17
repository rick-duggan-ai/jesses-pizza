import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
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
    test('initial state is empty CartState', () {
      final bloc = CartBloc();
      expect(bloc.state, const CartState());
      expect(bloc.state.total, 0.0);
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
      act: (bloc) => bloc.add(const RemoveItem('item-1')),
      expect: () => [const CartState(items: [])],
    );

    blocTest<CartBloc, CartState>(
      'UpdateQuantity updates item quantity',
      build: () => CartBloc(),
      seed: () => CartState(items: [tItem]),
      act: (bloc) => bloc.add(const UpdateQuantity('item-1', 3)),
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

    test('total getter calculates correctly', () {
      const item2 = CartItem(
        menuItemId: 'item-2',
        name: 'Soda',
        sizeName: 'Medium',
        price: 2.50,
        quantity: 2,
      );
      final state = CartState(items: [tItem, item2]);
      // 14.99 * 1 + 2.50 * 2 = 14.99 + 5.00 = 19.99
      expect(state.total, closeTo(19.99, 0.01));
    });
  });
}
