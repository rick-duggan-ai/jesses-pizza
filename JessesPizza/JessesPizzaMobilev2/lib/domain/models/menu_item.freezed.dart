// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MenuItem {

 String? get id; String? get name; String? get imageUrl; String? get description; List<MenuItemSize> get sizes;
/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemCopyWith<MenuItem> get copyWith => _$MenuItemCopyWithImpl<MenuItem>(this as MenuItem, _$identity);

  /// Serializes this MenuItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.sizes, sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,description,const DeepCollectionEquality().hash(sizes));

@override
String toString() {
  return 'MenuItem(id: $id, name: $name, imageUrl: $imageUrl, description: $description, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class $MenuItemCopyWith<$Res>  {
  factory $MenuItemCopyWith(MenuItem value, $Res Function(MenuItem) _then) = _$MenuItemCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? imageUrl, String? description, List<MenuItemSize> sizes
});




}
/// @nodoc
class _$MenuItemCopyWithImpl<$Res>
    implements $MenuItemCopyWith<$Res> {
  _$MenuItemCopyWithImpl(this._self, this._then);

  final MenuItem _self;
  final $Res Function(MenuItem) _then;

/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? imageUrl = freezed,Object? description = freezed,Object? sizes = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MenuItemSize>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItem].
extension MenuItemPatterns on MenuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItem value)  $default,){
final _that = this;
switch (_that) {
case _MenuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItem value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? imageUrl,  String? description,  List<MenuItemSize> sizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.description,_that.sizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? imageUrl,  String? description,  List<MenuItemSize> sizes)  $default,) {final _that = this;
switch (_that) {
case _MenuItem():
return $default(_that.id,_that.name,_that.imageUrl,_that.description,_that.sizes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? imageUrl,  String? description,  List<MenuItemSize> sizes)?  $default,) {final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.description,_that.sizes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuItem implements MenuItem {
  const _MenuItem({this.id, this.name, this.imageUrl, this.description, final  List<MenuItemSize> sizes = const []}): _sizes = sizes;
  factory _MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? imageUrl;
@override final  String? description;
 final  List<MenuItemSize> _sizes;
@override@JsonKey() List<MenuItemSize> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}


/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemCopyWith<_MenuItem> get copyWith => __$MenuItemCopyWithImpl<_MenuItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._sizes, _sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,description,const DeepCollectionEquality().hash(_sizes));

@override
String toString() {
  return 'MenuItem(id: $id, name: $name, imageUrl: $imageUrl, description: $description, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class _$MenuItemCopyWith<$Res> implements $MenuItemCopyWith<$Res> {
  factory _$MenuItemCopyWith(_MenuItem value, $Res Function(_MenuItem) _then) = __$MenuItemCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? imageUrl, String? description, List<MenuItemSize> sizes
});




}
/// @nodoc
class __$MenuItemCopyWithImpl<$Res>
    implements _$MenuItemCopyWith<$Res> {
  __$MenuItemCopyWithImpl(this._self, this._then);

  final _MenuItem _self;
  final $Res Function(_MenuItem) _then;

/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? imageUrl = freezed,Object? description = freezed,Object? sizes = null,}) {
  return _then(_MenuItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MenuItemSize>,
  ));
}


}


/// @nodoc
mixin _$MenuItemSize {

 String? get id; String get name; double get price; bool get isDefault; List<String> get groupIds;
/// Create a copy of MenuItemSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemSizeCopyWith<MenuItemSize> get copyWith => _$MenuItemSizeCopyWithImpl<MenuItemSize>(this as MenuItemSize, _$identity);

  /// Serializes this MenuItemSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItemSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&const DeepCollectionEquality().equals(other.groupIds, groupIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,isDefault,const DeepCollectionEquality().hash(groupIds));

@override
String toString() {
  return 'MenuItemSize(id: $id, name: $name, price: $price, isDefault: $isDefault, groupIds: $groupIds)';
}


}

/// @nodoc
abstract mixin class $MenuItemSizeCopyWith<$Res>  {
  factory $MenuItemSizeCopyWith(MenuItemSize value, $Res Function(MenuItemSize) _then) = _$MenuItemSizeCopyWithImpl;
@useResult
$Res call({
 String? id, String name, double price, bool isDefault, List<String> groupIds
});




}
/// @nodoc
class _$MenuItemSizeCopyWithImpl<$Res>
    implements $MenuItemSizeCopyWith<$Res> {
  _$MenuItemSizeCopyWithImpl(this._self, this._then);

  final MenuItemSize _self;
  final $Res Function(MenuItemSize) _then;

/// Create a copy of MenuItemSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? isDefault = null,Object? groupIds = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,groupIds: null == groupIds ? _self.groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItemSize].
extension MenuItemSizePatterns on MenuItemSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItemSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItemSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItemSize value)  $default,){
final _that = this;
switch (_that) {
case _MenuItemSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItemSize value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItemSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  double price,  bool isDefault,  List<String> groupIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItemSize() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isDefault,_that.groupIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  double price,  bool isDefault,  List<String> groupIds)  $default,) {final _that = this;
switch (_that) {
case _MenuItemSize():
return $default(_that.id,_that.name,_that.price,_that.isDefault,_that.groupIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  double price,  bool isDefault,  List<String> groupIds)?  $default,) {final _that = this;
switch (_that) {
case _MenuItemSize() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isDefault,_that.groupIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuItemSize implements MenuItemSize {
  const _MenuItemSize({this.id, required this.name, required this.price, this.isDefault = false, final  List<String> groupIds = const []}): _groupIds = groupIds;
  factory _MenuItemSize.fromJson(Map<String, dynamic> json) => _$MenuItemSizeFromJson(json);

@override final  String? id;
@override final  String name;
@override final  double price;
@override@JsonKey() final  bool isDefault;
 final  List<String> _groupIds;
@override@JsonKey() List<String> get groupIds {
  if (_groupIds is EqualUnmodifiableListView) return _groupIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupIds);
}


/// Create a copy of MenuItemSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemSizeCopyWith<_MenuItemSize> get copyWith => __$MenuItemSizeCopyWithImpl<_MenuItemSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuItemSizeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItemSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&const DeepCollectionEquality().equals(other._groupIds, _groupIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,isDefault,const DeepCollectionEquality().hash(_groupIds));

@override
String toString() {
  return 'MenuItemSize(id: $id, name: $name, price: $price, isDefault: $isDefault, groupIds: $groupIds)';
}


}

/// @nodoc
abstract mixin class _$MenuItemSizeCopyWith<$Res> implements $MenuItemSizeCopyWith<$Res> {
  factory _$MenuItemSizeCopyWith(_MenuItemSize value, $Res Function(_MenuItemSize) _then) = __$MenuItemSizeCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, double price, bool isDefault, List<String> groupIds
});




}
/// @nodoc
class __$MenuItemSizeCopyWithImpl<$Res>
    implements _$MenuItemSizeCopyWith<$Res> {
  __$MenuItemSizeCopyWithImpl(this._self, this._then);

  final _MenuItemSize _self;
  final $Res Function(_MenuItemSize) _then;

/// Create a copy of MenuItemSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? isDefault = null,Object? groupIds = null,}) {
  return _then(_MenuItemSize(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,groupIds: null == groupIds ? _self._groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
