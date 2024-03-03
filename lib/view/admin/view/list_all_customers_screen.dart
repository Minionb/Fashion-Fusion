import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/view/admin/widget/customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListAllCustomersScreen extends StatelessWidget {
  const ListAllCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        bottom: HelperMethod.appBarDivider(),
        title: const Text("Users"),
      ),
      body: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          if (state is CustomerIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is CustomerLoadedState) {
            final mdoel = state.model;
            return ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 50).w,
                itemBuilder: (context, index) {
                  final user = mdoel.model?[index];
                  return CustomerCard(user: user);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: mdoel.model?.length ?? 0);
          }
          if (state is CustomerErrorState) {
            return HelperMethod.emptyWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
