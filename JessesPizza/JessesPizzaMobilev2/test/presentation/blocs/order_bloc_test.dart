import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_state.dart';

class MockOrderRepository extends Mock implements IOrderRepository {}

void main() {
  late MockOrderRepository mockRepo;

  final tTransaction = <String, dynamic>{'amount': 19.99, 'items': []};
  final tOrders = <Transaction>[
    Transaction(
      id: 'order-1',
      date: DateTime(2026, 1, 1),
      total: 19.99,
      isDelivery: false,
    ),
  ];

  setUp(() {
    mockRepo = MockOrderRepository();
  });

  group('OrderBloc', () {
    test('initial state is OrderInitial', () {
      final bloc = OrderBloc(repository: mockRepo);
      expect(bloc.state, const OrderState.initial());
      bloc.close();
    });

    blocTest<OrderBloc, OrderState>(
      'emits [loading, orderSubmitted] on SubmitOrder success',
      build: () {
        when(() => mockRepo.validateTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.postTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(transaction: tTransaction)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.orderSubmitted(),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, historyLoaded] on LoadOrderHistory success',
      build: () {
        when(() => mockRepo.getOrders()).thenAnswer((_) async => tOrders);
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const OrderEvent.loadOrderHistory()),
      expect: () => [
        const OrderState.loading(),
        OrderState.historyLoaded(orders: tOrders),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, error] on SubmitOrder failure',
      build: () {
        when(() => mockRepo.validateTransaction(any()))
            .thenThrow(Exception('Validation failed'));
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(transaction: tTransaction)),
      expect: () => [
        const OrderState.loading(),
        isA<OrderError>(),
      ],
    );
  });
}
