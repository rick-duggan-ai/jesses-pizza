import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    @Default([]) List<MenuItemSize> sizes,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}

@freezed
abstract class MenuItemSize with _$MenuItemSize {
  const factory MenuItemSize({
    String? id,
    required String name,
    required double price,
    @Default(false) bool isDefault,
    @Default([]) List<String> groupIds,
  }) = _MenuItemSize;

  factory MenuItemSize.fromJson(Map<String, dynamic> json) =>
      _$MenuItemSizeFromJson(json);
}
