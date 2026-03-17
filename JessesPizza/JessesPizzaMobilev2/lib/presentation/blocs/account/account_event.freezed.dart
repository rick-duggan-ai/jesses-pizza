// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent()';
}


}

/// @nodoc
class $AccountEventCopyWith<$Res>  {
$AccountEventCopyWith(AccountEvent _, $Res Function(AccountEvent) __);
}


/// Adds pattern-matching-related methods to [AccountEvent].
extension AccountEventPatterns on AccountEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProfile value)?  loadProfile,TResult Function( LoadAddresses value)?  loadAddresses,TResult Function( SaveAddress value)?  saveAddress,TResult Function( DeleteAddress value)?  deleteAddress,TResult Function( LoadCreditCards value)?  loadCreditCards,TResult Function( SaveCard value)?  saveCard,TResult Function( DeleteCard value)?  deleteCard,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case LoadAddresses() when loadAddresses != null:
return loadAddresses(_that);case SaveAddress() when saveAddress != null:
return saveAddress(_that);case DeleteAddress() when deleteAddress != null:
return deleteAddress(_that);case LoadCreditCards() when loadCreditCards != null:
return loadCreditCards(_that);case SaveCard() when saveCard != null:
return saveCard(_that);case DeleteCard() when deleteCard != null:
return deleteCard(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProfile value)  loadProfile,required TResult Function( LoadAddresses value)  loadAddresses,required TResult Function( SaveAddress value)  saveAddress,required TResult Function( DeleteAddress value)  deleteAddress,required TResult Function( LoadCreditCards value)  loadCreditCards,required TResult Function( SaveCard value)  saveCard,required TResult Function( DeleteCard value)  deleteCard,}){
final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile(_that);case LoadAddresses():
return loadAddresses(_that);case SaveAddress():
return saveAddress(_that);case DeleteAddress():
return deleteAddress(_that);case LoadCreditCards():
return loadCreditCards(_that);case SaveCard():
return saveCard(_that);case DeleteCard():
return deleteCard(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProfile value)?  loadProfile,TResult? Function( LoadAddresses value)?  loadAddresses,TResult? Function( SaveAddress value)?  saveAddress,TResult? Function( DeleteAddress value)?  deleteAddress,TResult? Function( LoadCreditCards value)?  loadCreditCards,TResult? Function( SaveCard value)?  saveCard,TResult? Function( DeleteCard value)?  deleteCard,}){
final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile(_that);case LoadAddresses() when loadAddresses != null:
return loadAddresses(_that);case SaveAddress() when saveAddress != null:
return saveAddress(_that);case DeleteAddress() when deleteAddress != null:
return deleteAddress(_that);case LoadCreditCards() when loadCreditCards != null:
return loadCreditCards(_that);case SaveCard() when saveCard != null:
return saveCard(_that);case DeleteCard() when deleteCard != null:
return deleteCard(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadProfile,TResult Function()?  loadAddresses,TResult Function( Address address)?  saveAddress,TResult Function( Address address)?  deleteAddress,TResult Function()?  loadCreditCards,TResult Function( CreditCard card)?  saveCard,TResult Function( String cardId)?  deleteCard,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile();case LoadAddresses() when loadAddresses != null:
return loadAddresses();case SaveAddress() when saveAddress != null:
return saveAddress(_that.address);case DeleteAddress() when deleteAddress != null:
return deleteAddress(_that.address);case LoadCreditCards() when loadCreditCards != null:
return loadCreditCards();case SaveCard() when saveCard != null:
return saveCard(_that.card);case DeleteCard() when deleteCard != null:
return deleteCard(_that.cardId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadProfile,required TResult Function()  loadAddresses,required TResult Function( Address address)  saveAddress,required TResult Function( Address address)  deleteAddress,required TResult Function()  loadCreditCards,required TResult Function( CreditCard card)  saveCard,required TResult Function( String cardId)  deleteCard,}) {final _that = this;
switch (_that) {
case LoadProfile():
return loadProfile();case LoadAddresses():
return loadAddresses();case SaveAddress():
return saveAddress(_that.address);case DeleteAddress():
return deleteAddress(_that.address);case LoadCreditCards():
return loadCreditCards();case SaveCard():
return saveCard(_that.card);case DeleteCard():
return deleteCard(_that.cardId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadProfile,TResult? Function()?  loadAddresses,TResult? Function( Address address)?  saveAddress,TResult? Function( Address address)?  deleteAddress,TResult? Function()?  loadCreditCards,TResult? Function( CreditCard card)?  saveCard,TResult? Function( String cardId)?  deleteCard,}) {final _that = this;
switch (_that) {
case LoadProfile() when loadProfile != null:
return loadProfile();case LoadAddresses() when loadAddresses != null:
return loadAddresses();case SaveAddress() when saveAddress != null:
return saveAddress(_that.address);case DeleteAddress() when deleteAddress != null:
return deleteAddress(_that.address);case LoadCreditCards() when loadCreditCards != null:
return loadCreditCards();case SaveCard() when saveCard != null:
return saveCard(_that.card);case DeleteCard() when deleteCard != null:
return deleteCard(_that.cardId);case _:
  return null;

}
}

}

/// @nodoc


class LoadProfile implements AccountEvent {
  const LoadProfile();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProfile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.loadProfile()';
}


}




/// @nodoc


class LoadAddresses implements AccountEvent {
  const LoadAddresses();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddresses);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.loadAddresses()';
}


}




/// @nodoc


class SaveAddress implements AccountEvent {
  const SaveAddress({required this.address});
  

 final  Address address;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveAddressCopyWith<SaveAddress> get copyWith => _$SaveAddressCopyWithImpl<SaveAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveAddress&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AccountEvent.saveAddress(address: $address)';
}


}

/// @nodoc
abstract mixin class $SaveAddressCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $SaveAddressCopyWith(SaveAddress value, $Res Function(SaveAddress) _then) = _$SaveAddressCopyWithImpl;
@useResult
$Res call({
 Address address
});


$AddressCopyWith<$Res> get address;

}
/// @nodoc
class _$SaveAddressCopyWithImpl<$Res>
    implements $SaveAddressCopyWith<$Res> {
  _$SaveAddressCopyWithImpl(this._self, this._then);

  final SaveAddress _self;
  final $Res Function(SaveAddress) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(SaveAddress(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,
  ));
}

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

/// @nodoc


class DeleteAddress implements AccountEvent {
  const DeleteAddress({required this.address});
  

 final  Address address;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAddressCopyWith<DeleteAddress> get copyWith => _$DeleteAddressCopyWithImpl<DeleteAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAddress&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AccountEvent.deleteAddress(address: $address)';
}


}

/// @nodoc
abstract mixin class $DeleteAddressCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $DeleteAddressCopyWith(DeleteAddress value, $Res Function(DeleteAddress) _then) = _$DeleteAddressCopyWithImpl;
@useResult
$Res call({
 Address address
});


$AddressCopyWith<$Res> get address;

}
/// @nodoc
class _$DeleteAddressCopyWithImpl<$Res>
    implements $DeleteAddressCopyWith<$Res> {
  _$DeleteAddressCopyWithImpl(this._self, this._then);

  final DeleteAddress _self;
  final $Res Function(DeleteAddress) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(DeleteAddress(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,
  ));
}

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

/// @nodoc


class LoadCreditCards implements AccountEvent {
  const LoadCreditCards();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCreditCards);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.loadCreditCards()';
}


}




/// @nodoc


class SaveCard implements AccountEvent {
  const SaveCard({required this.card});
  

 final  CreditCard card;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveCardCopyWith<SaveCard> get copyWith => _$SaveCardCopyWithImpl<SaveCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveCard&&(identical(other.card, card) || other.card == card));
}


@override
int get hashCode => Object.hash(runtimeType,card);

@override
String toString() {
  return 'AccountEvent.saveCard(card: $card)';
}


}

/// @nodoc
abstract mixin class $SaveCardCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $SaveCardCopyWith(SaveCard value, $Res Function(SaveCard) _then) = _$SaveCardCopyWithImpl;
@useResult
$Res call({
 CreditCard card
});


$CreditCardCopyWith<$Res> get card;

}
/// @nodoc
class _$SaveCardCopyWithImpl<$Res>
    implements $SaveCardCopyWith<$Res> {
  _$SaveCardCopyWithImpl(this._self, this._then);

  final SaveCard _self;
  final $Res Function(SaveCard) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? card = null,}) {
  return _then(SaveCard(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CreditCard,
  ));
}

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditCardCopyWith<$Res> get card {
  
  return $CreditCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}

/// @nodoc


class DeleteCard implements AccountEvent {
  const DeleteCard({required this.cardId});
  

 final  String cardId;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteCardCopyWith<DeleteCard> get copyWith => _$DeleteCardCopyWithImpl<DeleteCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteCard&&(identical(other.cardId, cardId) || other.cardId == cardId));
}


@override
int get hashCode => Object.hash(runtimeType,cardId);

@override
String toString() {
  return 'AccountEvent.deleteCard(cardId: $cardId)';
}


}

/// @nodoc
abstract mixin class $DeleteCardCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $DeleteCardCopyWith(DeleteCard value, $Res Function(DeleteCard) _then) = _$DeleteCardCopyWithImpl;
@useResult
$Res call({
 String cardId
});




}
/// @nodoc
class _$DeleteCardCopyWithImpl<$Res>
    implements $DeleteCardCopyWith<$Res> {
  _$DeleteCardCopyWithImpl(this._self, this._then);

  final DeleteCard _self;
  final $Res Function(DeleteCard) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cardId = null,}) {
  return _then(DeleteCard(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
