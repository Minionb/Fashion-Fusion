import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                _buildAppBar1(),
                _buildAppBar2(),
              ];
            },
            body: GridView.builder(
              itemCount: ProductModel.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75),
              itemBuilder: (context, index) {
                final model = ProductModel.products[index];
                return Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      Expanded(
                          child: Image.asset(
                        model.imagePath,
                        fit: BoxFit.cover,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
                        child: Column(
                          children: [
                            10.verticalSpace,
                            Text(model.label),
                            10.verticalSpace,
                            Row(
                              children: [
                                Text(
                                  "\$${model.price.toStringAsFixed(2)}",
                                  style: TextStyle(color: AppColors.textGray),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    CupertinoIcons.add,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  SliverAppBar _buildAppBar1() {
    return SliverAppBar(
      expandedHeight: 150.sp,
      floating: false,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: const Icon(CupertinoIcons.line_horizontal_3),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.search),
                    10.horizontalSpace,
                    const Icon(CupertinoIcons.bell),
                    15.horizontalSpace
                  ],
                )
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0).w,
              child: Text(
                "Discover\nYour Best Clothing",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar2() {
    return SliverAppBar(
        pinned: true,
        elevation: 4,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: AppColors.bg,
        flexibleSpace: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).w,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 30,
          separatorBuilder: (context, index) => 5.horizontalSpace,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20).w,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkSeliver),
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text("Hi"),
              ),
            );
          },
        ));
  }
}

class ProductModel {
  final String label;
  final String imagePath;
  final double price;

  ProductModel(
      {required this.label, required this.imagePath, required this.price});

  static List<ProductModel> products = [
    ProductModel(
        label: "Double-breasted Trench Coat",
        imagePath: "${AppImages.imagePath}/1.jpeg",
        price: 0),
    ProductModel(
        label: "Double-breasted Blazer",
        imagePath: "${AppImages.imagePath}/2.jpeg",
        price: 0),
    ProductModel(
        label: "Wide-leg Pants",
        imagePath: "${AppImages.imagePath}/3.jpeg",
        price: 0),
    ProductModel(
        label: "Baggy Regular Jeans",
        imagePath: "${AppImages.imagePath}/4.jpeg",
        price: 0),
    ProductModel(
        label: "Jacquard-knit Sweater",
        imagePath: "${AppImages.imagePath}/5.jpeg",
        price: 0),
    ProductModel(
        label: "Puffer Vest",
        imagePath: "${AppImages.imagePath}/6.jpeg",
        price: 0),
    ProductModel(
        label: "Linen-blend Pull-on Pants",
        imagePath: "${AppImages.imagePath}/7.jpeg",
        price: 0),
    ProductModel(
        label: "Coated Bomber Jacket",
        imagePath: "${AppImages.imagePath}/8.jpeg",
        price: 0),
    ProductModel(
        label: "Linen-blend Pull-on Pants",
        imagePath: "${AppImages.imagePath}/9.jpeg",
        price: 0),
    ProductModel(
        label: "MAMA Straight Ankle Jeans",
        imagePath: "${AppImages.imagePath}/10.jpeg",
        price: 0),
    ProductModel(
        label: "Long-sleeved Jersey Top",
        imagePath: "${AppImages.imagePath}/11.jpeg",
        price: 0),
    ProductModel(
        label: "Curvy Fit Baggy Low Jeans",
        imagePath: "${AppImages.imagePath}/12.jpeg",
        price: 0),
  ];
}
