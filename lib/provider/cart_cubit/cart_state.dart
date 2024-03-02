part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartIsLoadingState extends CartState {}

class CartSuccessState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemModel> models;
  
  const CartLoadedState({required this.models});
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState({required this.message});
}
