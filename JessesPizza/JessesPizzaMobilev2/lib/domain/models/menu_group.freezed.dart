// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupItemOption {

 String? get id; String get name; double get price; bool get isDefault;
/// Create a copy of GroupItemOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupItemOptionCopyWith<GroupItemOption> get copyWith => _$GroupItemOptionCopyWithImpl<GroupItemOption>(this as GroupItemOption, _$identity);

  /// Serializes this GroupItemOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupItemOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,isDefault);

@override
String toString() {
  return 'GroupItemOption(id: $id, name: $name, price: $price, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $GroupItemOptionCopyWith<$Res>  {
  factory $GroupItemOptionCopyWith(GroupItemOption value, $Res Function(GroupItemOption) _then) = _$GroupItemOptionCopyWithImpl;
@useResult
$Res call({
 String? id, String name, double price, bool isDefault
});




}
/// @nodoc
class _$GroupItemOptionCopyWithImpl<$Res>
    implements $GroupItemOptionCopyWith<$Res> {
  _$GroupItemOptionCopyWithImpl(this._self, this._then);

  final GroupItemOption _self;
  final $Res Function(GroupItemOption) _then;

/// Create a copy of GroupItemOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupItemOption].
extension GroupItemOptionPatterns on GroupItemOption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupItemOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupItemOption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupItemOption value)  $default,){
final _that = this;
switch (_that) {
case _GroupItemOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupItemOption value)?  $default,){
final _that = this;
switch (_that) {
case _GroupItemOption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  double price,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupItemOption() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isDefault);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  double price,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _GroupItemOption():
return $default(_that.id,_that.name,_that.price,_that.isDefault);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  double price,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _GroupItemOption() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupItemOption implements GroupItemOption {
  const _GroupItemOption({this.id, required this.name, this.price = 0.0, this.isDefault = false});
  factory _GroupItemOption.fromJson(Map<String, dynamic> json) => _$GroupItemOptionFromJson(json);

@override final  String? id;
@override final  String name;
@override@JsonKey() final  double price;
@override@JsonKey() final  bool isDefault;

/// Create a copy of GroupItemOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupItemOptionCopyWith<_GroupItemOption> get copyWith => __$GroupItemOptionCopyWithImpl<_GroupItemOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupItemOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupItemOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,isDefault);

@override
String toString() {
  return 'GroupItemOption(id: $id, name: $name, price: $price, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$GroupItemOptionCopyWith<$Res> implements $GroupItemOptionCopyWith<$Res> {
  factory _$GroupItemOptionCopyWith(_GroupItemOption value, $Res Function(_GroupItemOption) _then) = __$GroupItemOptionCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, double price, bool isDefault
});




}
/// @nodoc
class __$GroupItemOptionCopyWithImpl<$Res>
    implements _$GroupItemOptionCopyWith<$Res> {
  __$GroupItemOptionCopyWithImpl(this._self, this._then);

  final _GroupItemOption _self;
  final $Res Function(_GroupItemOption) _then;

/// Create a copy of GroupItemOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? isDefault = null,}) {
  return _then(_GroupItemOption(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MenuGroupItem {

 String get id; String? get groupId; String? get name; String? get imageUrl; List<MenuItemSize> get sizes; List<GroupItemOption> get sides;
/// Create a copy of MenuGroupItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuGroupItemCopyWith<MenuGroupItem> get copyWith => _$MenuGroupItemCopyWithImpl<MenuGroupItem>(this as MenuGroupItem, _$identity);

  /// Serializes this MenuGroupItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuGroupItem&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.sizes, sizes)&&const DeepCollectionEquality().equals(other.sides, sides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,name,imageUrl,const DeepCollectionEquality().hash(sizes),const DeepCollectionEquality().hash(sides));

@override
String toString() {
  return 'MenuGroupItem(id: $id, groupId: $groupId, name: $name, imageUrl: $imageUrl, sizes: $sizes, sides: $sides)';
}


}

/// @nodoc
abstract mixin class $MenuGroupItemCopyWith<$Res>  {
  factory $MenuGroupItemCopyWith(MenuGroupItem value, $Res Function(MenuGroupItem) _then) = _$MenuGroupItemCopyWithImpl;
@useResult
$Res call({
 String id, String? groupId, String? name, String? imageUrl, List<MenuItemSize> sizes, List<GroupItemOption> sides
});




}
/// @nodoc
class _$MenuGroupItemCopyWithImpl<$Res>
    implements $MenuGroupItemCopyWith<$Res> {
  _$MenuGroupItemCopyWithImpl(this._self, this._then);

  final MenuGroupItem _self;
  final $Res Function(MenuGroupItem) _then;

/// Create a copy of MenuGroupItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = freezed,Object? name = freezed,Object? imageUrl = freezed,Object? sizes = null,Object? sides = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MenuItemSize>,sides: null == sides ? _self.sides : sides // ignore: cast_nullable_to_non_nullable
as List<GroupItemOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuGroupItem].
extension MenuGroupItemPatterns on MenuGroupItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuGroupItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuGroupItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuGroupItem value)  $default,){
final _that = this;
switch (_that) {
case _MenuGroupItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuGroupItem value)?  $default,){
final _that = this;
switch (_that) {
case _MenuGroupItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? groupId,  String? name,  String? imageUrl,  List<MenuItemSize> sizes,  List<GroupItemOption> sides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuGroupItem() when $default != null:
return $default(_that.id,_that.groupId,_that.name,_that.imageUrl,_that.sizes,_that.sides);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? groupId,  String? name,  String? imageUrl,  List<MenuItemSize> sizes,  List<GroupItemOption> sides)  $default,) {final _that = this;
switch (_that) {
case _MenuGroupItem():
return $default(_that.id,_that.groupId,_that.name,_that.imageUrl,_that.sizes,_that.sides);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? groupId,  String? name,  String? imageUrl,  List<MenuItemSize> sizes,  List<GroupItemOption> sides)?  $default,) {final _that = this;
switch (_that) {
case _MenuGroupItem() when $default != null:
return $default(_that.id,_that.groupId,_that.name,_that.imageUrl,_that.sizes,_that.sides);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuGroupItem implements MenuGroupItem {
  const _MenuGroupItem({required this.id, this.groupId, this.name, this.imageUrl, final  List<MenuItemSize> sizes = const [], final  List<GroupItemOption> sides = const []}): _sizes = sizes,_sides = sides;
  factory _MenuGroupItem.fromJson(Map<String, dynamic> json) => _$MenuGroupItemFromJson(json);

@override final  String id;
@override final  String? groupId;
@override final  String? name;
@override final  String? imageUrl;
 final  List<MenuItemSize> _sizes;
@override@JsonKey() List<MenuItemSize> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}

 final  List<GroupItemOption> _sides;
@override@JsonKey() List<GroupItemOption> get sides {
  if (_sides is EqualUnmodifiableListView) return _sides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sides);
}


/// Create a copy of MenuGroupItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuGroupItemCopyWith<_MenuGroupItem> get copyWith => __$MenuGroupItemCopyWithImpl<_MenuGroupItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuGroupItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuGroupItem&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._sizes, _sizes)&&const DeepCollectionEquality().equals(other._sides, _sides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,name,imageUrl,const DeepCollectionEquality().hash(_sizes),const DeepCollectionEquality().hash(_sides));

@override
String toString() {
  return 'MenuGroupItem(id: $id, groupId: $groupId, name: $name, imageUrl: $imageUrl, sizes: $sizes, sides: $sides)';
}


}

/// @nodoc
abstract mixin class _$MenuGroupItemCopyWith<$Res> implements $MenuGroupItemCopyWith<$Res> {
  factory _$MenuGroupItemCopyWith(_MenuGroupItem value, $Res Function(_MenuGroupItem) _then) = __$MenuGroupItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? groupId, String? name, String? imageUrl, List<MenuItemSize> sizes, List<GroupItemOption> sides
});




}
/// @nodoc
class __$MenuGroupItemCopyWithImpl<$Res>
    implements _$MenuGroupItemCopyWith<$Res> {
  __$MenuGroupItemCopyWithImpl(this._self, this._then);

  final _MenuGroupItem _self;
  final $Res Function(_MenuGroupItem) _then;

/// Create a copy of MenuGroupItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = freezed,Object? name = freezed,Object? imageUrl = freezed,Object? sizes = null,Object? sides = null,}) {
  return _then(_MenuGroupItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MenuItemSize>,sides: null == sides ? _self._sides : sides // ignore: cast_nullable_to_non_nullable
as List<GroupItemOption>,
  ));
}


}


/// @nodoc
mixin _$MenuGroup {

 String get id; String get name; String? get imageUrl; int get type; int get groupType; bool get isRequired; int get min; int get max; List<MenuGroupItem> get items;
/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuGroupCopyWith<MenuGroup> get copyWith => _$MenuGroupCopyWithImpl<MenuGroup>(this as MenuGroup, _$identity);

  /// Serializes this MenuGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.groupType, groupType) || other.groupType == groupType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,type,groupType,isRequired,min,max,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MenuGroup(id: $id, name: $name, imageUrl: $imageUrl, type: $type, groupType: $groupType, isRequired: $isRequired, min: $min, max: $max, items: $items)';
}


}

/// @nodoc
abstract mixin class $MenuGroupCopyWith<$Res>  {
  factory $MenuGroupCopyWith(MenuGroup value, $Res Function(MenuGroup) _then) = _$MenuGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? imageUrl, int type, int groupType, bool isRequired, int min, int max, List<MenuGroupItem> items
});




}
/// @nodoc
class _$MenuGroupCopyWithImpl<$Res>
    implements $MenuGroupCopyWith<$Res> {
  _$MenuGroupCopyWithImpl(this._self, this._then);

  final MenuGroup _self;
  final $Res Function(MenuGroup) _then;

/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? type = null,Object? groupType = null,Object? isRequired = null,Object? min = null,Object? max = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MenuGroupItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuGroup].
extension MenuGroupPatterns on MenuGroup {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuGroup value)  $default,){
final _that = this;
switch (_that) {
case _MenuGroup():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl,  int type,  int groupType,  bool isRequired,  int min,  int max,  List<MenuGroupItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.type,_that.groupType,_that.isRequired,_that.min,_that.max,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl,  int type,  int groupType,  bool isRequired,  int min,  int max,  List<MenuGroupItem> items)  $default,) {final _that = this;
switch (_that) {
case _MenuGroup():
return $default(_that.id,_that.name,_that.imageUrl,_that.type,_that.groupType,_that.isRequired,_that.min,_that.max,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? imageUrl,  int type,  int groupType,  bool isRequired,  int min,  int max,  List<MenuGroupItem> items)?  $default,) {final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.type,_that.groupType,_that.isRequired,_that.min,_that.max,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuGroup implements MenuGroup {
  const _MenuGroup({required this.id, required this.name, this.imageUrl, this.type = 0, this.groupType = 0, this.isRequired = false, this.min = 0, this.max = 0, final  List<MenuGroupItem> items = const []}): _items = items;
  factory _MenuGroup.fromJson(Map<String, dynamic> json) => _$MenuGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? imageUrl;
@override@JsonKey() final  int type;
@override@JsonKey() final  int groupType;
@override@JsonKey() final  bool isRequired;
@override@JsonKey() final  int min;
@override@JsonKey() final  int max;
 final  List<MenuGroupItem> _items;
@override@JsonKey() List<MenuGroupItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuGroupCopyWith<_MenuGroup> get copyWith => __$MenuGroupCopyWithImpl<_MenuGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.groupType, groupType) || other.groupType == groupType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,type,groupType,isRequired,min,max,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MenuGroup(id: $id, name: $name, imageUrl: $imageUrl, type: $type, groupType: $groupType, isRequired: $isRequired, min: $min, max: $max, items: $items)';
}


}

/// @nodoc
abstract mixin class _$MenuGroupCopyWith<$Res> implements $MenuGroupCopyWith<$Res> {
  factory _$MenuGroupCopyWith(_MenuGroup value, $Res Function(_MenuGroup) _then) = __$MenuGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? imageUrl, int type, int groupType, bool isRequired, int min, int max, List<MenuGroupItem> items
});




}
/// @nodoc
class __$MenuGroupCopyWithImpl<$Res>
    implements _$MenuGroupCopyWith<$Res> {
  __$MenuGroupCopyWithImpl(this._self, this._then);

  final _MenuGroup _self;
  final $Res Function(_MenuGroup) _then;

/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? type = null,Object? groupType = null,Object? isRequired = null,Object? min = null,Object? max = null,Object? items = null,}) {
  return _then(_MenuGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MenuGroupItem>,
  ));
}


}

// dart format on
