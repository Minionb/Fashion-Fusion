import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/view/admin/widget/admin_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Best Selling Products"),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadedState) {
            final data = state.models;
            data.sort((a, b) => b.soldQuantity!.compareTo(a.soldQuantity!));
            return ListView.separated(
              itemBuilder: (context, index) {
                final model = data[index];
                return AdminProductCard(
                  model: model,
                  showQuantity: true,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: data.length,
            );
          }
          if (state is ProductIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is ProductErrorState) {
            return HelperMethod.emptyWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
