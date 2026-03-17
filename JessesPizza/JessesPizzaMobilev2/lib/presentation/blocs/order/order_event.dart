import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_event.freezed.dart';

@freezed
abstract class OrderEvent with _$OrderEvent {
  const factory OrderEvent.submitOrder({
    required Map<String, dynamic> transaction,
  }) = SubmitOrder;

  const factory OrderEvent.requestHppToken({
    required Map<String, dynamic> transaction,
  }) = RequestHppToken;

  const factory OrderEvent.loadOrderHistory() = LoadOrderHistory;

  const factory OrderEvent.loadOrderDetail({required String guid}) = LoadOrderDetail;
}
