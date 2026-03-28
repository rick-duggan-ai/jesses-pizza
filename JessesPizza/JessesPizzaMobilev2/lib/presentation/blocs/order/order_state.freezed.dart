// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState()';
}


}

/// @nodoc
class $OrderStateCopyWith<$Res>  {
$OrderStateCopyWith(OrderState _, $Res Function(OrderState) __);
}


/// Adds pattern-matching-related methods to [OrderState].
extension OrderStatePatterns on OrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrderInitial value)?  initial,TResult Function( OrderLoading value)?  loading,TResult Function( OrderSubmitted value)?  orderSubmitted,TResult Function( HppTokenReady value)?  hppTokenReady,TResult Function( HistoryLoaded value)?  historyLoaded,TResult Function( OrderDetailLoaded value)?  orderDetailLoaded,TResult Function( OrderError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrderInitial() when initial != null:
return initial(_that);case OrderLoading() when loading != null:
return loading(_that);case OrderSubmitted() when orderSubmitted != null:
return orderSubmitted(_that);case HppTokenReady() when hppTokenReady != null:
return hppTokenReady(_that);case HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case OrderDetailLoaded() when orderDetailLoaded != null:
return orderDetailLoaded(_that);case OrderError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrderInitial value)  initial,required TResult Function( OrderLoading value)  loading,required TResult Function( OrderSubmitted value)  orderSubmitted,required TResult Function( HppTokenReady value)  hppTokenReady,required TResult Function( HistoryLoaded value)  historyLoaded,required TResult Function( OrderDetailLoaded value)  orderDetailLoaded,required TResult Function( OrderError value)  error,}){
final _that = this;
switch (_that) {
case OrderInitial():
return initial(_that);case OrderLoading():
return loading(_that);case OrderSubmitted():
return orderSubmitted(_that);case HppTokenReady():
return hppTokenReady(_that);case HistoryLoaded():
return historyLoaded(_that);case OrderDetailLoaded():
return orderDetailLoaded(_that);case OrderError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrderInitial value)?  initial,TResult? Function( OrderLoading value)?  loading,TResult? Function( OrderSubmitted value)?  orderSubmitted,TResult? Function( HppTokenReady value)?  hppTokenReady,TResult? Function( HistoryLoaded value)?  historyLoaded,TResult? Function( OrderDetailLoaded value)?  orderDetailLoaded,TResult? Function( OrderError value)?  error,}){
final _that = this;
switch (_that) {
case OrderInitial() when initial != null:
return initial(_that);case OrderLoading() when loading != null:
return loading(_that);case OrderSubmitted() when orderSubmitted != null:
return orderSubmitted(_that);case HppTokenReady() when hppTokenReady != null:
return hppTokenReady(_that);case HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case OrderDetailLoaded() when orderDetailLoaded != null:
return orderDetailLoaded(_that);case OrderError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  orderSubmitted,TResult Function( String token,  String transactionGuid)?  hppTokenReady,TResult Function( List<Transaction> orders)?  historyLoaded,TResult Function( Transaction order)?  orderDetailLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrderInitial() when initial != null:
return initial();case OrderLoading() when loading != null:
return loading();case OrderSubmitted() when orderSubmitted != null:
return orderSubmitted();case HppTokenReady() when hppTokenReady != null:
return hppTokenReady(_that.token,_that.transactionGuid);case HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.orders);case OrderDetailLoaded() when orderDetailLoaded != null:
return orderDetailLoaded(_that.order);case OrderError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  orderSubmitted,required TResult Function( String token,  String transactionGuid)  hppTokenReady,required TResult Function( List<Transaction> orders)  historyLoaded,required TResult Function( Transaction order)  orderDetailLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case OrderInitial():
return initial();case OrderLoading():
return loading();case OrderSubmitted():
return orderSubmitted();case HppTokenReady():
return hppTokenReady(_that.token,_that.transactionGuid);case HistoryLoaded():
return historyLoaded(_that.orders);case OrderDetailLoaded():
return orderDetailLoaded(_that.order);case OrderError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  orderSubmitted,TResult? Function( String token,  String transactionGuid)?  hppTokenReady,TResult? Function( List<Transaction> orders)?  historyLoaded,TResult? Function( Transaction order)?  orderDetailLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case OrderInitial() when initial != null:
return initial();case OrderLoading() when loading != null:
return loading();case OrderSubmitted() when orderSubmitted != null:
return orderSubmitted();case HppTokenReady() when hppTokenReady != null:
return hppTokenReady(_that.token,_that.transactionGuid);case HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.orders);case OrderDetailLoaded() when orderDetailLoaded != null:
return orderDetailLoaded(_that.order);case OrderError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class OrderInitial implements OrderState {
  const OrderInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.initial()';
}


}




/// @nodoc


class OrderLoading implements OrderState {
  const OrderLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.loading()';
}


}




/// @nodoc


class OrderSubmitted implements OrderState {
  const OrderSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.orderSubmitted()';
}


}




/// @nodoc


class HppTokenReady implements OrderState {
  const HppTokenReady({required this.token, required this.transactionGuid});
  

 final  String token;
 final  String transactionGuid;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HppTokenReadyCopyWith<HppTokenReady> get copyWith => _$HppTokenReadyCopyWithImpl<HppTokenReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HppTokenReady&&(identical(other.token, token) || other.token == token)&&(identical(other.transactionGuid, transactionGuid) || other.transactionGuid == transactionGuid));
}


@override
int get hashCode => Object.hash(runtimeType,token,transactionGuid);

@override
String toString() {
  return 'OrderState.hppTokenReady(token: $token, transactionGuid: $transactionGuid)';
}


}

/// @nodoc
abstract mixin class $HppTokenReadyCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory $HppTokenReadyCopyWith(HppTokenReady value, $Res Function(HppTokenReady) _then) = _$HppTokenReadyCopyWithImpl;
@useResult
$Res call({
 String token, String transactionGuid
});




}
/// @nodoc
class _$HppTokenReadyCopyWithImpl<$Res>
    implements $HppTokenReadyCopyWith<$Res> {
  _$HppTokenReadyCopyWithImpl(this._self, this._then);

  final HppTokenReady _self;
  final $Res Function(HppTokenReady) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,Object? transactionGuid = null,}) {
  return _then(HppTokenReady(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,transactionGuid: null == transactionGuid ? _self.transactionGuid : transactionGuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HistoryLoaded implements OrderState {
  const HistoryLoaded({required final  List<Transaction> orders}): _orders = orders;
  

 final  List<Transaction> _orders;
 List<Transaction> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadedCopyWith<HistoryLoaded> get copyWith => _$HistoryLoadedCopyWithImpl<HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoaded&&const DeepCollectionEquality().equals(other._orders, _orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));

@override
String toString() {
  return 'OrderState.historyLoaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory $HistoryLoadedCopyWith(HistoryLoaded value, $Res Function(HistoryLoaded) _then) = _$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Transaction> orders
});




}
/// @nodoc
class _$HistoryLoadedCopyWithImpl<$Res>
    implements $HistoryLoadedCopyWith<$Res> {
  _$HistoryLoadedCopyWithImpl(this._self, this._then);

  final HistoryLoaded _self;
  final $Res Function(HistoryLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(HistoryLoaded(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}


}

/// @nodoc


class OrderDetailLoaded implements OrderState {
  const OrderDetailLoaded({required this.order});
  

 final  Transaction order;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailLoadedCopyWith<OrderDetailLoaded> get copyWith => _$OrderDetailLoadedCopyWithImpl<OrderDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailLoaded&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderState.orderDetailLoaded(order: $order)';
}


}

/// @nodoc
abstract mixin class $OrderDetailLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory $OrderDetailLoadedCopyWith(OrderDetailLoaded value, $Res Function(OrderDetailLoaded) _then) = _$OrderDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Transaction order
});


$TransactionCopyWith<$Res> get order;

}
/// @nodoc
class _$OrderDetailLoadedCopyWithImpl<$Res>
    implements $OrderDetailLoadedCopyWith<$Res> {
  _$OrderDetailLoadedCopyWithImpl(this._self, this._then);

  final OrderDetailLoaded _self;
  final $Res Function(OrderDetailLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(OrderDetailLoaded(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Transaction,
  ));
}

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res> get order {
  
  return $TransactionCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class OrderError implements OrderState {
  const OrderError({required this.message});
  

 final  String message;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderErrorCopyWith<OrderError> get copyWith => _$OrderErrorCopyWithImpl<OrderError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OrderState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OrderErrorCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory $OrderErrorCopyWith(OrderError value, $Res Function(OrderError) _then) = _$OrderErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OrderErrorCopyWithImpl<$Res>
    implements $OrderErrorCopyWith<$Res> {
  _$OrderErrorCopyWithImpl(this._self, this._then);

  final OrderError _self;
  final $Res Function(OrderError) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OrderError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
