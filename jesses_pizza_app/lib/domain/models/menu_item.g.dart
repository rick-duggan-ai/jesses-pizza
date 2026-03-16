// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => _MenuItem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  groupId: json['groupId'] as String?,
  imageUrl: json['imageUrl'] as String?,
  sizes:
      (json['sizes'] as List<dynamic>?)
          ?.map((e) => MenuItemSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MenuItemToJson(_MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'groupId': instance.groupId,
  'imageUrl': instance.imageUrl,
  'sizes': instance.sizes,
};

_MenuItemSize _$MenuItemSizeFromJson(Map<String, dynamic> json) =>
    _MenuItemSize(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$MenuItemSizeToJson(_MenuItemSize instance) =>
    <String, dynamic>{'name': instance.name, 'price': instance.price};
