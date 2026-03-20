// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiResponse {

 bool get succeeded; String? get message; String? get transactionGuid;
/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResponseCopyWith<ApiResponse> get copyWith => _$ApiResponseCopyWithImpl<ApiResponse>(this as ApiResponse, _$identity);

  /// Serializes this ApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResponse&&(identical(other.succeeded, succeeded) || other.succeeded == succeeded)&&(identical(other.message, message) || other.message == message)&&(identical(other.transactionGuid, transactionGuid) || other.transactionGuid == transactionGuid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,succeeded,message,transactionGuid);

@override
String toString() {
  return 'ApiResponse(succeeded: $succeeded, message: $message, transactionGuid: $transactionGuid)';
}


}

/// @nodoc
abstract mixin class $ApiResponseCopyWith<$Res>  {
  factory $ApiResponseCopyWith(ApiResponse value, $Res Function(ApiResponse) _then) = _$ApiResponseCopyWithImpl;
@useResult
$Res call({
 bool succeeded, String? message, String? transactionGuid
});




}
/// @nodoc
class _$ApiResponseCopyWithImpl<$Res>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._self, this._then);

  final ApiResponse _self;
  final $Res Function(ApiResponse) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? succeeded = null,Object? message = freezed,Object? transactionGuid = freezed,}) {
  return _then(_self.copyWith(
succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,transactionGuid: freezed == transactionGuid ? _self.transactionGuid : transactionGuid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiResponse].
extension ApiResponsePatterns on ApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool succeeded,  String? message,  String? transactionGuid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
return $default(_that.succeeded,_that.message,_that.transactionGuid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool succeeded,  String? message,  String? transactionGuid)  $default,) {final _that = this;
switch (_that) {
case _ApiResponse():
return $default(_that.succeeded,_that.message,_that.transactionGuid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool succeeded,  String? message,  String? transactionGuid)?  $default,) {final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
return $default(_that.succeeded,_that.message,_that.transactionGuid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiResponse implements ApiResponse {
  const _ApiResponse({required this.succeeded, this.message, this.transactionGuid});
  factory _ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);

@override final  bool succeeded;
@override final  String? message;
@override final  String? transactionGuid;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiResponseCopyWith<_ApiResponse> get copyWith => __$ApiResponseCopyWithImpl<_ApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiResponse&&(identical(other.succeeded, succeeded) || other.succeeded == succeeded)&&(identical(other.message, message) || other.message == message)&&(identical(other.transactionGuid, transactionGuid) || other.transactionGuid == transactionGuid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,succeeded,message,transactionGuid);

@override
String toString() {
  return 'ApiResponse(succeeded: $succeeded, message: $message, transactionGuid: $transactionGuid)';
}


}

/// @nodoc
abstract mixin class _$ApiResponseCopyWith<$Res> implements $ApiResponseCopyWith<$Res> {
  factory _$ApiResponseCopyWith(_ApiResponse value, $Res Function(_ApiResponse) _then) = __$ApiResponseCopyWithImpl;
@override @useResult
$Res call({
 bool succeeded, String? message, String? transactionGuid
});




}
/// @nodoc
class __$ApiResponseCopyWithImpl<$Res>
    implements _$ApiResponseCopyWith<$Res> {
  __$ApiResponseCopyWithImpl(this._self, this._then);

  final _ApiResponse _self;
  final $Res Function(_ApiResponse) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? succeeded = null,Object? message = freezed,Object? transactionGuid = freezed,}) {
  return _then(_ApiResponse(
succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,transactionGuid: freezed == transactionGuid ? _self.transactionGuid : transactionGuid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
