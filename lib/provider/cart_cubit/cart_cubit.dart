import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:fashion_fusion/data/cart/repository/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit({required this.repository}) : super(CartInitial());

  void getCartItems() async {
    emit(CartIsLoadingState());
    final response = await repository.getCartItems();
    emit(response.fold(
        (l) => CartErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => CartLoadedState(models: r)));
  }
  void putCartItems(PutCartItemModel models) async {
    emit(CartIsLoadingState());
    final response = await repository.putCartItems(models);
    emit(response.fold(
        (l) => CartErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => CartSuccessState()));
  }
}
