import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_order/screen/admin_order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is OrderAdminLoadedState) {
            final data = state.model;
            return ListView.separated(
                itemBuilder: (context, index) {
                  final model = data[index];
                  return ListTile(
                    onTap: () {
                      context.push(BlocProvider(
                        create: (context) =>
                            sl<OrderCubit>()..getOrderId(model.orderId ?? ""),
                        child: AdminOrderDetailsScreen(
                          orderId: model.orderId,
                        ),
                      ));
                    },
                    title: Text(model.orderId ?? "fei"),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length);
          }
          if (state is ErrorState) {
            return HelperMethod.emptyWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
