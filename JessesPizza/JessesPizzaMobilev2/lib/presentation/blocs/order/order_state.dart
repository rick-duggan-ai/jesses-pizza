import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';

part 'order_state.freezed.dart';

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState.initial() = OrderInitial;
  const factory OrderState.loading() = OrderLoading;
  const factory OrderState.orderSubmitted() = OrderSubmitted;
  const factory OrderState.hppTokenReady({
    required String token,
    required String transactionGuid,
  }) = HppTokenReady;
  const factory OrderState.historyLoaded({
    required List<Transaction> orders,
  }) = HistoryLoaded;
  const factory OrderState.orderDetailLoaded({
    required Transaction order,
  }) = OrderDetailLoaded;
  const factory OrderState.error({required String message}) = OrderError;
}
