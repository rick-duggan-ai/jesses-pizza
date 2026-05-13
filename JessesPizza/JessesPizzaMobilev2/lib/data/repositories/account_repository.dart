import 'dart:math';

import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';

class AccountRepository implements IAccountRepository {
  final ApiClient apiClient;

  AccountRepository({required this.apiClient});

  static String _newGuid() {
    final rng = Random.secure();
    String hex(int count) => List.generate(count, (_) => rng.nextInt(16).toRadixString(16)).join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(8 + rng.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

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
    final addressData = <String, dynamic>{
      'id': address.id ?? _newGuid(),
      'addressLine1': address.addressLine1,
      'city': address.city,
      'zipCode': address.zipCode,
    };
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.saveAddress,
      data: {'address': addressData},
      apiVersion: '1.0',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> deleteAddress(Address address) async {
    final addressData = <String, dynamic>{
      'addressLine1': address.addressLine1,
      'city': address.city,
      'zipCode': address.zipCode,
    };
    if (address.id != null) addressData['id'] = address.id;
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.deleteAddress,
      data: {'address': addressData},
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
