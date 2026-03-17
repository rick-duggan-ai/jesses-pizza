import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';

abstract class IOrderRepository {
  Future<ApiResponse> validateTransaction(Map<String, dynamic> transaction);
  Future<ApiResponse> postTransaction(Map<String, dynamic> transaction);
  Future<String> getHppToken(Map<String, dynamic> transaction);
  Future<List<Transaction>> getOrders();
  Future<Transaction> getTransactionByGuid(String guid);
}
