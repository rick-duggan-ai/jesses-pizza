import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

part 'menu_category.freezed.dart';
part 'menu_category.g.dart';

@freezed
abstract class MenuCategory with _$MenuCategory {
  const factory MenuCategory({
    required String id,
    required String name,
    String? imageUrl,
    @Default(0) int ordinal,
    @Default([]) List<MenuItem> menuItems,
  }) = _MenuCategory;

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);
}
