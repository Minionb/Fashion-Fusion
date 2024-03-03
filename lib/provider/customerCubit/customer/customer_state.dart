part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerIsLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final CustomerModel model;
  
  const CustomerLoadedState({required this.model});
}

class CustomerErrorState extends CustomerState {
  final String message;

  const CustomerErrorState({required this.message});
}
