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

class AdminProductScreen extends StatefulWidget {
  final String category;
  const AdminProductScreen({super.key, required this.category});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  Map<String, String> productQueryParams = {
    'category': '',
    'productName': '',
  };
  int catIndex = 0;
  String productName = "";

  TextEditingController searchController = TextEditingController();

  void handleSearchButtonTap() {
    setState(() {
      if (searchController.text != "") {
        productName = "${searchController.text}*";
        productQueryParams = {
          'category': widget.category,
          'productName': productName,
        };
      } else {
        productQueryParams = {
          'category': widget.category,
          'productName': '',
        };
      }
      context.read<ProductCubit>().getProduct(productQueryParams);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
        child: Scaffold(
      extendBody: true,
      bottomNavigationBar: _addCategoryBtn(context),
      appBar: AppBar(
        title: const Text("Product"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Products',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  handleSearchButtonTap();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductIsLoadingState) {
                return HelperMethod.loadinWidget();
              }
              if (state is ProductLoadedState) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductCubit>().getProduct(productQueryParams);
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return BlocProvider(
                          create: (context) => sl<ProductEditCubit>(),
                          child: AdminProductCard(model: state.models[index]),
                        );
                      },
                      separatorBuilder: (context, index) => 10.verticalSpace,
                      itemCount: state.models.length),
                );
              }
              if (state is ProductErrorState) {
                return HelperMethod.emptyWidget();
              }
              return const SizedBox();
            },
          ),
        )
      ]),
    ));
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
                child: const AdminAddProductScreen(),
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
