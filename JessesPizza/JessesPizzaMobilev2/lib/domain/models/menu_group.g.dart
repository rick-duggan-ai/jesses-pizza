// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupItemOption _$GroupItemOptionFromJson(Map<String, dynamic> json) =>
    _GroupItemOption(
      id: json['id'] as String?,
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$GroupItemOptionToJson(_GroupItemOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'isDefault': instance.isDefault,
    };

_MenuGroupItem _$MenuGroupItemFromJson(Map<String, dynamic> json) =>
    _MenuGroupItem(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => MenuItemSize.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sides:
          (json['sides'] as List<dynamic>?)
              ?.map((e) => GroupItemOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MenuGroupItemToJson(_MenuGroupItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'sizes': instance.sizes,
      'sides': instance.sides,
    };

_MenuGroup _$MenuGroupFromJson(Map<String, dynamic> json) => _MenuGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  type: (json['type'] as num?)?.toInt() ?? 0,
  groupType: (json['groupType'] as num?)?.toInt() ?? 0,
  isRequired: json['isRequired'] as bool? ?? false,
  min: (json['min'] as num?)?.toInt() ?? 0,
  max: (json['max'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => MenuGroupItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MenuGroupToJson(_MenuGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'groupType': instance.groupType,
      'isRequired': instance.isRequired,
      'min': instance.min,
      'max': instance.max,
      'items': instance.items,
    };
