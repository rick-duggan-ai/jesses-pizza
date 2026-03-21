// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionRequest {

 CustomerInfo get info; List<TransactionItem> get transactionItems; OrderTotals get totals; bool get isDelivery; bool get noContactDelivery; String? get specialInstructions; String? get transactionId;
/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<TransactionRequest> get copyWith => _$TransactionRequestCopyWithImpl<TransactionRequest>(this as TransactionRequest, _$identity);

  /// Serializes this TransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRequest&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other.transactionItems, transactionItems)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.isDelivery, isDelivery) || other.isDelivery == isDelivery)&&(identical(other.noContactDelivery, noContactDelivery) || other.noContactDelivery == noContactDelivery)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(transactionItems),totals,isDelivery,noContactDelivery,specialInstructions,transactionId);

@override
String toString() {
  return 'TransactionRequest(info: $info, transactionItems: $transactionItems, totals: $totals, isDelivery: $isDelivery, noContactDelivery: $noContactDelivery, specialInstructions: $specialInstructions, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $TransactionRequestCopyWith<$Res>  {
  factory $TransactionRequestCopyWith(TransactionRequest value, $Res Function(TransactionRequest) _then) = _$TransactionRequestCopyWithImpl;
@useResult
$Res call({
 CustomerInfo info, List<TransactionItem> transactionItems, OrderTotals totals, bool isDelivery, bool noContactDelivery, String? specialInstructions, String? transactionId
});


$CustomerInfoCopyWith<$Res> get info;$OrderTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$TransactionRequestCopyWithImpl<$Res>
    implements $TransactionRequestCopyWith<$Res> {
  _$TransactionRequestCopyWithImpl(this._self, this._then);

  final TransactionRequest _self;
  final $Res Function(TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = null,Object? transactionItems = null,Object? totals = null,Object? isDelivery = null,Object? noContactDelivery = null,Object? specialInstructions = freezed,Object? transactionId = freezed,}) {
  return _then(_self.copyWith(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as CustomerInfo,transactionItems: null == transactionItems ? _self.transactionItems : transactionItems // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as OrderTotals,isDelivery: null == isDelivery ? _self.isDelivery : isDelivery // ignore: cast_nullable_to_non_nullable
as bool,noContactDelivery: null == noContactDelivery ? _self.noContactDelivery : noContactDelivery // ignore: cast_nullable_to_non_nullable
as bool,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<$Res> get info {
  
  return $CustomerInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTotalsCopyWith<$Res> get totals {
  
  return $OrderTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionRequest].
extension TransactionRequestPatterns on TransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomerInfo info,  List<TransactionItem> transactionItems,  OrderTotals totals,  bool isDelivery,  bool noContactDelivery,  String? specialInstructions,  String? transactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.info,_that.transactionItems,_that.totals,_that.isDelivery,_that.noContactDelivery,_that.specialInstructions,_that.transactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomerInfo info,  List<TransactionItem> transactionItems,  OrderTotals totals,  bool isDelivery,  bool noContactDelivery,  String? specialInstructions,  String? transactionId)  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest():
return $default(_that.info,_that.transactionItems,_that.totals,_that.isDelivery,_that.noContactDelivery,_that.specialInstructions,_that.transactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomerInfo info,  List<TransactionItem> transactionItems,  OrderTotals totals,  bool isDelivery,  bool noContactDelivery,  String? specialInstructions,  String? transactionId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.info,_that.transactionItems,_that.totals,_that.isDelivery,_that.noContactDelivery,_that.specialInstructions,_that.transactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionRequest implements TransactionRequest {
  const _TransactionRequest({required this.info, required final  List<TransactionItem> transactionItems, required this.totals, required this.isDelivery, this.noContactDelivery = false, this.specialInstructions, this.transactionId}): _transactionItems = transactionItems;
  factory _TransactionRequest.fromJson(Map<String, dynamic> json) => _$TransactionRequestFromJson(json);

@override final  CustomerInfo info;
 final  List<TransactionItem> _transactionItems;
@override List<TransactionItem> get transactionItems {
  if (_transactionItems is EqualUnmodifiableListView) return _transactionItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactionItems);
}

@override final  OrderTotals totals;
@override final  bool isDelivery;
@override@JsonKey() final  bool noContactDelivery;
@override final  String? specialInstructions;
@override final  String? transactionId;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRequestCopyWith<_TransactionRequest> get copyWith => __$TransactionRequestCopyWithImpl<_TransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRequest&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other._transactionItems, _transactionItems)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.isDelivery, isDelivery) || other.isDelivery == isDelivery)&&(identical(other.noContactDelivery, noContactDelivery) || other.noContactDelivery == noContactDelivery)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(_transactionItems),totals,isDelivery,noContactDelivery,specialInstructions,transactionId);

@override
String toString() {
  return 'TransactionRequest(info: $info, transactionItems: $transactionItems, totals: $totals, isDelivery: $isDelivery, noContactDelivery: $noContactDelivery, specialInstructions: $specialInstructions, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class _$TransactionRequestCopyWith<$Res> implements $TransactionRequestCopyWith<$Res> {
  factory _$TransactionRequestCopyWith(_TransactionRequest value, $Res Function(_TransactionRequest) _then) = __$TransactionRequestCopyWithImpl;
@override @useResult
$Res call({
 CustomerInfo info, List<TransactionItem> transactionItems, OrderTotals totals, bool isDelivery, bool noContactDelivery, String? specialInstructions, String? transactionId
});


@override $CustomerInfoCopyWith<$Res> get info;@override $OrderTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$TransactionRequestCopyWithImpl<$Res>
    implements _$TransactionRequestCopyWith<$Res> {
  __$TransactionRequestCopyWithImpl(this._self, this._then);

  final _TransactionRequest _self;
  final $Res Function(_TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = null,Object? transactionItems = null,Object? totals = null,Object? isDelivery = null,Object? noContactDelivery = null,Object? specialInstructions = freezed,Object? transactionId = freezed,}) {
  return _then(_TransactionRequest(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as CustomerInfo,transactionItems: null == transactionItems ? _self._transactionItems : transactionItems // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as OrderTotals,isDelivery: null == isDelivery ? _self.isDelivery : isDelivery // ignore: cast_nullable_to_non_nullable
as bool,noContactDelivery: null == noContactDelivery ? _self.noContactDelivery : noContactDelivery // ignore: cast_nullable_to_non_nullable
as bool,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<$Res> get info {
  
  return $CustomerInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTotalsCopyWith<$Res> get totals {
  
  return $OrderTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// @nodoc
mixin _$PostTransactionRequest {

 TransactionRequest get transaction; CreditCardRef get card;
/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostTransactionRequestCopyWith<PostTransactionRequest> get copyWith => _$PostTransactionRequestCopyWithImpl<PostTransactionRequest>(this as PostTransactionRequest, _$identity);

  /// Serializes this PostTransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostTransactionRequest&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.card, card) || other.card == card));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transaction,card);

@override
String toString() {
  return 'PostTransactionRequest(transaction: $transaction, card: $card)';
}


}

/// @nodoc
abstract mixin class $PostTransactionRequestCopyWith<$Res>  {
  factory $PostTransactionRequestCopyWith(PostTransactionRequest value, $Res Function(PostTransactionRequest) _then) = _$PostTransactionRequestCopyWithImpl;
@useResult
$Res call({
 TransactionRequest transaction, CreditCardRef card
});


$TransactionRequestCopyWith<$Res> get transaction;$CreditCardRefCopyWith<$Res> get card;

}
/// @nodoc
class _$PostTransactionRequestCopyWithImpl<$Res>
    implements $PostTransactionRequestCopyWith<$Res> {
  _$PostTransactionRequestCopyWithImpl(this._self, this._then);

  final PostTransactionRequest _self;
  final $Res Function(PostTransactionRequest) _then;

/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transaction = null,Object? card = null,}) {
  return _then(_self.copyWith(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as TransactionRequest,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CreditCardRef,
  ));
}
/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<$Res> get transaction {
  
  return $TransactionRequestCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditCardRefCopyWith<$Res> get card {
  
  return $CreditCardRefCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostTransactionRequest].
extension PostTransactionRequestPatterns on PostTransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostTransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostTransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _PostTransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostTransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PostTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionRequest transaction,  CreditCardRef card)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostTransactionRequest() when $default != null:
return $default(_that.transaction,_that.card);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionRequest transaction,  CreditCardRef card)  $default,) {final _that = this;
switch (_that) {
case _PostTransactionRequest():
return $default(_that.transaction,_that.card);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionRequest transaction,  CreditCardRef card)?  $default,) {final _that = this;
switch (_that) {
case _PostTransactionRequest() when $default != null:
return $default(_that.transaction,_that.card);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostTransactionRequest implements PostTransactionRequest {
  const _PostTransactionRequest({required this.transaction, required this.card});
  factory _PostTransactionRequest.fromJson(Map<String, dynamic> json) => _$PostTransactionRequestFromJson(json);

@override final  TransactionRequest transaction;
@override final  CreditCardRef card;

/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostTransactionRequestCopyWith<_PostTransactionRequest> get copyWith => __$PostTransactionRequestCopyWithImpl<_PostTransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostTransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostTransactionRequest&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.card, card) || other.card == card));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transaction,card);

@override
String toString() {
  return 'PostTransactionRequest(transaction: $transaction, card: $card)';
}


}

/// @nodoc
abstract mixin class _$PostTransactionRequestCopyWith<$Res> implements $PostTransactionRequestCopyWith<$Res> {
  factory _$PostTransactionRequestCopyWith(_PostTransactionRequest value, $Res Function(_PostTransactionRequest) _then) = __$PostTransactionRequestCopyWithImpl;
@override @useResult
$Res call({
 TransactionRequest transaction, CreditCardRef card
});


@override $TransactionRequestCopyWith<$Res> get transaction;@override $CreditCardRefCopyWith<$Res> get card;

}
/// @nodoc
class __$PostTransactionRequestCopyWithImpl<$Res>
    implements _$PostTransactionRequestCopyWith<$Res> {
  __$PostTransactionRequestCopyWithImpl(this._self, this._then);

  final _PostTransactionRequest _self;
  final $Res Function(_PostTransactionRequest) _then;

/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? card = null,}) {
  return _then(_PostTransactionRequest(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as TransactionRequest,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CreditCardRef,
  ));
}

/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<$Res> get transaction {
  
  return $TransactionRequestCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of PostTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditCardRefCopyWith<$Res> get card {
  
  return $CreditCardRefCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// @nodoc
mixin _$CreditCardRef {

 String get id; String? get cardNumber; String? get expirationDate; String? get shortDescription;
/// Create a copy of CreditCardRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditCardRefCopyWith<CreditCardRef> get copyWith => _$CreditCardRefCopyWithImpl<CreditCardRef>(this as CreditCardRef, _$identity);

  /// Serializes this CreditCardRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditCardRef&&(identical(other.id, id) || other.id == id)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cardNumber,expirationDate,shortDescription);

@override
String toString() {
  return 'CreditCardRef(id: $id, cardNumber: $cardNumber, expirationDate: $expirationDate, shortDescription: $shortDescription)';
}


}

/// @nodoc
abstract mixin class $CreditCardRefCopyWith<$Res>  {
  factory $CreditCardRefCopyWith(CreditCardRef value, $Res Function(CreditCardRef) _then) = _$CreditCardRefCopyWithImpl;
@useResult
$Res call({
 String id, String? cardNumber, String? expirationDate, String? shortDescription
});




}
/// @nodoc
class _$CreditCardRefCopyWithImpl<$Res>
    implements $CreditCardRefCopyWith<$Res> {
  _$CreditCardRefCopyWithImpl(this._self, this._then);

  final CreditCardRef _self;
  final $Res Function(CreditCardRef) _then;

/// Create a copy of CreditCardRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cardNumber = freezed,Object? expirationDate = freezed,Object? shortDescription = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditCardRef].
extension CreditCardRefPatterns on CreditCardRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditCardRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditCardRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditCardRef value)  $default,){
final _that = this;
switch (_that) {
case _CreditCardRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditCardRef value)?  $default,){
final _that = this;
switch (_that) {
case _CreditCardRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? cardNumber,  String? expirationDate,  String? shortDescription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditCardRef() when $default != null:
return $default(_that.id,_that.cardNumber,_that.expirationDate,_that.shortDescription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? cardNumber,  String? expirationDate,  String? shortDescription)  $default,) {final _that = this;
switch (_that) {
case _CreditCardRef():
return $default(_that.id,_that.cardNumber,_that.expirationDate,_that.shortDescription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? cardNumber,  String? expirationDate,  String? shortDescription)?  $default,) {final _that = this;
switch (_that) {
case _CreditCardRef() when $default != null:
return $default(_that.id,_that.cardNumber,_that.expirationDate,_that.shortDescription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditCardRef implements CreditCardRef {
  const _CreditCardRef({required this.id, this.cardNumber, this.expirationDate, this.shortDescription});
  factory _CreditCardRef.fromJson(Map<String, dynamic> json) => _$CreditCardRefFromJson(json);

@override final  String id;
@override final  String? cardNumber;
@override final  String? expirationDate;
@override final  String? shortDescription;

/// Create a copy of CreditCardRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditCardRefCopyWith<_CreditCardRef> get copyWith => __$CreditCardRefCopyWithImpl<_CreditCardRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditCardRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditCardRef&&(identical(other.id, id) || other.id == id)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cardNumber,expirationDate,shortDescription);

@override
String toString() {
  return 'CreditCardRef(id: $id, cardNumber: $cardNumber, expirationDate: $expirationDate, shortDescription: $shortDescription)';
}


}

/// @nodoc
abstract mixin class _$CreditCardRefCopyWith<$Res> implements $CreditCardRefCopyWith<$Res> {
  factory _$CreditCardRefCopyWith(_CreditCardRef value, $Res Function(_CreditCardRef) _then) = __$CreditCardRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String? cardNumber, String? expirationDate, String? shortDescription
});




}
/// @nodoc
class __$CreditCardRefCopyWithImpl<$Res>
    implements _$CreditCardRefCopyWith<$Res> {
  __$CreditCardRefCopyWithImpl(this._self, this._then);

  final _CreditCardRef _self;
  final $Res Function(_CreditCardRef) _then;

/// Create a copy of CreditCardRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cardNumber = freezed,Object? expirationDate = freezed,Object? shortDescription = freezed,}) {
  return _then(_CreditCardRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CustomerInfo {

 String get firstName; String get lastName; String get phoneNumber; String get emailAddress; String? get addressLine1; String? get city; String? get zipCode;
/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<CustomerInfo> get copyWith => _$CustomerInfoCopyWithImpl<CustomerInfo>(this as CustomerInfo, _$identity);

  /// Serializes this CustomerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInfo&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,phoneNumber,emailAddress,addressLine1,city,zipCode);

@override
String toString() {
  return 'CustomerInfo(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, emailAddress: $emailAddress, addressLine1: $addressLine1, city: $city, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class $CustomerInfoCopyWith<$Res>  {
  factory $CustomerInfoCopyWith(CustomerInfo value, $Res Function(CustomerInfo) _then) = _$CustomerInfoCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String phoneNumber, String emailAddress, String? addressLine1, String? city, String? zipCode
});




}
/// @nodoc
class _$CustomerInfoCopyWithImpl<$Res>
    implements $CustomerInfoCopyWith<$Res> {
  _$CustomerInfoCopyWithImpl(this._self, this._then);

  final CustomerInfo _self;
  final $Res Function(CustomerInfo) _then;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? phoneNumber = null,Object? emailAddress = null,Object? addressLine1 = freezed,Object? city = freezed,Object? zipCode = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerInfo].
extension CustomerInfoPatterns on CustomerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInfo value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String phoneNumber,  String emailAddress,  String? addressLine1,  String? city,  String? zipCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
return $default(_that.firstName,_that.lastName,_that.phoneNumber,_that.emailAddress,_that.addressLine1,_that.city,_that.zipCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String phoneNumber,  String emailAddress,  String? addressLine1,  String? city,  String? zipCode)  $default,) {final _that = this;
switch (_that) {
case _CustomerInfo():
return $default(_that.firstName,_that.lastName,_that.phoneNumber,_that.emailAddress,_that.addressLine1,_that.city,_that.zipCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String phoneNumber,  String emailAddress,  String? addressLine1,  String? city,  String? zipCode)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
return $default(_that.firstName,_that.lastName,_that.phoneNumber,_that.emailAddress,_that.addressLine1,_that.city,_that.zipCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerInfo implements CustomerInfo {
  const _CustomerInfo({required this.firstName, required this.lastName, required this.phoneNumber, required this.emailAddress, this.addressLine1, this.city, this.zipCode});
  factory _CustomerInfo.fromJson(Map<String, dynamic> json) => _$CustomerInfoFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  String phoneNumber;
@override final  String emailAddress;
@override final  String? addressLine1;
@override final  String? city;
@override final  String? zipCode;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInfoCopyWith<_CustomerInfo> get copyWith => __$CustomerInfoCopyWithImpl<_CustomerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInfo&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,phoneNumber,emailAddress,addressLine1,city,zipCode);

@override
String toString() {
  return 'CustomerInfo(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, emailAddress: $emailAddress, addressLine1: $addressLine1, city: $city, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class _$CustomerInfoCopyWith<$Res> implements $CustomerInfoCopyWith<$Res> {
  factory _$CustomerInfoCopyWith(_CustomerInfo value, $Res Function(_CustomerInfo) _then) = __$CustomerInfoCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String phoneNumber, String emailAddress, String? addressLine1, String? city, String? zipCode
});




}
/// @nodoc
class __$CustomerInfoCopyWithImpl<$Res>
    implements _$CustomerInfoCopyWith<$Res> {
  __$CustomerInfoCopyWithImpl(this._self, this._then);

  final _CustomerInfo _self;
  final $Res Function(_CustomerInfo) _then;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? phoneNumber = null,Object? emailAddress = null,Object? addressLine1 = freezed,Object? city = freezed,Object? zipCode = freezed,}) {
  return _then(_CustomerInfo(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransactionItem {

 String get menuItemId; String get name; String? get description; String get sizeName; String? get selectedSizeId; String? get imageUrl; bool get requiredChoicesEnabled; String? get requiredChoices; String? get requiredDelimitedString; bool get optionalChoicesEnabled; String? get optionalChoices; String? get optionalDelimitedString; int get quantity; double get price; bool get instructionsEnabled; String? get instructions;
/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemCopyWith<TransactionItem> get copyWith => _$TransactionItemCopyWithImpl<TransactionItem>(this as TransactionItem, _$identity);

  /// Serializes this TransactionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItem&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.selectedSizeId, selectedSizeId) || other.selectedSizeId == selectedSizeId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.requiredChoicesEnabled, requiredChoicesEnabled) || other.requiredChoicesEnabled == requiredChoicesEnabled)&&(identical(other.requiredChoices, requiredChoices) || other.requiredChoices == requiredChoices)&&(identical(other.requiredDelimitedString, requiredDelimitedString) || other.requiredDelimitedString == requiredDelimitedString)&&(identical(other.optionalChoicesEnabled, optionalChoicesEnabled) || other.optionalChoicesEnabled == optionalChoicesEnabled)&&(identical(other.optionalChoices, optionalChoices) || other.optionalChoices == optionalChoices)&&(identical(other.optionalDelimitedString, optionalDelimitedString) || other.optionalDelimitedString == optionalDelimitedString)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.instructionsEnabled, instructionsEnabled) || other.instructionsEnabled == instructionsEnabled)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuItemId,name,description,sizeName,selectedSizeId,imageUrl,requiredChoicesEnabled,requiredChoices,requiredDelimitedString,optionalChoicesEnabled,optionalChoices,optionalDelimitedString,quantity,price,instructionsEnabled,instructions);

@override
String toString() {
  return 'TransactionItem(menuItemId: $menuItemId, name: $name, description: $description, sizeName: $sizeName, selectedSizeId: $selectedSizeId, imageUrl: $imageUrl, requiredChoicesEnabled: $requiredChoicesEnabled, requiredChoices: $requiredChoices, requiredDelimitedString: $requiredDelimitedString, optionalChoicesEnabled: $optionalChoicesEnabled, optionalChoices: $optionalChoices, optionalDelimitedString: $optionalDelimitedString, quantity: $quantity, price: $price, instructionsEnabled: $instructionsEnabled, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class $TransactionItemCopyWith<$Res>  {
  factory $TransactionItemCopyWith(TransactionItem value, $Res Function(TransactionItem) _then) = _$TransactionItemCopyWithImpl;
@useResult
$Res call({
 String menuItemId, String name, String? description, String sizeName, String? selectedSizeId, String? imageUrl, bool requiredChoicesEnabled, String? requiredChoices, String? requiredDelimitedString, bool optionalChoicesEnabled, String? optionalChoices, String? optionalDelimitedString, int quantity, double price, bool instructionsEnabled, String? instructions
});




}
/// @nodoc
class _$TransactionItemCopyWithImpl<$Res>
    implements $TransactionItemCopyWith<$Res> {
  _$TransactionItemCopyWithImpl(this._self, this._then);

  final TransactionItem _self;
  final $Res Function(TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuItemId = null,Object? name = null,Object? description = freezed,Object? sizeName = null,Object? selectedSizeId = freezed,Object? imageUrl = freezed,Object? requiredChoicesEnabled = null,Object? requiredChoices = freezed,Object? requiredDelimitedString = freezed,Object? optionalChoicesEnabled = null,Object? optionalChoices = freezed,Object? optionalDelimitedString = freezed,Object? quantity = null,Object? price = null,Object? instructionsEnabled = null,Object? instructions = freezed,}) {
  return _then(_self.copyWith(
menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,selectedSizeId: freezed == selectedSizeId ? _self.selectedSizeId : selectedSizeId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,requiredChoicesEnabled: null == requiredChoicesEnabled ? _self.requiredChoicesEnabled : requiredChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiredChoices: freezed == requiredChoices ? _self.requiredChoices : requiredChoices // ignore: cast_nullable_to_non_nullable
as String?,requiredDelimitedString: freezed == requiredDelimitedString ? _self.requiredDelimitedString : requiredDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,optionalChoicesEnabled: null == optionalChoicesEnabled ? _self.optionalChoicesEnabled : optionalChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,optionalChoices: freezed == optionalChoices ? _self.optionalChoices : optionalChoices // ignore: cast_nullable_to_non_nullable
as String?,optionalDelimitedString: freezed == optionalDelimitedString ? _self.optionalDelimitedString : optionalDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,instructionsEnabled: null == instructionsEnabled ? _self.instructionsEnabled : instructionsEnabled // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItem].
extension TransactionItemPatterns on TransactionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItem value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  int quantity,  double price,  bool instructionsEnabled,  String? instructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.quantity,_that.price,_that.instructionsEnabled,_that.instructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  int quantity,  double price,  bool instructionsEnabled,  String? instructions)  $default,) {final _that = this;
switch (_that) {
case _TransactionItem():
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.quantity,_that.price,_that.instructionsEnabled,_that.instructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String menuItemId,  String name,  String? description,  String sizeName,  String? selectedSizeId,  String? imageUrl,  bool requiredChoicesEnabled,  String? requiredChoices,  String? requiredDelimitedString,  bool optionalChoicesEnabled,  String? optionalChoices,  String? optionalDelimitedString,  int quantity,  double price,  bool instructionsEnabled,  String? instructions)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.menuItemId,_that.name,_that.description,_that.sizeName,_that.selectedSizeId,_that.imageUrl,_that.requiredChoicesEnabled,_that.requiredChoices,_that.requiredDelimitedString,_that.optionalChoicesEnabled,_that.optionalChoices,_that.optionalDelimitedString,_that.quantity,_that.price,_that.instructionsEnabled,_that.instructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionItem implements TransactionItem {
  const _TransactionItem({required this.menuItemId, required this.name, this.description, required this.sizeName, this.selectedSizeId, this.imageUrl, this.requiredChoicesEnabled = false, this.requiredChoices, this.requiredDelimitedString, this.optionalChoicesEnabled = false, this.optionalChoices, this.optionalDelimitedString, required this.quantity, required this.price, this.instructionsEnabled = false, this.instructions});
  factory _TransactionItem.fromJson(Map<String, dynamic> json) => _$TransactionItemFromJson(json);

@override final  String menuItemId;
@override final  String name;
@override final  String? description;
@override final  String sizeName;
@override final  String? selectedSizeId;
@override final  String? imageUrl;
@override@JsonKey() final  bool requiredChoicesEnabled;
@override final  String? requiredChoices;
@override final  String? requiredDelimitedString;
@override@JsonKey() final  bool optionalChoicesEnabled;
@override final  String? optionalChoices;
@override final  String? optionalDelimitedString;
@override final  int quantity;
@override final  double price;
@override@JsonKey() final  bool instructionsEnabled;
@override final  String? instructions;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemCopyWith<_TransactionItem> get copyWith => __$TransactionItemCopyWithImpl<_TransactionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItem&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.selectedSizeId, selectedSizeId) || other.selectedSizeId == selectedSizeId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.requiredChoicesEnabled, requiredChoicesEnabled) || other.requiredChoicesEnabled == requiredChoicesEnabled)&&(identical(other.requiredChoices, requiredChoices) || other.requiredChoices == requiredChoices)&&(identical(other.requiredDelimitedString, requiredDelimitedString) || other.requiredDelimitedString == requiredDelimitedString)&&(identical(other.optionalChoicesEnabled, optionalChoicesEnabled) || other.optionalChoicesEnabled == optionalChoicesEnabled)&&(identical(other.optionalChoices, optionalChoices) || other.optionalChoices == optionalChoices)&&(identical(other.optionalDelimitedString, optionalDelimitedString) || other.optionalDelimitedString == optionalDelimitedString)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.instructionsEnabled, instructionsEnabled) || other.instructionsEnabled == instructionsEnabled)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuItemId,name,description,sizeName,selectedSizeId,imageUrl,requiredChoicesEnabled,requiredChoices,requiredDelimitedString,optionalChoicesEnabled,optionalChoices,optionalDelimitedString,quantity,price,instructionsEnabled,instructions);

@override
String toString() {
  return 'TransactionItem(menuItemId: $menuItemId, name: $name, description: $description, sizeName: $sizeName, selectedSizeId: $selectedSizeId, imageUrl: $imageUrl, requiredChoicesEnabled: $requiredChoicesEnabled, requiredChoices: $requiredChoices, requiredDelimitedString: $requiredDelimitedString, optionalChoicesEnabled: $optionalChoicesEnabled, optionalChoices: $optionalChoices, optionalDelimitedString: $optionalDelimitedString, quantity: $quantity, price: $price, instructionsEnabled: $instructionsEnabled, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemCopyWith<$Res> implements $TransactionItemCopyWith<$Res> {
  factory _$TransactionItemCopyWith(_TransactionItem value, $Res Function(_TransactionItem) _then) = __$TransactionItemCopyWithImpl;
@override @useResult
$Res call({
 String menuItemId, String name, String? description, String sizeName, String? selectedSizeId, String? imageUrl, bool requiredChoicesEnabled, String? requiredChoices, String? requiredDelimitedString, bool optionalChoicesEnabled, String? optionalChoices, String? optionalDelimitedString, int quantity, double price, bool instructionsEnabled, String? instructions
});




}
/// @nodoc
class __$TransactionItemCopyWithImpl<$Res>
    implements _$TransactionItemCopyWith<$Res> {
  __$TransactionItemCopyWithImpl(this._self, this._then);

  final _TransactionItem _self;
  final $Res Function(_TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuItemId = null,Object? name = null,Object? description = freezed,Object? sizeName = null,Object? selectedSizeId = freezed,Object? imageUrl = freezed,Object? requiredChoicesEnabled = null,Object? requiredChoices = freezed,Object? requiredDelimitedString = freezed,Object? optionalChoicesEnabled = null,Object? optionalChoices = freezed,Object? optionalDelimitedString = freezed,Object? quantity = null,Object? price = null,Object? instructionsEnabled = null,Object? instructions = freezed,}) {
  return _then(_TransactionItem(
menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,selectedSizeId: freezed == selectedSizeId ? _self.selectedSizeId : selectedSizeId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,requiredChoicesEnabled: null == requiredChoicesEnabled ? _self.requiredChoicesEnabled : requiredChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiredChoices: freezed == requiredChoices ? _self.requiredChoices : requiredChoices // ignore: cast_nullable_to_non_nullable
as String?,requiredDelimitedString: freezed == requiredDelimitedString ? _self.requiredDelimitedString : requiredDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,optionalChoicesEnabled: null == optionalChoicesEnabled ? _self.optionalChoicesEnabled : optionalChoicesEnabled // ignore: cast_nullable_to_non_nullable
as bool,optionalChoices: freezed == optionalChoices ? _self.optionalChoices : optionalChoices // ignore: cast_nullable_to_non_nullable
as String?,optionalDelimitedString: freezed == optionalDelimitedString ? _self.optionalDelimitedString : optionalDelimitedString // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,instructionsEnabled: null == instructionsEnabled ? _self.instructionsEnabled : instructionsEnabled // ignore: cast_nullable_to_non_nullable
as bool,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderTotals {

 double get taxTotal; double get deliveryCharge; double get subTotal; double get total; double get tip; String? get specialInstructions;
/// Create a copy of OrderTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTotalsCopyWith<OrderTotals> get copyWith => _$OrderTotalsCopyWithImpl<OrderTotals>(this as OrderTotals, _$identity);

  /// Serializes this OrderTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTotals&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.deliveryCharge, deliveryCharge) || other.deliveryCharge == deliveryCharge)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxTotal,deliveryCharge,subTotal,total,tip,specialInstructions);

@override
String toString() {
  return 'OrderTotals(taxTotal: $taxTotal, deliveryCharge: $deliveryCharge, subTotal: $subTotal, total: $total, tip: $tip, specialInstructions: $specialInstructions)';
}


}

/// @nodoc
abstract mixin class $OrderTotalsCopyWith<$Res>  {
  factory $OrderTotalsCopyWith(OrderTotals value, $Res Function(OrderTotals) _then) = _$OrderTotalsCopyWithImpl;
@useResult
$Res call({
 double taxTotal, double deliveryCharge, double subTotal, double total, double tip, String? specialInstructions
});




}
/// @nodoc
class _$OrderTotalsCopyWithImpl<$Res>
    implements $OrderTotalsCopyWith<$Res> {
  _$OrderTotalsCopyWithImpl(this._self, this._then);

  final OrderTotals _self;
  final $Res Function(OrderTotals) _then;

/// Create a copy of OrderTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taxTotal = null,Object? deliveryCharge = null,Object? subTotal = null,Object? total = null,Object? tip = null,Object? specialInstructions = freezed,}) {
  return _then(_self.copyWith(
taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,deliveryCharge: null == deliveryCharge ? _self.deliveryCharge : deliveryCharge // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as double,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTotals].
extension OrderTotalsPatterns on OrderTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTotals value)  $default,){
final _that = this;
switch (_that) {
case _OrderTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTotals value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double taxTotal,  double deliveryCharge,  double subTotal,  double total,  double tip,  String? specialInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTotals() when $default != null:
return $default(_that.taxTotal,_that.deliveryCharge,_that.subTotal,_that.total,_that.tip,_that.specialInstructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double taxTotal,  double deliveryCharge,  double subTotal,  double total,  double tip,  String? specialInstructions)  $default,) {final _that = this;
switch (_that) {
case _OrderTotals():
return $default(_that.taxTotal,_that.deliveryCharge,_that.subTotal,_that.total,_that.tip,_that.specialInstructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double taxTotal,  double deliveryCharge,  double subTotal,  double total,  double tip,  String? specialInstructions)?  $default,) {final _that = this;
switch (_that) {
case _OrderTotals() when $default != null:
return $default(_that.taxTotal,_that.deliveryCharge,_that.subTotal,_that.total,_that.tip,_that.specialInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderTotals implements OrderTotals {
  const _OrderTotals({this.taxTotal = 0, this.deliveryCharge = 0, this.subTotal = 0, this.total = 0, this.tip = 0, this.specialInstructions});
  factory _OrderTotals.fromJson(Map<String, dynamic> json) => _$OrderTotalsFromJson(json);

@override@JsonKey() final  double taxTotal;
@override@JsonKey() final  double deliveryCharge;
@override@JsonKey() final  double subTotal;
@override@JsonKey() final  double total;
@override@JsonKey() final  double tip;
@override final  String? specialInstructions;

/// Create a copy of OrderTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTotalsCopyWith<_OrderTotals> get copyWith => __$OrderTotalsCopyWithImpl<_OrderTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTotals&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.deliveryCharge, deliveryCharge) || other.deliveryCharge == deliveryCharge)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.specialInstructions, specialInstructions) || other.specialInstructions == specialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxTotal,deliveryCharge,subTotal,total,tip,specialInstructions);

@override
String toString() {
  return 'OrderTotals(taxTotal: $taxTotal, deliveryCharge: $deliveryCharge, subTotal: $subTotal, total: $total, tip: $tip, specialInstructions: $specialInstructions)';
}


}

/// @nodoc
abstract mixin class _$OrderTotalsCopyWith<$Res> implements $OrderTotalsCopyWith<$Res> {
  factory _$OrderTotalsCopyWith(_OrderTotals value, $Res Function(_OrderTotals) _then) = __$OrderTotalsCopyWithImpl;
@override @useResult
$Res call({
 double taxTotal, double deliveryCharge, double subTotal, double total, double tip, String? specialInstructions
});




}
/// @nodoc
class __$OrderTotalsCopyWithImpl<$Res>
    implements _$OrderTotalsCopyWith<$Res> {
  __$OrderTotalsCopyWithImpl(this._self, this._then);

  final _OrderTotals _self;
  final $Res Function(_OrderTotals) _then;

/// Create a copy of OrderTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taxTotal = null,Object? deliveryCharge = null,Object? subTotal = null,Object? total = null,Object? tip = null,Object? specialInstructions = freezed,}) {
  return _then(_OrderTotals(
taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,deliveryCharge: null == deliveryCharge ? _self.deliveryCharge : deliveryCharge // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as double,specialInstructions: freezed == specialInstructions ? _self.specialInstructions : specialInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
