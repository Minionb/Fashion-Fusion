import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/customer/usecase/get_customer_usecase.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
    final GetCustomerUsecase get;
  CustomerCubit({required this.get}) : super(CustomerInitial());

    void getCustomer() async {
    emit(CustomerIsLoadingState());
    final response = await get();
    emit(response.fold(
        (l) => CustomerErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>CustomerLoadedState(model: r)));
  }

}

