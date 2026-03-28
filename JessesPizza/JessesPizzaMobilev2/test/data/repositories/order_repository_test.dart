import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/order_repository.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart' hide TransactionItem;
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late OrderRepository orderRepository;

  final tTransactionRequest = TransactionRequest(
    info: const CustomerInfo(
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '5551234567',
      emailAddress: 'john@example.com',
      addressLine1: '123 Main St',
      city: 'Springfield',
      zipCode: '62701',
    ),
    transactionItems: const [
      TransactionItem(
        menuItemId: 'item-1',
        name: 'Pepperoni Pizza',
        sizeName: 'Large',
        quantity: 1,
        price: 14.99,
      ),
    ],
    totals: const OrderTotals(
      subTotal: 14.99,
      taxTotal: 1.20,
      deliveryCharge: 3.00,
      tip: 2.00,
      total: 21.19,
    ),
    isDelivery: true,
  );

  final tPostRequest = PostTransactionRequest(
    transaction: tTransactionRequest,
    card: const CreditCardRef(id: 'card-1'),
  );

  setUp(() {
    mockApiClient = MockApiClient();
    orderRepository = OrderRepository(apiClient: mockApiClient);
  });

  group('OrderRepository', () {
    test('validateTransaction calls correct endpoint with apiVersion 1.1',
        () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.validateTransaction,
            data: any(named: 'data'),
            apiVersion: '1.1',
          )).thenAnswer((_) async => Response(
            data: {'succeeded': true},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: ApiEndpoints.validateTransaction),
          ));

      final result =
          await orderRepository.validateTransaction(tTransactionRequest);

      expect(result, isA<ApiResponse>());
      expect(result.succeeded, true);
      verify(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.validateTransaction,
            data: any(named: 'data'),
            apiVersion: '1.1',
          )).called(1);
    });

    test('postTransaction calls correct endpoint with apiVersion 1.1',
        () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.postTransaction,
            data: any(named: 'data'),
            apiVersion: '1.1',
          )).thenAnswer((_) async => Response(
            data: {'succeeded': true},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: ApiEndpoints.postTransaction),
          ));

      final result = await orderRepository.postTransaction(tPostRequest);

      expect(result.succeeded, true);
    });

    test('getHppToken returns hPPToken string from response', () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.getHppToken,
            data: any(named: 'data'),
            apiVersion: '1.1',
          )).thenAnswer((_) async => Response(
            // API returns MongoTransaction with HPPToken property (camelCase: hPPToken)
            data: {
              'hPPToken':
                  'https://api.convergepay.com/hosted-payments/?ssl_txn_auth_token=abc123'
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.getHppToken),
          ));

      final token =
          await orderRepository.getHppToken(tTransactionRequest);

      expect(token,
          'https://api.convergepay.com/hosted-payments/?ssl_txn_auth_token=abc123');
    });

    test(
        'getOrders calls correct endpoint with apiVersion 1.1 and returns list',
        () async {
      final responseData = {
        'transactions': [
          {
            'id': 'txn-1',
            'date': '2026-03-16T12:00:00Z',
            'total': 24.99,
            'isDelivery': true,
            'items': [],
          }
        ]
      };

      when(() => mockApiClient.get<Map<String, dynamic>>(
            ApiEndpoints.getOrders,
            apiVersion: '1.1',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.getOrders),
          ));

      final orders = await orderRepository.getOrders();

      expect(orders, isA<List<Transaction>>());
      expect(orders.length, 1);
      expect(orders.first.total, 24.99);
      verify(() => mockApiClient.get<Map<String, dynamic>>(
            ApiEndpoints.getOrders,
            apiVersion: '1.1',
          )).called(1);
    });

    test('getTransactionByGuid calls correct endpoint with apiVersion 1.1',
        () async {
      final responseData = {
        'id': 'txn-guid-1',
        'date': '2026-03-16T12:00:00Z',
        'total': 19.99,
        'isDelivery': false,
        'items': [],
      };

      when(() => mockApiClient.get<Map<String, dynamic>>(
            ApiEndpoints.transactionGuid,
            queryParameters: any(named: 'queryParameters'),
            apiVersion: '1.1',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions:
                RequestOptions(path: ApiEndpoints.transactionGuid),
          ));

      final txn =
          await orderRepository.getTransactionByGuid('txn-guid-1');

      expect(txn, isA<Transaction>());
      expect(txn.total, 19.99);
    });
  });
}
