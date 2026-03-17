import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    String? description,
    String? groupId,
    String? imageUrl,
    @Default([]) List<MenuItemSize> sizes,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}

@freezed
abstract class MenuItemSize with _$MenuItemSize {
  const factory MenuItemSize({
    required String name,
    required double price,
  }) = _MenuItemSize;

  factory MenuItemSize.fromJson(Map<String, dynamic> json) =>
      _$MenuItemSizeFromJson(json);
}
