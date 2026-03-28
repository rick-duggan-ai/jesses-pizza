import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/data/services/cart_storage_service.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';

class MockCartStorageService extends Mock implements CartStorageService {}

void main() {
  const tItem1 = CartItem(
    menuItemId: 'item-1',
    name: 'Pepperoni Pizza',
    sizeName: 'Large',
    price: 14.99,
    quantity: 1,
  );

  const tItem2 = CartItem(
    menuItemId: 'item-2',
    name: 'Cheese Pizza',
    sizeName: 'Medium',
    price: 11.99,
    quantity: 2,
  );

  late MockCartStorageService mockStorage;

  setUp(() {
    mockStorage = MockCartStorageService();
    when(() => mockStorage.load()).thenReturn([]);
    when(() => mockStorage.save(any())).thenAnswer((_) async {});
    when(() => mockStorage.clear()).thenAnswer((_) async {});
  });

  group('CartBloc persistence — save on mutations', () {
    blocTest<CartBloc, CartState>(
      'saves cart after AddItem',
      build: () => CartBloc(cartStorage: mockStorage),
      act: (bloc) => bloc.add(const AddItem(tItem1)),
      expect: () => [const CartState(items: [tItem1])],
      verify: (_) {
        verify(() => mockStorage.save([tItem1])).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'saves cart after RemoveItem',
      build: () => CartBloc(cartStorage: mockStorage),
      seed: () => const CartState(items: [tItem1, tItem2]),
      act: (bloc) => bloc.add(const RemoveItem('item-1', 'Large')),
      expect: () => [const CartState(items: [tItem2])],
      verify: (_) {
        verify(() => mockStorage.save([tItem2])).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'saves cart after UpdateQuantity',
      build: () => CartBloc(cartStorage: mockStorage),
      seed: () => const CartState(items: [tItem1]),
      act: (bloc) => bloc.add(const UpdateQuantity('item-1', 'Large', 5)),
      expect: () => [
        CartState(items: [tItem1.copyWith(quantity: 5)]),
      ],
      verify: (_) {
        verify(() => mockStorage.save([tItem1.copyWith(quantity: 5)])).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'saves cart after UpdateItem',
      build: () => CartBloc(cartStorage: mockStorage),
      seed: () => const CartState(items: [tItem1]),
      act: (bloc) => bloc.add(UpdateItem(
        index: 0,
        item: tItem1.copyWith(quantity: 3),
      )),
      expect: () => [
        CartState(items: [tItem1.copyWith(quantity: 3)]),
      ],
      verify: (_) {
        verify(() => mockStorage.save([tItem1.copyWith(quantity: 3)])).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'clears storage on ClearCart',
      build: () => CartBloc(cartStorage: mockStorage),
      seed: () => const CartState(items: [tItem1]),
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [const CartState()],
      verify: (_) {
        verify(() => mockStorage.clear()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'saves cart after ValidateCart removes invalid items',
      build: () => CartBloc(cartStorage: mockStorage),
      seed: () => const CartState(items: [tItem1, tItem2]),
      act: (bloc) => bloc.add(const ValidateCart({'item-2'})),
      expect: () => [const CartState(items: [tItem2])],
      verify: (_) {
        verify(() => mockStorage.save([tItem2])).called(1);
      },
    );
  });

  group('CartBloc persistence — load on init', () {
    blocTest<CartBloc, CartState>(
      'LoadPersistedCart restores items from storage',
      setUp: () {
        when(() => mockStorage.load()).thenReturn([tItem1, tItem2]);
      },
      build: () => CartBloc(cartStorage: mockStorage),
      act: (bloc) => bloc.add(const LoadPersistedCart()),
      expect: () => [const CartState(items: [tItem1, tItem2])],
      verify: (_) {
        verify(() => mockStorage.load()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'LoadPersistedCart with empty storage emits no change',
      build: () => CartBloc(cartStorage: mockStorage),
      act: (bloc) => bloc.add(const LoadPersistedCart()),
      expect: () => <CartState>[],
      verify: (_) {
        verify(() => mockStorage.load()).called(1);
      },
    );
  });

  group('CartBloc persistence — non-item events do not save', () {
    blocTest<CartBloc, CartState>(
      'SetDeliveryMode does not trigger save',
      build: () => CartBloc(cartStorage: mockStorage),
      act: (bloc) => bloc.add(const SetDeliveryMode(true)),
      expect: () => [const CartState(isDelivery: true)],
      verify: (_) {
        verifyNever(() => mockStorage.save(any()));
      },
    );

    blocTest<CartBloc, CartState>(
      'SetTip does not trigger save',
      build: () => CartBloc(cartStorage: mockStorage),
      act: (bloc) => bloc.add(const SetTip(5.0)),
      expect: () => [const CartState(tip: 5.0)],
      verify: (_) {
        verifyNever(() => mockStorage.save(any()));
      },
    );
  });

  group('CartBloc works without storage (backward compat)', () {
    blocTest<CartBloc, CartState>(
      'CartBloc with no storage still adds items normally',
      build: () => CartBloc(),
      act: (bloc) => bloc.add(const AddItem(tItem1)),
      expect: () => [const CartState(items: [tItem1])],
    );

    blocTest<CartBloc, CartState>(
      'CartBloc with no storage clears without error',
      build: () => CartBloc(),
      seed: () => const CartState(items: [tItem1]),
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [const CartState()],
    );
  });
}
