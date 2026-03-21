import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required DateTime date,
    required double total,
    required bool isDelivery,
    String? name,
    String? transactionState,
    String? convergeTransactionId,
    @Default([]) List<TransactionItem> items,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String name,
    required double price,
    required int quantity,
    String? sizeName,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) => _$TransactionItemFromJson(json);
}
