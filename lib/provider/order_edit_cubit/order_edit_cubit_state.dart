part of 'order_edit_cubit_cubit.dart';

sealed class OrderEditState extends Equatable {
  const OrderEditState();

  @override
  List<Object> get props => [];
}

final class OrderEditCubitInitial extends OrderEditState {}

class OrderEditIsLoadingState extends OrderEditState {}

class OrderEditSuccessfullyState extends OrderEditState {
  final AdminOrderUpdateStatusResponse model;

  const OrderEditSuccessfullyState({required this.model});
}

class OrderEditErrorState extends OrderEditState {
  final String message;

  const OrderEditErrorState({required this.message});
}
