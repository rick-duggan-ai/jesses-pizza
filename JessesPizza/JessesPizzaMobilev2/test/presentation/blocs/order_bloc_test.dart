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

void main() {
  late MockOrderRepository mockRepo;

  final tTransaction = TransactionRequest(
    info: const CustomerInfo(
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '7025551234',
      emailAddress: 'john@example.com',
      addressLine1: '123 Main St',
      city: 'Henderson',
      zipCode: '89012',
    ),
    transactionItems: const [
      TransactionItem(
        menuItemId: 'item-1',
        name: 'Large Pepperoni',
        sizeName: 'Large',
        quantity: 1,
        price: 15.99,
      ),
    ],
    totals: const OrderTotals(
      subTotal: 15.99,
      taxTotal: 1.28,
      total: 17.27,
    ),
    isDelivery: true,
  );

  final tPostRequest = PostTransactionRequest(
    transaction: tTransaction,
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
    registerFallbackValue(tTransaction);
    registerFallbackValue(tPostRequest);
  });

  group('OrderBloc', () {
    test('initial state is OrderInitial', () {
      final bloc = OrderBloc(repository: mockRepo);
      expect(bloc.state, const OrderState.initial());
      bloc.close();
    });

    blocTest<OrderBloc, OrderState>(
      'emits [loading, orderSubmitted] on SubmitOrder when validation and amount check pass',
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
          bloc.add(OrderEvent.submitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.orderSubmitted(),
      ],
      verify: (_) {
        verify(() => mockRepo.validateTransaction(any())).called(1);
        verify(() => mockRepo.validateTransactionAmount(any())).called(1);
        verify(() => mockRepo.postTransaction(any())).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, error] when validateTransaction fails',
      build: () {
        when(() => mockRepo.validateTransaction(any())).thenAnswer(
          (_) async => const ApiResponse(
            succeeded: false,
            message: 'Store is not open',
          ),
        );
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.error(message: 'Store is not open'),
      ],
      verify: (_) {
        verify(() => mockRepo.validateTransaction(any())).called(1);
        verifyNever(() => mockRepo.postTransaction(any()));
      },
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, error] when validateTransactionAmount fails',
      build: () {
        when(() => mockRepo.validateTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.validateTransactionAmount(any())).thenAnswer(
          (_) async => const ApiResponse(
            succeeded: false,
            message: 'Total must be at least \$10.00',
          ),
        );
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.error(message: 'Total must be at least \$10.00'),
      ],
      verify: (_) {
        verifyNever(() => mockRepo.postTransaction(any()));
      },
    );

    blocTest<OrderBloc, OrderState>(
      'attaches transactionGuid from validation to PostTransactionRequest',
      build: () {
        when(() => mockRepo.validateTransaction(any())).thenAnswer(
          (_) async => const ApiResponse(
            succeeded: true,
            transactionGuid: 'guid-from-server',
          ),
        );
        when(() => mockRepo.validateTransactionAmount(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.postTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.orderSubmitted(),
      ],
      verify: (_) {
        final captured = verify(() => mockRepo.postTransaction(captureAny()))
            .captured
            .single as PostTransactionRequest;
        expect(captured.transaction.transactionId, 'guid-from-server');
      },
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, hppTokenReady] on RequestHppToken success',
      build: () {
        when(() => mockRepo.validateTransaction(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.validateTransactionAmount(any()))
            .thenAnswer((_) async => const ApiResponse(succeeded: true));
        when(() => mockRepo.getHppToken(any())).thenAnswer(
          (_) async => 'https://converge.com/hpp?token=abc123',
        );
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.requestHppToken(transaction: tTransaction)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.hppTokenReady(
            token: 'https://converge.com/hpp?token=abc123'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [loading, error] on RequestHppToken when validation fails',
      build: () {
        when(() => mockRepo.validateTransaction(any())).thenAnswer(
          (_) async => const ApiResponse(
            succeeded: false,
            message: 'Zip Code out of range',
          ),
        );
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.requestHppToken(transaction: tTransaction)),
      expect: () => [
        const OrderState.loading(),
        const OrderState.error(message: 'Zip Code out of range'),
      ],
      verify: (_) {
        verifyNever(() => mockRepo.getHppToken(any()));
      },
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
      'emits [loading, error] on SubmitOrder exception',
      build: () {
        when(() => mockRepo.validateTransaction(any()))
            .thenThrow(Exception('Network error'));
        return OrderBloc(repository: mockRepo);
      },
      act: (bloc) =>
          bloc.add(OrderEvent.submitOrder(request: tPostRequest)),
      expect: () => [
        const OrderState.loading(),
        isA<OrderError>(),
      ],
    );
  });
}
