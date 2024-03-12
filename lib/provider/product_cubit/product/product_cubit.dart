import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/product/usecase/get_product_usecase.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
    final GetProductUsecase get;
  ProductCubit({required this.get}) : super(ProductInitial());

    void getProduct(productQueryParams) async {
    emit(ProductIsLoadingState());
    final response = await get(productQueryParams);
    emit(response.fold(
        (l) => ProductErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>ProductLoadedState(models: r)));
  }

}

