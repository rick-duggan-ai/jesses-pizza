// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderEvent()';
}


}

/// @nodoc
class $OrderEventCopyWith<$Res>  {
$OrderEventCopyWith(OrderEvent _, $Res Function(OrderEvent) __);
}


/// Adds pattern-matching-related methods to [OrderEvent].
extension OrderEventPatterns on OrderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SubmitOrder value)?  submitOrder,TResult Function( RequestHppToken value)?  requestHppToken,TResult Function( LoadOrderHistory value)?  loadOrderHistory,TResult Function( LoadOrderDetail value)?  loadOrderDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SubmitOrder() when submitOrder != null:
return submitOrder(_that);case RequestHppToken() when requestHppToken != null:
return requestHppToken(_that);case LoadOrderHistory() when loadOrderHistory != null:
return loadOrderHistory(_that);case LoadOrderDetail() when loadOrderDetail != null:
return loadOrderDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SubmitOrder value)  submitOrder,required TResult Function( RequestHppToken value)  requestHppToken,required TResult Function( LoadOrderHistory value)  loadOrderHistory,required TResult Function( LoadOrderDetail value)  loadOrderDetail,}){
final _that = this;
switch (_that) {
case SubmitOrder():
return submitOrder(_that);case RequestHppToken():
return requestHppToken(_that);case LoadOrderHistory():
return loadOrderHistory(_that);case LoadOrderDetail():
return loadOrderDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SubmitOrder value)?  submitOrder,TResult? Function( RequestHppToken value)?  requestHppToken,TResult? Function( LoadOrderHistory value)?  loadOrderHistory,TResult? Function( LoadOrderDetail value)?  loadOrderDetail,}){
final _that = this;
switch (_that) {
case SubmitOrder() when submitOrder != null:
return submitOrder(_that);case RequestHppToken() when requestHppToken != null:
return requestHppToken(_that);case LoadOrderHistory() when loadOrderHistory != null:
return loadOrderHistory(_that);case LoadOrderDetail() when loadOrderDetail != null:
return loadOrderDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PostTransactionRequest request)?  submitOrder,TResult Function( TransactionRequest transaction)?  requestHppToken,TResult Function()?  loadOrderHistory,TResult Function( String guid)?  loadOrderDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubmitOrder() when submitOrder != null:
return submitOrder(_that.request);case RequestHppToken() when requestHppToken != null:
return requestHppToken(_that.transaction);case LoadOrderHistory() when loadOrderHistory != null:
return loadOrderHistory();case LoadOrderDetail() when loadOrderDetail != null:
return loadOrderDetail(_that.guid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PostTransactionRequest request)  submitOrder,required TResult Function( TransactionRequest transaction)  requestHppToken,required TResult Function()  loadOrderHistory,required TResult Function( String guid)  loadOrderDetail,}) {final _that = this;
switch (_that) {
case SubmitOrder():
return submitOrder(_that.request);case RequestHppToken():
return requestHppToken(_that.transaction);case LoadOrderHistory():
return loadOrderHistory();case LoadOrderDetail():
return loadOrderDetail(_that.guid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PostTransactionRequest request)?  submitOrder,TResult? Function( TransactionRequest transaction)?  requestHppToken,TResult? Function()?  loadOrderHistory,TResult? Function( String guid)?  loadOrderDetail,}) {final _that = this;
switch (_that) {
case SubmitOrder() when submitOrder != null:
return submitOrder(_that.request);case RequestHppToken() when requestHppToken != null:
return requestHppToken(_that.transaction);case LoadOrderHistory() when loadOrderHistory != null:
return loadOrderHistory();case LoadOrderDetail() when loadOrderDetail != null:
return loadOrderDetail(_that.guid);case _:
  return null;

}
}

}

/// @nodoc


class SubmitOrder implements OrderEvent {
  const SubmitOrder({required this.request});
  

 final  PostTransactionRequest request;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitOrderCopyWith<SubmitOrder> get copyWith => _$SubmitOrderCopyWithImpl<SubmitOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitOrder&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,request);

@override
String toString() {
  return 'OrderEvent.submitOrder(request: $request)';
}


}

/// @nodoc
abstract mixin class $SubmitOrderCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory $SubmitOrderCopyWith(SubmitOrder value, $Res Function(SubmitOrder) _then) = _$SubmitOrderCopyWithImpl;
@useResult
$Res call({
 PostTransactionRequest request
});


$PostTransactionRequestCopyWith<$Res> get request;

}
/// @nodoc
class _$SubmitOrderCopyWithImpl<$Res>
    implements $SubmitOrderCopyWith<$Res> {
  _$SubmitOrderCopyWithImpl(this._self, this._then);

  final SubmitOrder _self;
  final $Res Function(SubmitOrder) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,}) {
  return _then(SubmitOrder(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as PostTransactionRequest,
  ));
}

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostTransactionRequestCopyWith<$Res> get request {
  
  return $PostTransactionRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class RequestHppToken implements OrderEvent {
  const RequestHppToken({required this.transaction});
  

 final  TransactionRequest transaction;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestHppTokenCopyWith<RequestHppToken> get copyWith => _$RequestHppTokenCopyWithImpl<RequestHppToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestHppToken&&(identical(other.transaction, transaction) || other.transaction == transaction));
}


@override
int get hashCode => Object.hash(runtimeType,transaction);

@override
String toString() {
  return 'OrderEvent.requestHppToken(transaction: $transaction)';
}


}

/// @nodoc
abstract mixin class $RequestHppTokenCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory $RequestHppTokenCopyWith(RequestHppToken value, $Res Function(RequestHppToken) _then) = _$RequestHppTokenCopyWithImpl;
@useResult
$Res call({
 TransactionRequest transaction
});


$TransactionRequestCopyWith<$Res> get transaction;

}
/// @nodoc
class _$RequestHppTokenCopyWithImpl<$Res>
    implements $RequestHppTokenCopyWith<$Res> {
  _$RequestHppTokenCopyWithImpl(this._self, this._then);

  final RequestHppToken _self;
  final $Res Function(RequestHppToken) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = null,}) {
  return _then(RequestHppToken(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as TransactionRequest,
  ));
}

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<$Res> get transaction {
  
  return $TransactionRequestCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

/// @nodoc


class LoadOrderHistory implements OrderEvent {
  const LoadOrderHistory();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOrderHistory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderEvent.loadOrderHistory()';
}


}




/// @nodoc


class LoadOrderDetail implements OrderEvent {
  const LoadOrderDetail({required this.guid});
  

 final  String guid;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadOrderDetailCopyWith<LoadOrderDetail> get copyWith => _$LoadOrderDetailCopyWithImpl<LoadOrderDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOrderDetail&&(identical(other.guid, guid) || other.guid == guid));
}


@override
int get hashCode => Object.hash(runtimeType,guid);

@override
String toString() {
  return 'OrderEvent.loadOrderDetail(guid: $guid)';
}


}

/// @nodoc
abstract mixin class $LoadOrderDetailCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory $LoadOrderDetailCopyWith(LoadOrderDetail value, $Res Function(LoadOrderDetail) _then) = _$LoadOrderDetailCopyWithImpl;
@useResult
$Res call({
 String guid
});




}
/// @nodoc
class _$LoadOrderDetailCopyWithImpl<$Res>
    implements $LoadOrderDetailCopyWith<$Res> {
  _$LoadOrderDetailCopyWithImpl(this._self, this._then);

  final LoadOrderDetail _self;
  final $Res Function(LoadOrderDetail) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? guid = null,}) {
  return _then(LoadOrderDetail(
guid: null == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
