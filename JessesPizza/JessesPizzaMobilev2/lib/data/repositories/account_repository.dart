import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';

class AccountRepository implements IAccountRepository {
  final ApiClient apiClient;

  AccountRepository({required this.apiClient});

  @override
  Future<Map<String, dynamic>> getAccountInfo() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.getAccountInfo,
      apiVersion: '1.0',
    );
    return response.data!['info'] as Map<String, dynamic>? ?? {};
  }

  @override
  Future<List<Address>> getAddresses() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.addresses,
      apiVersion: '1.0',
    );
    final list = response.data!['addresses'] as List<dynamic>? ?? [];
    return list
        .map((json) => Address.fromJson(json as Map<String, dynamic>))
        .where((a) => a.addressLine1.isNotEmpty)
        .toList();
  }

  @override
  Future<ApiResponse> saveAddress(Address address) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.saveAddress,
      data: address.toJson(),
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteAddress(Address address) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.deleteAddress,
      data: address.toJson(),
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<List<CreditCard>> getCreditCards() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.creditCards,
      apiVersion: '1.0',
    );
    final list = response.data!['creditCards'] as List<dynamic>? ?? [];
    return list.map((json) => CreditCard.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ApiResponse> saveCreditCard(CreditCard card) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.saveCreditCard,
      data: card.toJson(),
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteCreditCard(String cardId) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.deleteCard,
      data: {'cardId': cardId},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<String> getPrivacyPolicy() async {
    final response = await apiClient.get<String>(
      ApiEndpoints.privacy,
      apiVersion: '1.0',
    );
    return response.data!;
  }
}
