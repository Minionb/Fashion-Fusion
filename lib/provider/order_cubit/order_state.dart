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

class ErrorState extends OrderState {
  final String message;

  const ErrorState({required this.message});
}
