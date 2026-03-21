import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState.initial() = AccountInitial;
  const factory AccountState.loading() = AccountLoading;
  const factory AccountState.loaded({
    required Map<String, dynamic> profile,
    required List<Address> addresses,
    required List<CreditCard> creditCards,
  }) = AccountLoaded;
  const factory AccountState.error({required String message}) = AccountError;
}
