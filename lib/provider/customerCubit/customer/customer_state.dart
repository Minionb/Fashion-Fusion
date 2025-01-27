part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerIsLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final List<CustomerDataModel> models;
  
  const CustomerLoadedState({required this.models});
}

class GetCustomerByIdLoadedState extends CustomerState {
  final CustomerDataModel model;
  
  const GetCustomerByIdLoadedState({required this.model});
}

class CustomerErrorState extends CustomerState {
  final String message;

  const CustomerErrorState({required this.message});
}
