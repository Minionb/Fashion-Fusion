part of 'product_edit_cubit.dart';

abstract class ProductEditState extends Equatable {
  const ProductEditState();

  @override
  List<Object> get props => [];
}

class ProductEditInitial extends ProductEditState {}

class ProductEditIsLoadingState extends ProductEditState {}

class ProductEditSuccessState extends ProductEditState {}

class ProductEditErrorState extends ProductEditState {
  final String message;

  const ProductEditErrorState({required this.message});
}
