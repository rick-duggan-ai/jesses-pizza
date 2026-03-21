import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';

abstract class IMenuRepository {
  Future<List<MenuGroup>> getGroups();
  Future<List<MenuCategory>> getMenuItems();
  Future<bool> checkHours();
  Future<StoreSettings> getSettings();
}
