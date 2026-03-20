// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreSettings {

 String? get id; double get taxRate; double get deliveryCharge; double get minimumOrderAmount; List<StoreHours> get storeHours; List<ZipCode> get zipCodes; String? get aboutText;
/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSettingsCopyWith<StoreSettings> get copyWith => _$StoreSettingsCopyWithImpl<StoreSettings>(this as StoreSettings, _$identity);

  /// Serializes this StoreSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.deliveryCharge, deliveryCharge) || other.deliveryCharge == deliveryCharge)&&(identical(other.minimumOrderAmount, minimumOrderAmount) || other.minimumOrderAmount == minimumOrderAmount)&&const DeepCollectionEquality().equals(other.storeHours, storeHours)&&const DeepCollectionEquality().equals(other.zipCodes, zipCodes)&&(identical(other.aboutText, aboutText) || other.aboutText == aboutText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taxRate,deliveryCharge,minimumOrderAmount,const DeepCollectionEquality().hash(storeHours),const DeepCollectionEquality().hash(zipCodes),aboutText);

@override
String toString() {
  return 'StoreSettings(id: $id, taxRate: $taxRate, deliveryCharge: $deliveryCharge, minimumOrderAmount: $minimumOrderAmount, storeHours: $storeHours, zipCodes: $zipCodes, aboutText: $aboutText)';
}


}

/// @nodoc
abstract mixin class $StoreSettingsCopyWith<$Res>  {
  factory $StoreSettingsCopyWith(StoreSettings value, $Res Function(StoreSettings) _then) = _$StoreSettingsCopyWithImpl;
@useResult
$Res call({
 String? id, double taxRate, double deliveryCharge, double minimumOrderAmount, List<StoreHours> storeHours, List<ZipCode> zipCodes, String? aboutText
});




}
/// @nodoc
class _$StoreSettingsCopyWithImpl<$Res>
    implements $StoreSettingsCopyWith<$Res> {
  _$StoreSettingsCopyWithImpl(this._self, this._then);

  final StoreSettings _self;
  final $Res Function(StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? taxRate = null,Object? deliveryCharge = null,Object? minimumOrderAmount = null,Object? storeHours = null,Object? zipCodes = null,Object? aboutText = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,deliveryCharge: null == deliveryCharge ? _self.deliveryCharge : deliveryCharge // ignore: cast_nullable_to_non_nullable
as double,minimumOrderAmount: null == minimumOrderAmount ? _self.minimumOrderAmount : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
as double,storeHours: null == storeHours ? _self.storeHours : storeHours // ignore: cast_nullable_to_non_nullable
as List<StoreHours>,zipCodes: null == zipCodes ? _self.zipCodes : zipCodes // ignore: cast_nullable_to_non_nullable
as List<ZipCode>,aboutText: freezed == aboutText ? _self.aboutText : aboutText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSettings].
extension StoreSettingsPatterns on StoreSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSettings value)  $default,){
final _that = this;
switch (_that) {
case _StoreSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  double taxRate,  double deliveryCharge,  double minimumOrderAmount,  List<StoreHours> storeHours,  List<ZipCode> zipCodes,  String? aboutText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.id,_that.taxRate,_that.deliveryCharge,_that.minimumOrderAmount,_that.storeHours,_that.zipCodes,_that.aboutText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  double taxRate,  double deliveryCharge,  double minimumOrderAmount,  List<StoreHours> storeHours,  List<ZipCode> zipCodes,  String? aboutText)  $default,) {final _that = this;
switch (_that) {
case _StoreSettings():
return $default(_that.id,_that.taxRate,_that.deliveryCharge,_that.minimumOrderAmount,_that.storeHours,_that.zipCodes,_that.aboutText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  double taxRate,  double deliveryCharge,  double minimumOrderAmount,  List<StoreHours> storeHours,  List<ZipCode> zipCodes,  String? aboutText)?  $default,) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.id,_that.taxRate,_that.deliveryCharge,_that.minimumOrderAmount,_that.storeHours,_that.zipCodes,_that.aboutText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreSettings extends StoreSettings {
  const _StoreSettings({this.id, this.taxRate = 8.0, this.deliveryCharge = 3.99, this.minimumOrderAmount = 0.0, final  List<StoreHours> storeHours = const [], final  List<ZipCode> zipCodes = const [], this.aboutText}): _storeHours = storeHours,_zipCodes = zipCodes,super._();
  factory _StoreSettings.fromJson(Map<String, dynamic> json) => _$StoreSettingsFromJson(json);

@override final  String? id;
@override@JsonKey() final  double taxRate;
@override@JsonKey() final  double deliveryCharge;
@override@JsonKey() final  double minimumOrderAmount;
 final  List<StoreHours> _storeHours;
@override@JsonKey() List<StoreHours> get storeHours {
  if (_storeHours is EqualUnmodifiableListView) return _storeHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_storeHours);
}

 final  List<ZipCode> _zipCodes;
@override@JsonKey() List<ZipCode> get zipCodes {
  if (_zipCodes is EqualUnmodifiableListView) return _zipCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_zipCodes);
}

@override final  String? aboutText;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSettingsCopyWith<_StoreSettings> get copyWith => __$StoreSettingsCopyWithImpl<_StoreSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.deliveryCharge, deliveryCharge) || other.deliveryCharge == deliveryCharge)&&(identical(other.minimumOrderAmount, minimumOrderAmount) || other.minimumOrderAmount == minimumOrderAmount)&&const DeepCollectionEquality().equals(other._storeHours, _storeHours)&&const DeepCollectionEquality().equals(other._zipCodes, _zipCodes)&&(identical(other.aboutText, aboutText) || other.aboutText == aboutText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taxRate,deliveryCharge,minimumOrderAmount,const DeepCollectionEquality().hash(_storeHours),const DeepCollectionEquality().hash(_zipCodes),aboutText);

@override
String toString() {
  return 'StoreSettings(id: $id, taxRate: $taxRate, deliveryCharge: $deliveryCharge, minimumOrderAmount: $minimumOrderAmount, storeHours: $storeHours, zipCodes: $zipCodes, aboutText: $aboutText)';
}


}

/// @nodoc
abstract mixin class _$StoreSettingsCopyWith<$Res> implements $StoreSettingsCopyWith<$Res> {
  factory _$StoreSettingsCopyWith(_StoreSettings value, $Res Function(_StoreSettings) _then) = __$StoreSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? id, double taxRate, double deliveryCharge, double minimumOrderAmount, List<StoreHours> storeHours, List<ZipCode> zipCodes, String? aboutText
});




}
/// @nodoc
class __$StoreSettingsCopyWithImpl<$Res>
    implements _$StoreSettingsCopyWith<$Res> {
  __$StoreSettingsCopyWithImpl(this._self, this._then);

  final _StoreSettings _self;
  final $Res Function(_StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? taxRate = null,Object? deliveryCharge = null,Object? minimumOrderAmount = null,Object? storeHours = null,Object? zipCodes = null,Object? aboutText = freezed,}) {
  return _then(_StoreSettings(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,deliveryCharge: null == deliveryCharge ? _self.deliveryCharge : deliveryCharge // ignore: cast_nullable_to_non_nullable
as double,minimumOrderAmount: null == minimumOrderAmount ? _self.minimumOrderAmount : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
as double,storeHours: null == storeHours ? _self._storeHours : storeHours // ignore: cast_nullable_to_non_nullable
as List<StoreHours>,zipCodes: null == zipCodes ? _self._zipCodes : zipCodes // ignore: cast_nullable_to_non_nullable
as List<ZipCode>,aboutText: freezed == aboutText ? _self.aboutText : aboutText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StoreHours {

 int get day; String? get openingTime; String? get closingTime;
/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreHoursCopyWith<StoreHours> get copyWith => _$StoreHoursCopyWithImpl<StoreHours>(this as StoreHours, _$identity);

  /// Serializes this StoreHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreHours&&(identical(other.day, day) || other.day == day)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,openingTime,closingTime);

@override
String toString() {
  return 'StoreHours(day: $day, openingTime: $openingTime, closingTime: $closingTime)';
}


}

/// @nodoc
abstract mixin class $StoreHoursCopyWith<$Res>  {
  factory $StoreHoursCopyWith(StoreHours value, $Res Function(StoreHours) _then) = _$StoreHoursCopyWithImpl;
@useResult
$Res call({
 int day, String? openingTime, String? closingTime
});




}
/// @nodoc
class _$StoreHoursCopyWithImpl<$Res>
    implements $StoreHoursCopyWith<$Res> {
  _$StoreHoursCopyWithImpl(this._self, this._then);

  final StoreHours _self;
  final $Res Function(StoreHours) _then;

/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? openingTime = freezed,Object? closingTime = freezed,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreHours].
extension StoreHoursPatterns on StoreHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreHours value)  $default,){
final _that = this;
switch (_that) {
case _StoreHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreHours value)?  $default,){
final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  String? openingTime,  String? closingTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
return $default(_that.day,_that.openingTime,_that.closingTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  String? openingTime,  String? closingTime)  $default,) {final _that = this;
switch (_that) {
case _StoreHours():
return $default(_that.day,_that.openingTime,_that.closingTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  String? openingTime,  String? closingTime)?  $default,) {final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
return $default(_that.day,_that.openingTime,_that.closingTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreHours implements StoreHours {
  const _StoreHours({this.day = 0, this.openingTime, this.closingTime});
  factory _StoreHours.fromJson(Map<String, dynamic> json) => _$StoreHoursFromJson(json);

@override@JsonKey() final  int day;
@override final  String? openingTime;
@override final  String? closingTime;

/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreHoursCopyWith<_StoreHours> get copyWith => __$StoreHoursCopyWithImpl<_StoreHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreHours&&(identical(other.day, day) || other.day == day)&&(identical(other.openingTime, openingTime) || other.openingTime == openingTime)&&(identical(other.closingTime, closingTime) || other.closingTime == closingTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,openingTime,closingTime);

@override
String toString() {
  return 'StoreHours(day: $day, openingTime: $openingTime, closingTime: $closingTime)';
}


}

/// @nodoc
abstract mixin class _$StoreHoursCopyWith<$Res> implements $StoreHoursCopyWith<$Res> {
  factory _$StoreHoursCopyWith(_StoreHours value, $Res Function(_StoreHours) _then) = __$StoreHoursCopyWithImpl;
@override @useResult
$Res call({
 int day, String? openingTime, String? closingTime
});




}
/// @nodoc
class __$StoreHoursCopyWithImpl<$Res>
    implements _$StoreHoursCopyWith<$Res> {
  __$StoreHoursCopyWithImpl(this._self, this._then);

  final _StoreHours _self;
  final $Res Function(_StoreHours) _then;

/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? openingTime = freezed,Object? closingTime = freezed,}) {
  return _then(_StoreHours(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,openingTime: freezed == openingTime ? _self.openingTime : openingTime // ignore: cast_nullable_to_non_nullable
as String?,closingTime: freezed == closingTime ? _self.closingTime : closingTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ZipCode {

 String? get zipCodeValue;
/// Create a copy of ZipCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZipCodeCopyWith<ZipCode> get copyWith => _$ZipCodeCopyWithImpl<ZipCode>(this as ZipCode, _$identity);

  /// Serializes this ZipCode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZipCode&&(identical(other.zipCodeValue, zipCodeValue) || other.zipCodeValue == zipCodeValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,zipCodeValue);

@override
String toString() {
  return 'ZipCode(zipCodeValue: $zipCodeValue)';
}


}

/// @nodoc
abstract mixin class $ZipCodeCopyWith<$Res>  {
  factory $ZipCodeCopyWith(ZipCode value, $Res Function(ZipCode) _then) = _$ZipCodeCopyWithImpl;
@useResult
$Res call({
 String? zipCodeValue
});




}
/// @nodoc
class _$ZipCodeCopyWithImpl<$Res>
    implements $ZipCodeCopyWith<$Res> {
  _$ZipCodeCopyWithImpl(this._self, this._then);

  final ZipCode _self;
  final $Res Function(ZipCode) _then;

/// Create a copy of ZipCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zipCodeValue = freezed,}) {
  return _then(_self.copyWith(
zipCodeValue: freezed == zipCodeValue ? _self.zipCodeValue : zipCodeValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ZipCode].
extension ZipCodePatterns on ZipCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZipCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZipCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZipCode value)  $default,){
final _that = this;
switch (_that) {
case _ZipCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZipCode value)?  $default,){
final _that = this;
switch (_that) {
case _ZipCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? zipCodeValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZipCode() when $default != null:
return $default(_that.zipCodeValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? zipCodeValue)  $default,) {final _that = this;
switch (_that) {
case _ZipCode():
return $default(_that.zipCodeValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? zipCodeValue)?  $default,) {final _that = this;
switch (_that) {
case _ZipCode() when $default != null:
return $default(_that.zipCodeValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZipCode implements ZipCode {
  const _ZipCode({this.zipCodeValue});
  factory _ZipCode.fromJson(Map<String, dynamic> json) => _$ZipCodeFromJson(json);

@override final  String? zipCodeValue;

/// Create a copy of ZipCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZipCodeCopyWith<_ZipCode> get copyWith => __$ZipCodeCopyWithImpl<_ZipCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZipCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZipCode&&(identical(other.zipCodeValue, zipCodeValue) || other.zipCodeValue == zipCodeValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,zipCodeValue);

@override
String toString() {
  return 'ZipCode(zipCodeValue: $zipCodeValue)';
}


}

/// @nodoc
abstract mixin class _$ZipCodeCopyWith<$Res> implements $ZipCodeCopyWith<$Res> {
  factory _$ZipCodeCopyWith(_ZipCode value, $Res Function(_ZipCode) _then) = __$ZipCodeCopyWithImpl;
@override @useResult
$Res call({
 String? zipCodeValue
});




}
/// @nodoc
class __$ZipCodeCopyWithImpl<$Res>
    implements _$ZipCodeCopyWith<$Res> {
  __$ZipCodeCopyWithImpl(this._self, this._then);

  final _ZipCode _self;
  final $Res Function(_ZipCode) _then;

/// Create a copy of ZipCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zipCodeValue = freezed,}) {
  return _then(_ZipCode(
zipCodeValue: freezed == zipCodeValue ? _self.zipCodeValue : zipCodeValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
