import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/data/services/guest_transaction_storage.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository _repo;
  final GuestTransactionStorage? _guestStorage;

  OrderBloc({
    required IOrderRepository repository,
    GuestTransactionStorage? guestTransactionStorage,
  })  : _repo = repository,
        _guestStorage = guestTransactionStorage,
        super(const OrderState.initial()) {
    on<SubmitOrder>(_onSubmitOrder);
    on<RequestHppToken>(_onRequestHppToken);
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<LoadGuestOrderHistory>(_onLoadGuestOrderHistory);
    on<LoadOrderDetail>(_onLoadOrderDetail);
  }

  Future<void> _onSubmitOrder(
      SubmitOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final tx = event.request.transaction;
      final validation = await _repo.validateTransaction(tx);
      if (!validation.succeeded) {
        emit(OrderState.error(
            message: validation.message ?? 'Validation failed'));
        return;
      }
      final amountValidation =
          await _repo.validateTransactionAmount(tx.totals.total);
      if (!amountValidation.succeeded) {
        emit(OrderState.error(
            message: amountValidation.message ?? 'Amount validation failed'));
        return;
      }
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

  Future<void> _onLoadGuestOrderHistory(
      LoadGuestOrderHistory event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final guids = _guestStorage?.getGuids() ?? [];
      if (guids.isEmpty) {
        emit(const OrderState.historyLoaded(orders: []));
        return;
      }
      final orders = <Transaction>[];
      for (final guid in guids) {
        try {
          final order = await _repo.getTransactionByGuid(guid);
          orders.add(order);
        } catch (_) {
          // Skip GUIDs that can no longer be fetched.
        }
      }
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
