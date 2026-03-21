// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => _MenuItem(
  id: json['id'] as String?,
  name: json['name'] as String?,
  imageUrl: json['imageUrl'] as String?,
  description: json['description'] as String?,
  sizes:
      (json['sizes'] as List<dynamic>?)
          ?.map((e) => MenuItemSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MenuItemToJson(_MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'sizes': instance.sizes,
};

_MenuItemSize _$MenuItemSizeFromJson(Map<String, dynamic> json) =>
    _MenuItemSize(
      id: json['id'] as String?,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isDefault: json['isDefault'] as bool? ?? false,
      groupIds:
          (json['groupIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MenuItemSizeToJson(_MenuItemSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'isDefault': instance.isDefault,
      'groupIds': instance.groupIds,
    };
