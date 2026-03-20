import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

part 'menu_group.freezed.dart';
part 'menu_group.g.dart';

enum GroupType { single, multiple, minMax }

@freezed
abstract class GroupItemOption with _$GroupItemOption {
  const factory GroupItemOption({
    String? id,
    required String name,
    @Default(0.0) double price,
    @Default(false) bool isDefault,
  }) = _GroupItemOption;
  factory GroupItemOption.fromJson(Map<String, dynamic> json) => _$GroupItemOptionFromJson(json);
}

@freezed
abstract class MenuGroupItem with _$MenuGroupItem {
  const factory MenuGroupItem({
    required String id,
    String? groupId,
    String? name,
    String? imageUrl,
    @Default([]) List<MenuItemSize> sizes,
    @Default([]) List<GroupItemOption> sides,
  }) = _MenuGroupItem;
  factory MenuGroupItem.fromJson(Map<String, dynamic> json) => _$MenuGroupItemFromJson(json);
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
  factory MenuGroup.fromJson(Map<String, dynamic> json) => _$MenuGroupFromJson(json);
}

extension MenuGroupX on MenuGroup {
  GroupType get groupTypeEnum {
    switch (groupType) {
      case 0: return GroupType.single;
      case 1: return GroupType.multiple;
      case 2: return GroupType.minMax;
      default: return GroupType.single;
    }
  }
}
