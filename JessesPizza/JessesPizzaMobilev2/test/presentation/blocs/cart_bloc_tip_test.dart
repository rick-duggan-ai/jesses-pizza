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
    price: 20.00,
    quantity: 1,
  );

  group('CartBloc tip management', () {
    test('initial tipAmount is 0.0', () {
      final bloc = CartBloc();
      expect(bloc.state.tipAmount, 0.0);
      bloc.close();
    });

    blocTest<CartBloc, CartState>(
      'SetTip updates tipAmount in state',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(const AddItem(tItem));
        bloc.add(const SetTip(4.00));
      },
      verify: (bloc) {
        expect(bloc.state.tipAmount, 4.00);
        expect(bloc.state.items.length, 1);
        expect(bloc.state.subtotal, 20.00);
        expect(bloc.state.total, 24.00);
      },
    );

    blocTest<CartBloc, CartState>(
      'SetTip with 0 removes tip',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(const AddItem(tItem));
        bloc.add(const SetTip(5.00));
        bloc.add(const SetTip(0.0));
      },
      verify: (bloc) {
        expect(bloc.state.tipAmount, 0.0);
        expect(bloc.state.total, 20.00);
      },
    );

    blocTest<CartBloc, CartState>(
      'SetTip overwrites previous tip',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(const AddItem(tItem));
        bloc.add(const SetTip(3.00));
        bloc.add(const SetTip(7.50));
      },
      verify: (bloc) {
        expect(bloc.state.tipAmount, 7.50);
        expect(bloc.state.total, 27.50);
      },
    );

    blocTest<CartBloc, CartState>(
      'ClearCart resets tipAmount to 0',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(const AddItem(tItem));
        bloc.add(const SetTip(4.00));
        bloc.add(const ClearCart());
      },
      verify: (bloc) {
        expect(bloc.state.tipAmount, 0.0);
        expect(bloc.state.items, isEmpty);
        expect(bloc.state.total, 0.0);
      },
    );

    blocTest<CartBloc, CartState>(
      'SetTip emits new state each time',
      build: () => CartBloc(),
      act: (bloc) {
        bloc.add(const SetTip(5.00));
        bloc.add(const SetTip(10.00));
      },
      expect: () => [
        isA<CartState>().having((s) => s.tipAmount, 'tipAmount', 5.00),
        isA<CartState>().having((s) => s.tipAmount, 'tipAmount', 10.00),
      ],
    );
  });

  group('Tip calculation logic', () {
    test('20% tip on subtotal', () {
      const subtotal = 25.00;
      final tip = double.parse((subtotal * 0.20).toStringAsFixed(2));
      expect(tip, 5.00);
    });

    test('22% tip on subtotal', () {
      const subtotal = 25.00;
      final tip = double.parse((subtotal * 0.22).toStringAsFixed(2));
      expect(tip, 5.50);
    });

    test('25% tip on subtotal', () {
      const subtotal = 25.00;
      final tip = double.parse((subtotal * 0.25).toStringAsFixed(2));
      expect(tip, 6.25);
    });

    test('tip calculation rounds to 2 decimal places', () {
      const subtotal = 33.33;
      final tip20 = double.parse((subtotal * 0.20).toStringAsFixed(2));
      final tip22 = double.parse((subtotal * 0.22).toStringAsFixed(2));
      final tip25 = double.parse((subtotal * 0.25).toStringAsFixed(2));
      expect(tip20, 6.67);
      expect(tip22, 7.33);
      expect(tip25, 8.33);
    });
  });
}
