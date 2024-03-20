part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderIsLoadingState extends OrderState {}

class OrderSuccessState extends OrderState {
  final OrderModel model;
  const OrderSuccessState({required this.model});
}

class OrderLoadedState extends OrderState {
  final OrderModel model;

  const OrderLoadedState({required this.model});
}

class OrderAdminLoadedState extends OrderState {
  final List<AdminOrderModel> model;

  const OrderAdminLoadedState({required this.model});
}

abstract class OrderListState extends OrderState {
  const OrderListState();

  @override
  List<Object> get props => [];
}

class OrderListLoadedState extends OrderListState {
  final List<OrderListModel> model;

  const OrderListLoadedState({required this.model});
}

class OrderUpdatedStatus extends OrderListState {
  final AdminOrderUpdateStatusResponse response;

  const OrderUpdatedStatus({required this.response});
}

class ErrorState extends OrderState {
  final String message;

  const ErrorState({required this.message});
}
