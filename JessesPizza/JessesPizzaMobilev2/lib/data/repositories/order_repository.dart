import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';

class OrderRepository implements IOrderRepository {
  final ApiClient apiClient;

  OrderRepository({required this.apiClient});

  @override
  Future<ApiResponse> validateTransaction(
      Map<String, dynamic> transaction) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.validateTransaction,
      data: transaction,
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> postTransaction(
      Map<String, dynamic> transaction) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.postTransaction,
      data: transaction,
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<String> getHppToken(Map<String, dynamic> transaction) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.getHppToken,
      data: transaction,
      apiVersion: '1.1',
    );
    return response.data!['hPPToken'] as String;
  }

  @override
  Future<List<Transaction>> getOrders() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.getOrders,
      apiVersion: '1.1',
    );
    final transactions = response.data!['transactions'] as List<dynamic>;
    return transactions
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Transaction> getTransactionByGuid(String guid) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.transactionGuid,
      queryParameters: {'guid': guid},
      apiVersion: '1.1',
    );
    return Transaction.fromJson(response.data!);
  }
}
