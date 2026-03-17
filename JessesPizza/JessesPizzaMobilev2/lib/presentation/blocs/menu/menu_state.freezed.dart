// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MenuState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MenuState()';
}


}

/// @nodoc
class $MenuStateCopyWith<$Res>  {
$MenuStateCopyWith(MenuState _, $Res Function(MenuState) __);
}


/// Adds pattern-matching-related methods to [MenuState].
extension MenuStatePatterns on MenuState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MenuInitial value)?  initial,TResult Function( MenuLoading value)?  loading,TResult Function( MenuLoaded value)?  loaded,TResult Function( MenuError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MenuInitial() when initial != null:
return initial(_that);case MenuLoading() when loading != null:
return loading(_that);case MenuLoaded() when loaded != null:
return loaded(_that);case MenuError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MenuInitial value)  initial,required TResult Function( MenuLoading value)  loading,required TResult Function( MenuLoaded value)  loaded,required TResult Function( MenuError value)  error,}){
final _that = this;
switch (_that) {
case MenuInitial():
return initial(_that);case MenuLoading():
return loading(_that);case MenuLoaded():
return loaded(_that);case MenuError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MenuInitial value)?  initial,TResult? Function( MenuLoading value)?  loading,TResult? Function( MenuLoaded value)?  loaded,TResult? Function( MenuError value)?  error,}){
final _that = this;
switch (_that) {
case MenuInitial() when initial != null:
return initial(_that);case MenuLoading() when loading != null:
return loading(_that);case MenuLoaded() when loaded != null:
return loaded(_that);case MenuError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MenuGroup> groups,  List<MenuItem> items,  bool isStoreOpen)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MenuInitial() when initial != null:
return initial();case MenuLoading() when loading != null:
return loading();case MenuLoaded() when loaded != null:
return loaded(_that.groups,_that.items,_that.isStoreOpen);case MenuError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MenuGroup> groups,  List<MenuItem> items,  bool isStoreOpen)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case MenuInitial():
return initial();case MenuLoading():
return loading();case MenuLoaded():
return loaded(_that.groups,_that.items,_that.isStoreOpen);case MenuError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MenuGroup> groups,  List<MenuItem> items,  bool isStoreOpen)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case MenuInitial() when initial != null:
return initial();case MenuLoading() when loading != null:
return loading();case MenuLoaded() when loaded != null:
return loaded(_that.groups,_that.items,_that.isStoreOpen);case MenuError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class MenuInitial implements MenuState {
  const MenuInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MenuState.initial()';
}


}




/// @nodoc


class MenuLoading implements MenuState {
  const MenuLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MenuState.loading()';
}


}




/// @nodoc


class MenuLoaded implements MenuState {
  const MenuLoaded({required final  List<MenuGroup> groups, required final  List<MenuItem> items, required this.isStoreOpen}): _groups = groups,_items = items;
  

 final  List<MenuGroup> _groups;
 List<MenuGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<MenuItem> _items;
 List<MenuItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool isStoreOpen;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuLoadedCopyWith<MenuLoaded> get copyWith => _$MenuLoadedCopyWithImpl<MenuLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuLoaded&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isStoreOpen, isStoreOpen) || other.isStoreOpen == isStoreOpen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_items),isStoreOpen);

@override
String toString() {
  return 'MenuState.loaded(groups: $groups, items: $items, isStoreOpen: $isStoreOpen)';
}


}

/// @nodoc
abstract mixin class $MenuLoadedCopyWith<$Res> implements $MenuStateCopyWith<$Res> {
  factory $MenuLoadedCopyWith(MenuLoaded value, $Res Function(MenuLoaded) _then) = _$MenuLoadedCopyWithImpl;
@useResult
$Res call({
 List<MenuGroup> groups, List<MenuItem> items, bool isStoreOpen
});




}
/// @nodoc
class _$MenuLoadedCopyWithImpl<$Res>
    implements $MenuLoadedCopyWith<$Res> {
  _$MenuLoadedCopyWithImpl(this._self, this._then);

  final MenuLoaded _self;
  final $Res Function(MenuLoaded) _then;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? items = null,Object? isStoreOpen = null,}) {
  return _then(MenuLoaded(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<MenuGroup>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MenuItem>,isStoreOpen: null == isStoreOpen ? _self.isStoreOpen : isStoreOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MenuError implements MenuState {
  const MenuError({required this.message});
  

 final  String message;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuErrorCopyWith<MenuError> get copyWith => _$MenuErrorCopyWithImpl<MenuError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MenuState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $MenuErrorCopyWith<$Res> implements $MenuStateCopyWith<$Res> {
  factory $MenuErrorCopyWith(MenuError value, $Res Function(MenuError) _then) = _$MenuErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MenuErrorCopyWithImpl<$Res>
    implements $MenuErrorCopyWith<$Res> {
  _$MenuErrorCopyWithImpl(this._self, this._then);

  final MenuError _self;
  final $Res Function(MenuError) _then;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MenuError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
