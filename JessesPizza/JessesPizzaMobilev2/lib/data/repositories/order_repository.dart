import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';

class OrderRepository implements IOrderRepository {
  final ApiClient apiClient;

  OrderRepository({required this.apiClient});

  @override
  Future<ApiResponse> validateTransaction(
      TransactionRequest transaction) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.validateTransaction,
      data: transaction.toJson(),
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> validateTransactionAmount(double amount) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.validateTransactionAmount,
      data: amount,
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<ApiResponse> postTransaction(
      PostTransactionRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.postTransaction,
      data: request.toJson(),
      apiVersion: '1.1',
    );
    return ApiResponse.fromJson(response.data!);
  }

  @override
  Future<({String token, String transactionGuid})> getHppToken(
      TransactionRequest transaction) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.getHppToken,
      data: transaction.toJson(),
      apiVersion: '1.1',
    );
    // Newtonsoft (netcoreapp2.2) lowercases all leading uppercase letters:
    // HPPToken → hppToken. Fall back to hPPToken for System.Text.Json servers.
    final data = response.data!;
    final token = (data['hppToken'] ?? data['hPPToken']) as String?;
    if (token == null) throw Exception('HPP token missing from response');
    // TransactionGuid from the server is the customerCode used in SignalR events.
    final transactionGuid = data['transactionGuid']?.toString() ?? '';
    return (token: token, transactionGuid: transactionGuid);
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
