import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_add_product_screen.dart';
import 'package:fashion_fusion/view/admin/widget/admin_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminProductScreen extends StatelessWidget {
  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _addCategoryBtn(context),
      appBar: AppBar(
        title: const Text("Product"),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is ProductLoadedState) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return BlocProvider(
                    create: (context) => sl<ProductEditCubit>(),
                    child: AdminProductCard(model: state.models[index]),
                  );
                },
                separatorBuilder: (context, index) => 10.verticalSpace,
                itemCount: state.models.length);
          }
          if (state is ProductErrorState) {
            return HelperMethod.emptyWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }

  Container _addCategoryBtn(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 90).w,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(25).r),
        child: TextButton(
            onPressed: () {
              context.pushNamedNAV(BlocProvider(
                create: (context) => sl<ProductEditCubit>(),
                child: AdminAddProductScreen(),
              ));
            },
            child: const Text(
              "Add Product",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
