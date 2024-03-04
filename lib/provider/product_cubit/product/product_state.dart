part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductIsLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final ProductModel model;
  
  const ProductLoadedState({required this.model});
}

class ProductsLoadedState extends ProductState {
  final List<ProductModel> models;
  
  const ProductsLoadedState({required this.models});
}

class ProductErrorState extends ProductState {
  final String message;

  const ProductErrorState({required this.message});
}
