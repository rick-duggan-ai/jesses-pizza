// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginRequested value)?  loginRequested,TResult Function( SignUpRequested value)?  signUpRequested,TResult Function( ConfirmAccountRequested value)?  confirmAccountRequested,TResult Function( GuestLoginRequested value)?  guestLoginRequested,TResult Function( LogoutRequested value)?  logoutRequested,TResult Function( TokenExpired value)?  tokenExpired,TResult Function( DeleteAccountRequested value)?  deleteAccountRequested,TResult Function( CheckStoredAuth value)?  checkStoredAuth,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginRequested() when loginRequested != null:
return loginRequested(_that);case SignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case ConfirmAccountRequested() when confirmAccountRequested != null:
return confirmAccountRequested(_that);case GuestLoginRequested() when guestLoginRequested != null:
return guestLoginRequested(_that);case LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case TokenExpired() when tokenExpired != null:
return tokenExpired(_that);case DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case CheckStoredAuth() when checkStoredAuth != null:
return checkStoredAuth(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginRequested value)  loginRequested,required TResult Function( SignUpRequested value)  signUpRequested,required TResult Function( ConfirmAccountRequested value)  confirmAccountRequested,required TResult Function( GuestLoginRequested value)  guestLoginRequested,required TResult Function( LogoutRequested value)  logoutRequested,required TResult Function( TokenExpired value)  tokenExpired,required TResult Function( DeleteAccountRequested value)  deleteAccountRequested,required TResult Function( CheckStoredAuth value)  checkStoredAuth,}){
final _that = this;
switch (_that) {
case LoginRequested():
return loginRequested(_that);case SignUpRequested():
return signUpRequested(_that);case ConfirmAccountRequested():
return confirmAccountRequested(_that);case GuestLoginRequested():
return guestLoginRequested(_that);case LogoutRequested():
return logoutRequested(_that);case TokenExpired():
return tokenExpired(_that);case DeleteAccountRequested():
return deleteAccountRequested(_that);case CheckStoredAuth():
return checkStoredAuth(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginRequested value)?  loginRequested,TResult? Function( SignUpRequested value)?  signUpRequested,TResult? Function( ConfirmAccountRequested value)?  confirmAccountRequested,TResult? Function( GuestLoginRequested value)?  guestLoginRequested,TResult? Function( LogoutRequested value)?  logoutRequested,TResult? Function( TokenExpired value)?  tokenExpired,TResult? Function( DeleteAccountRequested value)?  deleteAccountRequested,TResult? Function( CheckStoredAuth value)?  checkStoredAuth,}){
final _that = this;
switch (_that) {
case LoginRequested() when loginRequested != null:
return loginRequested(_that);case SignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case ConfirmAccountRequested() when confirmAccountRequested != null:
return confirmAccountRequested(_that);case GuestLoginRequested() when guestLoginRequested != null:
return guestLoginRequested(_that);case LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case TokenExpired() when tokenExpired != null:
return tokenExpired(_that);case DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case CheckStoredAuth() when checkStoredAuth != null:
return checkStoredAuth(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password,  String deviceId)?  loginRequested,TResult Function( String email,  String password,  String firstName,  String lastName,  String phoneNumber)?  signUpRequested,TResult Function( String email,  String code)?  confirmAccountRequested,TResult Function( String deviceId)?  guestLoginRequested,TResult Function()?  logoutRequested,TResult Function()?  tokenExpired,TResult Function()?  deleteAccountRequested,TResult Function()?  checkStoredAuth,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password,_that.deviceId);case SignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.firstName,_that.lastName,_that.phoneNumber);case ConfirmAccountRequested() when confirmAccountRequested != null:
return confirmAccountRequested(_that.email,_that.code);case GuestLoginRequested() when guestLoginRequested != null:
return guestLoginRequested(_that.deviceId);case LogoutRequested() when logoutRequested != null:
return logoutRequested();case TokenExpired() when tokenExpired != null:
return tokenExpired();case DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case CheckStoredAuth() when checkStoredAuth != null:
return checkStoredAuth();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password,  String deviceId)  loginRequested,required TResult Function( String email,  String password,  String firstName,  String lastName,  String phoneNumber)  signUpRequested,required TResult Function( String email,  String code)  confirmAccountRequested,required TResult Function( String deviceId)  guestLoginRequested,required TResult Function()  logoutRequested,required TResult Function()  tokenExpired,required TResult Function()  deleteAccountRequested,required TResult Function()  checkStoredAuth,}) {final _that = this;
switch (_that) {
case LoginRequested():
return loginRequested(_that.email,_that.password,_that.deviceId);case SignUpRequested():
return signUpRequested(_that.email,_that.password,_that.firstName,_that.lastName,_that.phoneNumber);case ConfirmAccountRequested():
return confirmAccountRequested(_that.email,_that.code);case GuestLoginRequested():
return guestLoginRequested(_that.deviceId);case LogoutRequested():
return logoutRequested();case TokenExpired():
return tokenExpired();case DeleteAccountRequested():
return deleteAccountRequested();case CheckStoredAuth():
return checkStoredAuth();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password,  String deviceId)?  loginRequested,TResult? Function( String email,  String password,  String firstName,  String lastName,  String phoneNumber)?  signUpRequested,TResult? Function( String email,  String code)?  confirmAccountRequested,TResult? Function( String deviceId)?  guestLoginRequested,TResult? Function()?  logoutRequested,TResult? Function()?  tokenExpired,TResult? Function()?  deleteAccountRequested,TResult? Function()?  checkStoredAuth,}) {final _that = this;
switch (_that) {
case LoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password,_that.deviceId);case SignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.firstName,_that.lastName,_that.phoneNumber);case ConfirmAccountRequested() when confirmAccountRequested != null:
return confirmAccountRequested(_that.email,_that.code);case GuestLoginRequested() when guestLoginRequested != null:
return guestLoginRequested(_that.deviceId);case LogoutRequested() when logoutRequested != null:
return logoutRequested();case TokenExpired() when tokenExpired != null:
return tokenExpired();case DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case CheckStoredAuth() when checkStoredAuth != null:
return checkStoredAuth();case _:
  return null;

}
}

}

/// @nodoc


class LoginRequested implements AuthEvent {
  const LoginRequested({required this.email, required this.password, required this.deviceId});
  

 final  String email;
 final  String password;
 final  String deviceId;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestedCopyWith<LoginRequested> get copyWith => _$LoginRequestedCopyWithImpl<LoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,deviceId);

@override
String toString() {
  return 'AuthEvent.loginRequested(email: $email, password: $password, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $LoginRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $LoginRequestedCopyWith(LoginRequested value, $Res Function(LoginRequested) _then) = _$LoginRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password, String deviceId
});




}
/// @nodoc
class _$LoginRequestedCopyWithImpl<$Res>
    implements $LoginRequestedCopyWith<$Res> {
  _$LoginRequestedCopyWithImpl(this._self, this._then);

  final LoginRequested _self;
  final $Res Function(LoginRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? deviceId = null,}) {
  return _then(LoginRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignUpRequested implements AuthEvent {
  const SignUpRequested({required this.email, required this.password, required this.firstName, required this.lastName, required this.phoneNumber});
  

 final  String email;
 final  String password;
 final  String firstName;
 final  String lastName;
 final  String phoneNumber;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpRequestedCopyWith<SignUpRequested> get copyWith => _$SignUpRequestedCopyWithImpl<SignUpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,firstName,lastName,phoneNumber);

@override
String toString() {
  return 'AuthEvent.signUpRequested(email: $email, password: $password, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $SignUpRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignUpRequestedCopyWith(SignUpRequested value, $Res Function(SignUpRequested) _then) = _$SignUpRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password, String firstName, String lastName, String phoneNumber
});




}
/// @nodoc
class _$SignUpRequestedCopyWithImpl<$Res>
    implements $SignUpRequestedCopyWith<$Res> {
  _$SignUpRequestedCopyWithImpl(this._self, this._then);

  final SignUpRequested _self;
  final $Res Function(SignUpRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? firstName = null,Object? lastName = null,Object? phoneNumber = null,}) {
  return _then(SignUpRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ConfirmAccountRequested implements AuthEvent {
  const ConfirmAccountRequested({required this.email, required this.code});
  

 final  String email;
 final  String code;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmAccountRequestedCopyWith<ConfirmAccountRequested> get copyWith => _$ConfirmAccountRequestedCopyWithImpl<ConfirmAccountRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmAccountRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,email,code);

@override
String toString() {
  return 'AuthEvent.confirmAccountRequested(email: $email, code: $code)';
}


}

/// @nodoc
abstract mixin class $ConfirmAccountRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $ConfirmAccountRequestedCopyWith(ConfirmAccountRequested value, $Res Function(ConfirmAccountRequested) _then) = _$ConfirmAccountRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String code
});




}
/// @nodoc
class _$ConfirmAccountRequestedCopyWithImpl<$Res>
    implements $ConfirmAccountRequestedCopyWith<$Res> {
  _$ConfirmAccountRequestedCopyWithImpl(this._self, this._then);

  final ConfirmAccountRequested _self;
  final $Res Function(ConfirmAccountRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? code = null,}) {
  return _then(ConfirmAccountRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GuestLoginRequested implements AuthEvent {
  const GuestLoginRequested({required this.deviceId});
  

 final  String deviceId;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestLoginRequestedCopyWith<GuestLoginRequested> get copyWith => _$GuestLoginRequestedCopyWithImpl<GuestLoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestLoginRequested&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId);

@override
String toString() {
  return 'AuthEvent.guestLoginRequested(deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $GuestLoginRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $GuestLoginRequestedCopyWith(GuestLoginRequested value, $Res Function(GuestLoginRequested) _then) = _$GuestLoginRequestedCopyWithImpl;
@useResult
$Res call({
 String deviceId
});




}
/// @nodoc
class _$GuestLoginRequestedCopyWithImpl<$Res>
    implements $GuestLoginRequestedCopyWith<$Res> {
  _$GuestLoginRequestedCopyWithImpl(this._self, this._then);

  final GuestLoginRequested _self;
  final $Res Function(GuestLoginRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,}) {
  return _then(GuestLoginRequested(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LogoutRequested implements AuthEvent {
  const LogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class TokenExpired implements AuthEvent {
  const TokenExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.tokenExpired()';
}


}




/// @nodoc


class DeleteAccountRequested implements AuthEvent {
  const DeleteAccountRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.deleteAccountRequested()';
}


}




/// @nodoc


class CheckStoredAuth implements AuthEvent {
  const CheckStoredAuth();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckStoredAuth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkStoredAuth()';
}


}




// dart format on
