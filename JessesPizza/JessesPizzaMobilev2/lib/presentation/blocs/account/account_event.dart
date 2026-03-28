import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';

part 'account_event.freezed.dart';

@freezed
abstract class AccountEvent with _$AccountEvent {
  const factory AccountEvent.loadProfile() = LoadProfile;
  const factory AccountEvent.loadAddresses() = LoadAddresses;
  const factory AccountEvent.saveAddress({required Address address}) = SaveAddress;
  const factory AccountEvent.deleteAddress({required Address address}) = DeleteAddress;
  const factory AccountEvent.loadCreditCards() = LoadCreditCards;
  const factory AccountEvent.saveCard({required CreditCard card}) = SaveCard;
  const factory AccountEvent.deleteCard({required String cardId}) = DeleteCard;
}
