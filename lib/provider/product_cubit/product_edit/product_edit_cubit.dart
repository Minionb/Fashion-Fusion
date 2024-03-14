import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/product/model/upload_product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/product/usecase/add_product_usecase.dart';
import '../../../data/product/usecase/delete_product_usecase.dart';
import '../../../data/product/usecase/update_product_usecase.dart';
part 'product_edit_state.dart';

class ProductEditCubit extends Cubit<ProductEditState> {
  final AddProductUsecase add;
  final UpdateProductUsecase update;
  final DeleteProductUsecase delete;
  ProductEditCubit(
      {required this.add, required this.update, required this.delete})
      : super(ProductEditInitial());

  void addProduct(UploadProductModel model) async {
    emit(ProductEditIsLoadingState());
    final response = await add(model);
    emit(response.fold(
        (l) => ProductEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => ProductEditSuccessState()));
  }

  void updateProduct(UploadProductModel model,String id ) async {
    emit(ProductEditIsLoadingState());
    final response = await update(model,id);
    emit(response.fold(
        (l) => ProductEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => ProductEditSuccessState()));
  }

  void deleteProduct(String id) async {
    print("object");
    emit(ProductEditIsLoadingState());
    final response = await delete(id);
    emit(response.fold(
        (l) => ProductEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => ProductEditSuccessState()));
  }
}
