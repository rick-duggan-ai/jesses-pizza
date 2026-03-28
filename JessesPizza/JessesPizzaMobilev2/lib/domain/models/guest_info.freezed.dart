// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuestInfo {

 String get firstName; String get lastName; String get email; String get phoneNumber; String get addressLine1; String get city; String get zipCode;
/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestInfoCopyWith<GuestInfo> get copyWith => _$GuestInfoCopyWithImpl<GuestInfo>(this as GuestInfo, _$identity);

  /// Serializes this GuestInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestInfo&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phoneNumber,addressLine1,city,zipCode);

@override
String toString() {
  return 'GuestInfo(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, addressLine1: $addressLine1, city: $city, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class $GuestInfoCopyWith<$Res>  {
  factory $GuestInfoCopyWith(GuestInfo value, $Res Function(GuestInfo) _then) = _$GuestInfoCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String email, String phoneNumber, String addressLine1, String city, String zipCode
});




}
/// @nodoc
class _$GuestInfoCopyWithImpl<$Res>
    implements $GuestInfoCopyWith<$Res> {
  _$GuestInfoCopyWithImpl(this._self, this._then);

  final GuestInfo _self;
  final $Res Function(GuestInfo) _then;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? phoneNumber = null,Object? addressLine1 = null,Object? city = null,Object? zipCode = null,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GuestInfo].
extension GuestInfoPatterns on GuestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuestInfo value)  $default,){
final _that = this;
switch (_that) {
case _GuestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  String phoneNumber,  String addressLine1,  String city,  String zipCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phoneNumber,_that.addressLine1,_that.city,_that.zipCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  String phoneNumber,  String addressLine1,  String city,  String zipCode)  $default,) {final _that = this;
switch (_that) {
case _GuestInfo():
return $default(_that.firstName,_that.lastName,_that.email,_that.phoneNumber,_that.addressLine1,_that.city,_that.zipCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String email,  String phoneNumber,  String addressLine1,  String city,  String zipCode)?  $default,) {final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phoneNumber,_that.addressLine1,_that.city,_that.zipCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuestInfo implements GuestInfo {
  const _GuestInfo({required this.firstName, required this.lastName, required this.email, required this.phoneNumber, required this.addressLine1, required this.city, required this.zipCode});
  factory _GuestInfo.fromJson(Map<String, dynamic> json) => _$GuestInfoFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  String phoneNumber;
@override final  String addressLine1;
@override final  String city;
@override final  String zipCode;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestInfoCopyWith<_GuestInfo> get copyWith => __$GuestInfoCopyWithImpl<_GuestInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuestInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuestInfo&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phoneNumber,addressLine1,city,zipCode);

@override
String toString() {
  return 'GuestInfo(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, addressLine1: $addressLine1, city: $city, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class _$GuestInfoCopyWith<$Res> implements $GuestInfoCopyWith<$Res> {
  factory _$GuestInfoCopyWith(_GuestInfo value, $Res Function(_GuestInfo) _then) = __$GuestInfoCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String email, String phoneNumber, String addressLine1, String city, String zipCode
});




}
/// @nodoc
class __$GuestInfoCopyWithImpl<$Res>
    implements _$GuestInfoCopyWith<$Res> {
  __$GuestInfoCopyWithImpl(this._self, this._then);

  final _GuestInfo _self;
  final $Res Function(_GuestInfo) _then;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? phoneNumber = null,Object? addressLine1 = null,Object? city = null,Object? zipCode = null,}) {
  return _then(_GuestInfo(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
