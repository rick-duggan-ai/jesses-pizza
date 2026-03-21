import 'package:flutter_bloc/flutter_bloc.dart';
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
      final validation = await _repo.validateTransaction(event.transaction);
      if (!validation.succeeded) {
        emit(OrderState.error(message: validation.message ?? 'Validation failed'));
        return;
      }
      await _repo.postTransaction(event.transaction);
      emit(const OrderState.orderSubmitted());
    } catch (e) {
      emit(OrderState.error(message: e.toString()));
    }
  }

  Future<void> _onRequestHppToken(
      RequestHppToken event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final token = await _repo.getHppToken(event.transaction);
      emit(OrderState.hppTokenReady(token: token));
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
