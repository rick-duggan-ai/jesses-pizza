// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuCategory _$MenuCategoryFromJson(Map<String, dynamic> json) =>
    _MenuCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      ordinal: (json['ordinal'] as num?)?.toInt() ?? 0,
      menuItems:
          (json['menuItems'] as List<dynamic>?)
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MenuCategoryToJson(_MenuCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'ordinal': instance.ordinal,
      'menuItems': instance.menuItems,
    };
