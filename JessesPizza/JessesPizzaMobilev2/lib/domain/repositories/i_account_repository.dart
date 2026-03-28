import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';

abstract class IAccountRepository {
  Future<Map<String, dynamic>> getAccountInfo();
  Future<List<Address>> getAddresses();
  Future<ApiResponse> saveAddress(Address address);
  Future<ApiResponse> deleteAddress(Address address);
  Future<List<CreditCard>> getCreditCards();
  Future<ApiResponse> saveCreditCard(CreditCard card);
  Future<ApiResponse> deleteCreditCard(String cardId);
  Future<String> getPrivacyPolicy();
}
