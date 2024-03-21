import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/order/model/admin_update_status_model.dart';
import 'package:fashion_fusion/data/order/repository/order_repository.dart';

part 'order_edit_cubit_state.dart';

class OrderEditCubit extends Cubit<OrderEditState> {
  final OrderRepository repository;

  OrderEditCubit({required this.repository}) : super(OrderEditCubitInitial());

  void updateOrderStatus(AdminOrderUpdateStatusModel model) async {
    emit(OrderEditIsLoadingState());

    final response = await repository.updateOrderStatus(model);
    emit(response.fold(
        (l) => OrderEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => OrderEditSuccessfullyState(model: r)));
  }
}
