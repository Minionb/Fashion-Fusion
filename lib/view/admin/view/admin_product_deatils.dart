import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_edit_product.dart';
import 'package:flutter/material.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminProductDetailsScreen extends StatelessWidget {
  final ProductModel model;

  const AdminProductDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cursolImages(),
            Padding(
              padding: const EdgeInsets.all(15.0).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          model.productName ?? "",
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          '\$${model.price}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    model.category ?? "",
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${model.productDescription}",
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 14,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sold Quantity: ${model.soldQuantity}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tags: ${model.tags}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Created At: ${model.createdAt}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Updated At: ${model.updatedAt}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  20.verticalSpace,
                  CustomButton(
                    label: "Edit Product",
                    bg: Colors.red,
                    onPressed: () {
                      context.push(BlocProvider(
                        create: (context) => sl<ProductEditCubit>(),
                        child: AdminEditProductScreen(model: model),
                      ));
                    },
                  ),
                  50.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _cursolImages() {
    return SizedBox(
      width: double.infinity,
      child: FlutterCarousel(
        options: CarouselOptions(
          viewportFraction: 1,
          showIndicator: true,
          slideIndicator: const CircularSlideIndicator(),
        ),
        items: model.images?.map((i) {
          final image = "http://127.0.0.1:3000/products/images/$i";

          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: 1.sw,
                child: Image.network(
                  image,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
