import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/account_repository.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late AccountRepository accountRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    accountRepository = AccountRepository(apiClient: mockApiClient);
  });

  group('AccountRepository', () {
    test('getAccountInfo calls correct endpoint with apiVersion 1.0', () async {
      final responseData = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
      };

      when(() => mockApiClient.get<Map<String, dynamic>>(
            ApiEndpoints.getAccountInfo,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.getAccountInfo),
          ));

      final info = await accountRepository.getAccountInfo();

      expect(info['firstName'], 'John');
      verify(() => mockApiClient.get<Map<String, dynamic>>(
            ApiEndpoints.getAccountInfo,
            apiVersion: '1.0',
          )).called(1);
    });

    test('getAddresses calls correct endpoint with apiVersion 1.0 and returns list',
        () async {
      final responseData = [
        {
          'id': 'addr-1',
          'addressLine1': '123 Main St',
          'addressLine2': null,
          'city': 'Springfield',
          'state': null,
          'zipCode': '12345',
        }
      ];

      when(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.addresses,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.addresses),
          ));

      final addresses = await accountRepository.getAddresses();

      expect(addresses, isA<List<Address>>());
      expect(addresses.length, 1);
      expect(addresses.first.addressLine1, '123 Main St');
    });

    test('getCreditCards calls correct endpoint with apiVersion 1.0 and returns list',
        () async {
      final responseData = [
        {
          'id': 'card-1',
          'cardNumber': '****1234',
          'expirationDate': '12/28',
        }
      ];

      when(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.creditCards,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.creditCards),
          ));

      final cards = await accountRepository.getCreditCards();

      expect(cards, isA<List<CreditCard>>());
      expect(cards.first.cardNumber, '****1234');
    });

    test('saveAddress calls correct endpoint with apiVersion 1.0', () async {
      final address = Address(
        id: 'addr-1',
        addressLine1: '123 Main St',
        city: 'Springfield',
        zipCode: '12345',
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.saveAddress,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: {'succeeded': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.saveAddress),
          ));

      final result = await accountRepository.saveAddress(address);

      expect(result, isA<ApiResponse>());
      expect(result.succeeded, true);
    });

    test('deleteCreditCard calls correct endpoint with apiVersion 1.0',
        () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.deleteCard,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: {'succeeded': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.deleteCard),
          ));

      final result = await accountRepository.deleteCreditCard('card-1');

      expect(result.succeeded, true);
      verify(() => mockApiClient.post<Map<String, dynamic>>(
            ApiEndpoints.deleteCard,
            data: any(named: 'data'),
            apiVersion: '1.0',
          )).called(1);
    });
  });
}
