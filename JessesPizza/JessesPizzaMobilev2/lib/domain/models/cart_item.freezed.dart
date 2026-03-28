// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartItem {

 String get menuItemId; String get name; String? get description; String get sizeName; String? get selectedSizeId; String? get imageUrl; double get price; int get quantity; List<SelectedGroupItem> get selectedGroupItems; String get specialInstructions; bool get requiredChoicesEnabled; String? get requiredChoices; String? get requiredDelimitedString; bool get optionalChoicesEnabled; String? get optionalChoices; String? get optionalDelimitedString; bool get instructionsEnabled; String? get instructions;
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemCopyWith<CartItem> get copyWith => _$CartItemCopyWithImpl<CartItem>(this as CartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItem&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.selectedSizeId, selectedSizeId) || other.selectedSizeId == selectedSizeId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.selectedGroupItems, selectedGroupItems)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.requiredChoicesEnabled, requiredChoicesEnabled) || other.requiredChoicesEnabled == requiredChoicesEnabled)&&(identical(other.requiredChoices, requiredChoices) || other.requiredChoices == requiredChoices)&&(identical(other.requiredDelimitedString, requiredDelimitedString) || other.requiredDelimitedString == requiredDelimitedString)&&(identical(other.optionalChoicesEnabled, optionalChoicesEnabled) || other.optionalChoicesEnabled == optionalChoicesEnabled)&&(identical(other.optionalChoices, optionalChoices) || other.optionalChoices == optionalChoices)&&(identical(other.optionalDelimitedString, optionalDelimitedString) || other.optionalDelimitedString == optionalDelimitedString)&&(identical(other.instructionsEnabled, instructionsEnabled) || other.instructionsEnabled == instructionsEnabled)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}


@override
int get hashCode => Object.hash(runtimeType,menuItemId,name,description,sizeName,selectedSizeId,imageUrl,price,quantity,const DeepCollectionEquality().hash(selectedGroupItems),specialInstructions,requiredChoicesEnabled,requiredChoices,requiredDelimitedString,optionalChoicesEnabled,optionalChoices,optionalDelimitedString,instructionsEnabled,instructions);

@override
String toString() {
  return 'CartItem(menuItemId: $menuItemId, name: $name, description: $description, sizeName: $sizeName, selectedSizeId: $selectedSizeId, imageUrl: $imageUrl, price: $price, quantity: $quantity, selectedGroupItems: $selectedGroupItems, specialInstructions: $specialInstructions, requiredChoicesEnabled: $requiredChoicesEnabled, requiredChoices: $requiredChoices, requiredDelimitedString: $requiredDelimitedString, optionalChoicesEnabled: $optionalChoicesEnabled, optionalChoices: $optionalChoices, optionalDelimitedString: $optionalDelimitedString, instructionsEnabled: $instructionsEnabled, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class $CartItemCopyWith<$Res>  {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) _then) = _$CartItemCopyWithImpl;
@useResult
$Res call({
 String menuItemId, String name, String? description, String sizeName, String? selectedSizeId, String? imageUrl, double price, int quantity, List<SelectedGroupItem> selectedGroupItems, String specialInstructions, bool requiredChoicesEnabled, String? requiredChoices, String? requiredDelimitedString, bool optionalChoicesEnabled, String? optionalChoices, String? optionalDelimitedString, bool instructionsEnabled, String? instructions
});




}
/// @nodoc
class _$CartItemCopyWithImpl<$Res>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._self, this._then);

  final CartItem _self;
  final $Res Function(CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuItemId = null,Object? name = null,Object? description = freezed,Object? sizeName = null,Object? selectedSizeId = freezed,Object? imageUrl = freezed,Object? price = null,Object? quantity = null,Object? selectedGroupItems = null,Object? specialInstructions = null,Object? requiredChoicesEnabled = null,Object? requiredChoices = freezed,Object? requiredDelimitedString = freezed,Object? optionalChoicesEnabled = null,Object? optionalChoices = freezed,Object? optionalDelimitedString = freezed,Object? instructionsEnabled = null,Object? instructions = freezed,}) {
  return _then(_self.copyWith(
menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,selectedSizeId: freezed == selectedSizeId ? _self.selectedSizeId : selectedSizeId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,selectedGroupItems: null == selectedGroupItems ? _self.selectedGroupItems : selectedGroupItems // ignore: cast_nullable_to_non_nullable
as List<SelectedGroupItem>,specialInstructions: null == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String,requiredChoicesEnabled: null == requiredChoicesEnabled ? _self.requiredChoicesEnabled : requiredChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiredChoices: freezed == requiredChoices ? _self.requiredChoices : requiredChoices // ignore: cast_nullable_to_non_nullable
as String?,requiredDelimitedString: freezed == requiredDelimitedString ? _self.requiredDelimitedString : requiredDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,optionalChoicesEnabled: null == optionalChoicesEnabled ? _self.optionalChoicesEnabled : optionalChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,optionalChoices: freezed == optionalChoices ? _self.optionalChoices : optionalChoices // ignore: cast_nullable_to_non_nullable
as String?,optionalDelimitedString: freezed == optionalDelimitedString ? _self.optionalDelimitedString : optionalDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,instructionsEnabled: null == instructionsEnabled ? _self.instructionsEnabled : instructionsEnabled // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItem].
extension CartItemPatterns on CartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItem value)  $default,){
final _that = this;
switch (_that) {
case _CartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItem value)?  $default,){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  double price,  int quantity,  List<SelectedGroupItem> selectedGroupItems,  String specialInstructions,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  bool instructionsEnabled,  String? instructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.price,_that.quantity,_that.selectedGroupItems,_that.specialInstructions,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.instructionsEnabled,_that.instructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  double price,  int quantity,  List<SelectedGroupItem> selectedGroupItems,  String specialInstructions,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  bool instructionsEnabled,  String? instructions)  $default,) {final _that = this;
switch (_that) {
case _CartItem():
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.price,_that.quantity,_that.selectedGroupItems,_that.specialInstructions,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.instructionsEnabled,_that.instructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  double price,  int quantity,  List<SelectedGroupItem> selectedGroupItems,  String specialInstructions,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  bool instructionsEnabled,  String? instructions)?  $default,) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.price,_that.quantity,_that.selectedGroupItems,_that.specialInstructions,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.instructionsEnabled,_that.instructions);case _:
  return null;

}
}

}

/// @nodoc


class _CartItem extends CartItem {
  const _CartItem({required this.menuItemId, required this.name, this.description, required this.sizeName, this.selectedSizeId, this.imageUrl, required this.price, required this.quantity, final  List<SelectedGroupItem> selectedGroupItems = const [], this.specialInstructions = '', this.requiredChoicesEnabled = false, this.requiredChoices, this.requiredDelimitedString, this.optionalChoicesEnabled = false, this.optionalChoices, this.optionalDelimitedString, this.instructionsEnabled = false, this.instructions}): _selectedGroupItems = selectedGroupItems,super._();
  

@override final  String menuItemId;
@override final  String name;
@override final  String? description;
@override final  String sizeName;
@override final  String? selectedSizeId;
@override final  String? imageUrl;
@override final  double price;
@override final  int quantity;
 final  List<SelectedGroupItem> _selectedGroupItems;
@override@JsonKey() List<SelectedGroupItem> get selectedGroupItems {
  if (_selectedGroupItems is EqualUnmodifiableListView) return _selectedGroupItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedGroupItems);
}

@override@JsonKey() final  String specialInstructions;
@override@JsonKey() final  bool requiredChoicesEnabled;
@override final  String? requiredChoices;
@override final  String? requiredDelimitedString;
@override@JsonKey() final  bool optionalChoicesEnabled;
@override final  String? optionalChoices;
@override final  String? optionalDelimitedString;
@override@JsonKey() final  bool instructionsEnabled;
@override final  String? instructions;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemCopyWith<_CartItem> get copyWith => __$CartItemCopyWithImpl<_CartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItem&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.selectedSizeId, selectedSizeId) || other.selectedSizeId == selectedSizeId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._selectedGroupItems, _selectedGroupItems)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.requiredChoicesEnabled, requiredChoicesEnabled) || other.requiredChoicesEnabled == requiredChoicesEnabled)&&(identical(other.requiredChoices, requiredChoices) || other.requiredChoices == requiredChoices)&&(identical(other.requiredDelimitedString, requiredDelimitedString) || other.requiredDelimitedString == requiredDelimitedString)&&(identical(other.optionalChoicesEnabled, optionalChoicesEnabled) || other.optionalChoicesEnabled == optionalChoicesEnabled)&&(identical(other.optionalChoices, optionalChoices) || other.optionalChoices == optionalChoices)&&(identical(other.optionalDelimitedString, optionalDelimitedString) || other.optionalDelimitedString == optionalDelimitedString)&&(identical(other.instructionsEnabled, instructionsEnabled) || other.instructionsEnabled == instructionsEnabled)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}


@override
int get hashCode => Object.hash(runtimeType,menuItemId,name,description,sizeName,selectedSizeId,imageUrl,price,quantity,const DeepCollectionEquality().hash(_selectedGroupItems),specialInstructions,requiredChoicesEnabled,requiredChoices,requiredDelimitedString,optionalChoicesEnabled,optionalChoices,optionalDelimitedString,instructionsEnabled,instructions);

@override
String toString() {
  return 'CartItem(menuItemId: $menuItemId, name: $name, description: $description, sizeName: $sizeName, selectedSizeId: $selectedSizeId, imageUrl: $imageUrl, price: $price, quantity: $quantity, selectedGroupItems: $selectedGroupItems, specialInstructions: $specialInstructions, requiredChoicesEnabled: $requiredChoicesEnabled, requiredChoices: $requiredChoices, requiredDelimitedString: $requiredDelimitedString, optionalChoicesEnabled: $optionalChoicesEnabled, optionalChoices: $optionalChoices, optionalDelimitedString: $optionalDelimitedString, instructionsEnabled: $instructionsEnabled, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class _$CartItemCopyWith<$Res> implements $CartItemCopyWith<$Res> {
  factory _$CartItemCopyWith(_CartItem value, $Res Function(_CartItem) _then) = __$CartItemCopyWithImpl;
@override @useResult
$Res call({
 String menuItemId, String name, String? description, String sizeName, String? selectedSizeId, String? imageUrl, double price, int quantity, List<SelectedGroupItem> selectedGroupItems, String specialInstructions, bool requiredChoicesEnabled, String? requiredChoices, String? requiredDelimitedString, bool optionalChoicesEnabled, String? optionalChoices, String? optionalDelimitedString, bool instructionsEnabled, String? instructions
});




}
/// @nodoc
class __$CartItemCopyWithImpl<$Res>
    implements _$CartItemCopyWith<$Res> {
  __$CartItemCopyWithImpl(this._self, this._then);

  final _CartItem _self;
  final $Res Function(_CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuItemId = null,Object? name = null,Object? description = freezed,Object? sizeName = null,Object? selectedSizeId = freezed,Object? imageUrl = freezed,Object? price = null,Object? quantity = null,Object? selectedGroupItems = null,Object? specialInstructions = null,Object? requiredChoicesEnabled = null,Object? requiredChoices = freezed,Object? requiredDelimitedString = freezed,Object? optionalChoicesEnabled = null,Object? optionalChoices = freezed,Object? optionalDelimitedString = freezed,Object? instructionsEnabled = null,Object? instructions = freezed,}) {
  return _then(_CartItem(
menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,selectedSizeId: freezed == selectedSizeId ? _self.selectedSizeId : selectedSizeId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,selectedGroupItems: null == selectedGroupItems ? _self._selectedGroupItems : selectedGroupItems // ignore: cast_nullable_to_non_nullable
as List<SelectedGroupItem>,specialInstructions: null == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String,requiredChoicesEnabled: null == requiredChoicesEnabled ? _self.requiredChoicesEnabled : requiredChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiredChoices: freezed == requiredChoices ? _self.requiredChoices : requiredChoices // ignore: cast_nullable_to_non_nullable
as String?,requiredDelimitedString: freezed == requiredDelimitedString ? _self.requiredDelimitedString : requiredDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,optionalChoicesEnabled: null == optionalChoicesEnabled ? _self.optionalChoicesEnabled : optionalChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,optionalChoices: freezed == optionalChoices ? _self.optionalChoices : optionalChoices // ignore: cast_nullable_to_non_nullable
as String?,optionalDelimitedString: freezed == optionalDelimitedString ? _self.optionalDelimitedString : optionalDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,instructionsEnabled: null == instructionsEnabled ? _self.instructionsEnabled : instructionsEnabled // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
