import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/data/repositories/menu_repository.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';

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
        {
          'id': '8A6BE945D2B908DBDDB04CD3',
          'name': 'Dipping Sauces Included',
          'type': 0,
          'groupType': 1,
          'isRequired': true,
          'min': 0,
          'max': 0,
          'imageUrl': null,
          'items': [],
        },
        {
          'id': 'g2',
          'name': 'Toppings',
          'type': 0,
          'groupType': 0,
          'isRequired': false,
          'min': 0,
          'max': 0,
          'imageUrl': null,
          'items': [],
        },
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
      expect(groups.first.name, 'Dipping Sauces Included');
      expect(groups.first.isRequired, true);
      verify(() => mockApiClient.get<List<dynamic>>(
            ApiEndpoints.groups,
            apiVersion: '1.0',
          )).called(1);
    });

    test('getMenuItems calls correct endpoint with apiVersion 1.0 and returns list of MenuCategory',
        () async {
      final responseData = [
        {
          'id': '5942c256617419278227f197',
          'name': r'$20 MEAL DEAL',
          'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/5942c256617419278227f197.jpg',
          'ordinal': 0,
          'menuItems': [
            {
              'id': '6c84287c33277b20d0865b21',
              'name': r'$20 MEAL DEAL',
              'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/6c84287c33277b20d0865b21.jpg',
              'description': 'Large (16") Cheese Pizza, 6 Garlic Knots and a 2 Liter of Soda!',
              'sizes': [
                {
                  'id': '03067C5CF42C5F4132E1E2F9',
                  'name': r'$20 MEAL',
                  'price': 20.0,
                  'isDefault': false,
                  'groupIds': ['686D4DF22587FCDF8F05A9CB'],
                }
              ],
            }
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

      final categories = await menuRepository.getMenuItems();

      expect(categories, isA<List<MenuCategory>>());
      expect(categories.length, 1);
      expect(categories.first.name, r'$20 MEAL DEAL');
      expect(categories.first.menuItems.length, 1);
      expect(categories.first.menuItems.first.sizes.first.price, 20.0);
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
