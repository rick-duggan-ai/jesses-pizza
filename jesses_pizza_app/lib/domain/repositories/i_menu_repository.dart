import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

abstract class IMenuRepository {
  Future<List<MenuGroup>> getGroups();
  Future<List<MenuItem>> getMenuItems();
  Future<bool> checkHours();
}
