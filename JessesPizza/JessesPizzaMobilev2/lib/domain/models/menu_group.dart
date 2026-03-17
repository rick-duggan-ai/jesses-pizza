import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

part 'menu_group.freezed.dart';
part 'menu_group.g.dart';

@freezed
abstract class MenuGroupItem with _$MenuGroupItem {
  const factory MenuGroupItem({
    required String id,
    String? groupId,
    String? name,
    String? imageUrl,
    @Default([]) List<MenuItemSize> sizes,
    @Default([]) List<dynamic> sides,
  }) = _MenuGroupItem;

  factory MenuGroupItem.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupItemFromJson(json);
}

@freezed
abstract class MenuGroup with _$MenuGroup {
  const factory MenuGroup({
    required String id,
    required String name,
    String? imageUrl,
    @Default(0) int type,
    @Default(0) int groupType,
    @Default(false) bool isRequired,
    @Default(0) int min,
    @Default(0) int max,
    @Default([]) List<MenuGroupItem> items,
  }) = _MenuGroup;

  factory MenuGroup.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupFromJson(json);
}
