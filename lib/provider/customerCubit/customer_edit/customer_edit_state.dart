part of 'customer_edit_cubit.dart';

abstract class CustomerEditState extends Equatable {
  const CustomerEditState();

  @override
  List<Object> get props => [];
}

class CustomerEditInitial extends CustomerEditState {}

class CustomerEditIsLoadingState extends CustomerEditState {}

class CustomerEditSuccessState extends CustomerEditState {}

class CustomerEditErrorState extends CustomerEditState {
  final String message;

  const CustomerEditErrorState({required this.message});
}
