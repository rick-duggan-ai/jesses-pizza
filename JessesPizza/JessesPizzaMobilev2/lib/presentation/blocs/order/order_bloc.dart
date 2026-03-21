import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository _repo;

  OrderBloc({required IOrderRepository repository})
      : _repo = repository,
        super(const OrderState.initial()) {
    on<SubmitOrder>(_onSubmitOrder);
    on<RequestHppToken>(_onRequestHppToken);
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<LoadOrderDetail>(_onLoadOrderDetail);
  }

  Future<void> _onSubmitOrder(
      SubmitOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final tx = event.request.transaction;

      // Validate the transaction (checks store hours, zip code, city)
      final validation = await _repo.validateTransaction(tx);
      if (!validation.succeeded) {
        emit(OrderState.error(
            message: validation.message ?? 'Validation failed'));
        return;
      }

      // Validate the transaction amount meets minimum
      final amountValidation =
          await _repo.validateTransactionAmount(tx.totals.total);
      if (!amountValidation.succeeded) {
        emit(OrderState.error(
            message: amountValidation.message ?? 'Amount validation failed'));
        return;
      }

      // If validation returned a transactionGuid, attach it to the request
      final txWithGuid = validation.transactionGuid != null
          ? tx.copyWith(transactionId: validation.transactionGuid)
          : tx;

      final postRequest = PostTransactionRequest(
        transaction: txWithGuid,
        card: event.request.card,
      );
      await _repo.postTransaction(postRequest);
      emit(const OrderState.orderSubmitted());
    } catch (e) {
      emit(OrderState.error(message: e.toString()));
    }
  }

  Future<void> _onRequestHppToken(
      RequestHppToken event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      // Validate before requesting HPP token
      final validation = await _repo.validateTransaction(event.transaction);
      if (!validation.succeeded) {
        emit(OrderState.error(
            message: validation.message ?? 'Validation failed'));
        return;
      }
      final amountValidation = await _repo.validateTransactionAmount(
        event.transaction.totals.total,
      );
      if (!amountValidation.succeeded) {
        emit(OrderState.error(
            message: amountValidation.message ?? 'Amount validation failed'));
        return;
      }

      final txWithGuid = validation.transactionGuid != null
          ? event.transaction.copyWith(
              transactionId: validation.transactionGuid)
          : event.transaction;
      final token = await _repo.getHppToken(txWithGuid);
      emit(OrderState.hppTokenReady(
        token: token,
        transactionGuid: txWithGuid.transactionId ?? '',
      ));
    } catch (e) {
      emit(OrderState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadOrderHistory(
      LoadOrderHistory event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final orders = await _repo.getOrders();
      emit(OrderState.historyLoaded(orders: orders));
    } catch (e) {
      emit(OrderState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadOrderDetail(
      LoadOrderDetail event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final order = await _repo.getTransactionByGuid(event.guid);
      emit(OrderState.orderDetailLoaded(order: order));
    } catch (e) {
      emit(OrderState.error(message: e.toString()));
    }
  }
}
