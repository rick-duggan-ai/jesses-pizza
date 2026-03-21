// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get token; DateTime get tokenExpires; bool get isGuest; String? get email; String? get firstName;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.token, token) || other.token == token)&&(identical(other.tokenExpires, tokenExpires) || other.tokenExpires == tokenExpires)&&(identical(other.isGuest, isGuest) || other.isGuest == isGuest)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,tokenExpires,isGuest,email,firstName);

@override
String toString() {
  return 'User(token: $token, tokenExpires: $tokenExpires, isGuest: $isGuest, email: $email, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String token, DateTime tokenExpires, bool isGuest, String? email, String? firstName
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? tokenExpires = null,Object? isGuest = null,Object? email = freezed,Object? firstName = freezed,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,tokenExpires: null == tokenExpires ? _self.tokenExpires : tokenExpires // ignore: cast_nullable_to_non_nullable
as DateTime,isGuest: null == isGuest ? _self.isGuest : isGuest // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  DateTime tokenExpires,  bool isGuest,  String? email,  String? firstName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.token,_that.tokenExpires,_that.isGuest,_that.email,_that.firstName);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  DateTime tokenExpires,  bool isGuest,  String? email,  String? firstName)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.token,_that.tokenExpires,_that.isGuest,_that.email,_that.firstName);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  DateTime tokenExpires,  bool isGuest,  String? email,  String? firstName)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.token,_that.tokenExpires,_that.isGuest,_that.email,_that.firstName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.token, required this.tokenExpires, required this.isGuest, this.email, this.firstName});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String token;
@override final  DateTime tokenExpires;
@override final  bool isGuest;
@override final  String? email;
@override final  String? firstName;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.token, token) || other.token == token)&&(identical(other.tokenExpires, tokenExpires) || other.tokenExpires == tokenExpires)&&(identical(other.isGuest, isGuest) || other.isGuest == isGuest)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,tokenExpires,isGuest,email,firstName);

@override
String toString() {
  return 'User(token: $token, tokenExpires: $tokenExpires, isGuest: $isGuest, email: $email, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String token, DateTime tokenExpires, bool isGuest, String? email, String? firstName
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? tokenExpires = null,Object? isGuest = null,Object? email = freezed,Object? firstName = freezed,}) {
  return _then(_User(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,tokenExpires: null == tokenExpires ? _self.tokenExpires : tokenExpires // ignore: cast_nullable_to_non_nullable
as DateTime,isGuest: null == isGuest ? _self.isGuest : isGuest // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
