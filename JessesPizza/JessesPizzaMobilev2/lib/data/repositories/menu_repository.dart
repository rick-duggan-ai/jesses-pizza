import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';

class MenuRepository implements IMenuRepository {
  final ApiClient apiClient;

  MenuRepository({required this.apiClient});

  @override
  Future<List<MenuGroup>> getGroups() async {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.groups,
      apiVersion: '1.0',
    );
    return (response.data as List)
        .map((json) => MenuGroup.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MenuCategory>> getMenuItems() async {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.mainMenuItems,
      apiVersion: '1.0',
    );
    return (response.data as List)
        .map((json) => MenuCategory.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> checkHours() async {
    final response = await apiClient.get<bool>(
      ApiEndpoints.checkHours,
      apiVersion: '1.0',
    );
    return response.data!;
  }

  @override
  Future<StoreSettings> getSettings() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.orderInfo,
      apiVersion: '1.0',
    );
    return StoreSettings.fromJson(response.data!);
  }
}
