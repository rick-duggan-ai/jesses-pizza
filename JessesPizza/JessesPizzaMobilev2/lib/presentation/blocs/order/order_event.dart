import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';

part 'order_event.freezed.dart';

@freezed
abstract class OrderEvent with _$OrderEvent {
  const factory OrderEvent.submitOrder({
    required PostTransactionRequest request,
  }) = SubmitOrder;

  const factory OrderEvent.requestHppToken({
    required TransactionRequest transaction,
  }) = RequestHppToken;

  const factory OrderEvent.loadOrderHistory() = LoadOrderHistory;

  const factory OrderEvent.loadGuestOrderHistory() = LoadGuestOrderHistory;

  const factory OrderEvent.loadOrderDetail({required String guid}) = LoadOrderDetail;
}
