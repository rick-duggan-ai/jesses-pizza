import 'package:jesses_pizza_app/domain/models/api_response.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';

abstract class IOrderRepository {
  Future<ApiResponse> validateTransaction(TransactionRequest transaction);
  Future<ApiResponse> validateTransactionAmount(double amount);
  Future<ApiResponse> postTransaction(PostTransactionRequest request);
  Future<String> getHppToken(TransactionRequest transaction);
  Future<List<Transaction>> getOrders();
  Future<Transaction> getTransactionByGuid(String guid);
}
