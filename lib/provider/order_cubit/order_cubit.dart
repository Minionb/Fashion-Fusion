import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/order/model/admin_order_model.dart';
import 'package:fashion_fusion/data/order/model/admin_update_status_model.dart';
import 'package:fashion_fusion/data/order/model/order_list_model.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/data/order/repository/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit({required this.repository}) : super(OrderInitial());

  void postOrderCheckout(OrderModel model) async {
    emit(OrderIsLoadingState());
    final response = await repository.postOrderCheckout(model);
    emit(response.fold(
        (l) => ErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => OrderSuccessState(model: r)));
  }

  void getOrderId(String orderId) async {
    emit(OrderIsLoadingState());
    final response = await repository.getOrderById(orderId);
    emit(response.fold(
        (l) => ErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => OrderSuccessState(model: r)));
  }

  void getOrdersByCustomerId() async {
    emit(OrderIsLoadingState());
    final response = await repository.getOrderByCustomerId();
    emit(response.fold(
        (l) => ErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => OrderListLoadedState(model: r)));
  }

  void adminGetORders(orderQueryParams) async {
    emit(OrderIsLoadingState());
    final response = await repository.adminGetOrders(orderQueryParams);
    emit(response.fold(
        (l) => ErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => OrderAdminLoadedState(model: r)));
  }


}
