// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState()';
}


}

/// @nodoc
class $AccountStateCopyWith<$Res>  {
$AccountStateCopyWith(AccountState _, $Res Function(AccountState) __);
}


/// Adds pattern-matching-related methods to [AccountState].
extension AccountStatePatterns on AccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountInitial value)?  initial,TResult Function( AccountLoading value)?  loading,TResult Function( AccountLoaded value)?  loaded,TResult Function( AccountError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountInitial() when initial != null:
return initial(_that);case AccountLoading() when loading != null:
return loading(_that);case AccountLoaded() when loaded != null:
return loaded(_that);case AccountError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountInitial value)  initial,required TResult Function( AccountLoading value)  loading,required TResult Function( AccountLoaded value)  loaded,required TResult Function( AccountError value)  error,}){
final _that = this;
switch (_that) {
case AccountInitial():
return initial(_that);case AccountLoading():
return loading(_that);case AccountLoaded():
return loaded(_that);case AccountError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountInitial value)?  initial,TResult? Function( AccountLoading value)?  loading,TResult? Function( AccountLoaded value)?  loaded,TResult? Function( AccountError value)?  error,}){
final _that = this;
switch (_that) {
case AccountInitial() when initial != null:
return initial(_that);case AccountLoading() when loading != null:
return loading(_that);case AccountLoaded() when loaded != null:
return loaded(_that);case AccountError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Map<String, dynamic> profile,  List<Address> addresses,  List<CreditCard> creditCards)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountInitial() when initial != null:
return initial();case AccountLoading() when loading != null:
return loading();case AccountLoaded() when loaded != null:
return loaded(_that.profile,_that.addresses,_that.creditCards);case AccountError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Map<String, dynamic> profile,  List<Address> addresses,  List<CreditCard> creditCards)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AccountInitial():
return initial();case AccountLoading():
return loading();case AccountLoaded():
return loaded(_that.profile,_that.addresses,_that.creditCards);case AccountError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Map<String, dynamic> profile,  List<Address> addresses,  List<CreditCard> creditCards)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AccountInitial() when initial != null:
return initial();case AccountLoading() when loading != null:
return loading();case AccountLoaded() when loaded != null:
return loaded(_that.profile,_that.addresses,_that.creditCards);case AccountError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AccountInitial implements AccountState {
  const AccountInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.initial()';
}


}




/// @nodoc


class AccountLoading implements AccountState {
  const AccountLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.loading()';
}


}




/// @nodoc


class AccountLoaded implements AccountState {
  const AccountLoaded({required final  Map<String, dynamic> profile, required final  List<Address> addresses, required final  List<CreditCard> creditCards}): _profile = profile,_addresses = addresses,_creditCards = creditCards;
  

 final  Map<String, dynamic> _profile;
 Map<String, dynamic> get profile {
  if (_profile is EqualUnmodifiableMapView) return _profile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_profile);
}

 final  List<Address> _addresses;
 List<Address> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

 final  List<CreditCard> _creditCards;
 List<CreditCard> get creditCards {
  if (_creditCards is EqualUnmodifiableListView) return _creditCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_creditCards);
}


/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountLoadedCopyWith<AccountLoaded> get copyWith => _$AccountLoadedCopyWithImpl<AccountLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLoaded&&const DeepCollectionEquality().equals(other._profile, _profile)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&const DeepCollectionEquality().equals(other._creditCards, _creditCards));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_profile),const DeepCollectionEquality().hash(_addresses),const DeepCollectionEquality().hash(_creditCards));

@override
String toString() {
  return 'AccountState.loaded(profile: $profile, addresses: $addresses, creditCards: $creditCards)';
}


}

/// @nodoc
abstract mixin class $AccountLoadedCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountLoadedCopyWith(AccountLoaded value, $Res Function(AccountLoaded) _then) = _$AccountLoadedCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> profile, List<Address> addresses, List<CreditCard> creditCards
});




}
/// @nodoc
class _$AccountLoadedCopyWithImpl<$Res>
    implements $AccountLoadedCopyWith<$Res> {
  _$AccountLoadedCopyWithImpl(this._self, this._then);

  final AccountLoaded _self;
  final $Res Function(AccountLoaded) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? addresses = null,Object? creditCards = null,}) {
  return _then(AccountLoaded(
profile: null == profile ? _self._profile : profile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<Address>,creditCards: null == creditCards ? _self._creditCards : creditCards // ignore: cast_nullable_to_non_nullable
as List<CreditCard>,
  ));
}


}

/// @nodoc


class AccountError implements AccountState {
  const AccountError({required this.message});
  

 final  String message;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountErrorCopyWith<AccountError> get copyWith => _$AccountErrorCopyWithImpl<AccountError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AccountState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountErrorCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountErrorCopyWith(AccountError value, $Res Function(AccountError) _then) = _$AccountErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountErrorCopyWithImpl<$Res>
    implements $AccountErrorCopyWith<$Res> {
  _$AccountErrorCopyWithImpl(this._self, this._then);

  final AccountError _self;
  final $Res Function(AccountError) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
