import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/customer/model/upload_customer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/customer/usecase/add_customer_usecase.dart';
import '../../../../data/customer/usecase/delete_customer_usecase.dart';
import '../../../../data/customer/usecase/update_customer_usecase.dart';

part 'customer_edit_state.dart';

class CustomerEditCubit extends Cubit<CustomerEditState> {
  final AddCustomerUsecase add;
  final UpdateCustomerUsecase update;
  final DeleteCustomerUsecase delete;
  CustomerEditCubit(
      {required this.add, required this.update, required this.delete})
      : super(CustomerEditInitial());

  void addCustomer(UploadCustomerModel model) async {
    emit(CustomerEditIsLoadingState());
    final response = await add(model);
    emit(response.fold(
        (l) => CustomerEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>CustomerEditSuccessState()));
  }

  void updateCustomer(UploadCustomerModel model) async {
    emit(CustomerEditIsLoadingState());
    final response = await update(model);
    emit(response.fold(
        (l) => CustomerEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>CustomerEditSuccessState()));
  }

  void deleteCustomer(int id) async {
    emit(CustomerEditIsLoadingState());
    final response = await delete(id);
    emit(response.fold(
        (l) => CustomerEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>CustomerEditSuccessState()));
  }
}
