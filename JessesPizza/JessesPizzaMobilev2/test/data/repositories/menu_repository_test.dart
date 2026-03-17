import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/menu_repository.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late MenuRepository menuRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    menuRepository = MenuRepository(apiClient: mockApiClient);
  });

  group('MenuRepository', () {
    test('getGroups calls correct endpoint with apiVersion 1.0 and returns list',
        () async {
      final responseData = [
        {'id': 'g1', 'name': 'Pizzas', 'description': null, 'imageUrl': null},
        {'id': 'g2', 'name': 'Drinks', 'description': null, 'imageUrl': null},
      ];

      when(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.groups,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.groups),
          ));

      final groups = await menuRepository.getGroups();

      expect(groups, isA<List<MenuGroup>>());
      expect(groups.length, 2);
      expect(groups.first.name, 'Pizzas');
      verify(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.groups,
            apiVersion: '1.0',
          )).called(1);
    });

    test('getMenuItems calls correct endpoint with apiVersion 1.0 and returns list',
        () async {
      final responseData = [
        {
          'id': 'i1',
          'name': 'Pepperoni Pizza',
          'description': null,
          'groupId': 'g1',
          'imageUrl': null,
          'sizes': [
            {'name': 'Large', 'price': 14.99}
          ],
        },
      ];

      when(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.mainMenuItems,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.mainMenuItems),
          ));

      final items = await menuRepository.getMenuItems();

      expect(items, isA<List<MenuItem>>());
      expect(items.length, 1);
      expect(items.first.name, 'Pepperoni Pizza');
      verify(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.mainMenuItems,
            apiVersion: '1.0',
          )).called(1);
    });

    test('checkHours calls correct endpoint with apiVersion 1.0 and returns bool',
        () async {
      when(() => mockApiClient.get<bool>(
            ApiEndpoints.checkHours,
            apiVersion: '1.0',
          )).thenAnswer((_) async => Response(
            data: true,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.checkHours),
          ));

      final result = await menuRepository.checkHours();

      expect(result, true);
      verify(() => mockApiClient.get<bool>(
            ApiEndpoints.checkHours,
            apiVersion: '1.0',
          )).called(1);
    });
  });
}
