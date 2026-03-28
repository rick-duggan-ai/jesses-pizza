import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final IAccountRepository _repo;

  AccountBloc({required IAccountRepository repository})
      : _repo = repository,
        super(const AccountState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LoadAddresses>(_onLoadAddresses);
    on<SaveAddress>(_onSaveAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<LoadCreditCards>(_onLoadCreditCards);
    on<SaveCard>(_onSaveCard);
    on<DeleteCard>(_onDeleteCard);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      final profile = await _repo.getAccountInfo();
      final addresses = await _repo.getAddresses();
      final creditCards = await _repo.getCreditCards();
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadAddresses(
      LoadAddresses event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      final addresses = await _repo.getAddresses();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final creditCards = current is AccountLoaded ? current.creditCards : <CreditCard>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onSaveAddress(
      SaveAddress event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      await _repo.saveAddress(event.address);
      final addresses = await _repo.getAddresses();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final creditCards = current is AccountLoaded ? current.creditCards : <CreditCard>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      await _repo.deleteAddress(event.address);
      final addresses = await _repo.getAddresses();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final creditCards = current is AccountLoaded ? current.creditCards : <CreditCard>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadCreditCards(
      LoadCreditCards event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      final creditCards = await _repo.getCreditCards();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final addresses = current is AccountLoaded ? current.addresses : <Address>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onSaveCard(SaveCard event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      await _repo.saveCreditCard(event.card);
      final creditCards = await _repo.getCreditCards();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final addresses = current is AccountLoaded ? current.addresses : <Address>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }

  Future<void> _onDeleteCard(
      DeleteCard event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());
    try {
      await _repo.deleteCreditCard(event.cardId);
      final creditCards = await _repo.getCreditCards();
      final current = state;
      final profile = current is AccountLoaded ? current.profile : <String, dynamic>{};
      final addresses = current is AccountLoaded ? current.addresses : <Address>[];
      emit(AccountState.loaded(
        profile: profile,
        addresses: addresses,
        creditCards: creditCards,
      ));
    } catch (e) {
      emit(AccountState.error(message: e.toString()));
    }
  }
}
