import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart' hide TransactionItem;
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_state.dart';

class MockOrderRepository extends Mock implements IOrderRepository {}

class FakeTransactionRequest extends Fake implements TransactionRequest {}

class FakePostTransactionRequest extends Fake
    implements PostTransactionRequest {}

void main() {
  late MockOrderRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTransactionRequest());
    registerFallbackValue(FakePostTransactionRequest());
    registerFallbackValue(0.0);
  });

  final tTransactionRequest = TransactionRequest(
    info: const CustomerInfo(
      firstName: 'Jane',
      lastName: 'Smith',
      phoneNumber: '5559876543',
      emailAddress: 'jane@example.com',
      addressLine1: '456 Oak Ave',
      city: 'Shelbyville',
      zipCode: '62702',
    ),
    transactionItems: const [
      TransactionItem(
        menuItemId: 'item-2',
        name: 'Margherita Pizza',
        sizeName: 'Medium',
        quantity: 1,
        price: 12.99,
      ),
    ],
    totals: const OrderTotals(
      subTotal: 12.99,
      taxTotal: 1.04,
      deliveryCharge: 0.0,
      tip: 3.00,
      total: 17.03,
    ),
    isDelivery: false,
  );

  final tPostRequest = PostTransactionRequest(
    transaction: tTransactionRequest,
    card: const CreditCardRef(id: 'card-1'),
  );

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
        when(() => mockRepo.validateTransactionAmount(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.postTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(SubmitOrder(request: tPostRequest)),
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
          bloc.add(SubmitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        isA<OrderError>(),
      ],
    );
  });
}
